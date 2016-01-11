class PathHelper
    def self.home(*args)
      @@home_dir ||= self.all_homes { |p| break p }
      if @@home_dir
        path = File.join(@@home_dir, *args)
        block_given? ? (yield path) : path
      end
    end

    def self.all_homes(*args)
      paths = []
      paths << Dir.home if ENV['HOME']

      paths = paths.map { |home_path| home_path.gsub(path_separator, ::File::SEPARATOR) if home_path }

      # Filter out duplicate paths and paths that don't exist.
      valid_paths = paths.select { |home_path| home_path && Dir.exists?(home_path) }
      valid_paths = valid_paths.uniq

      # Join all optional path elements at the end.
      # If a block is provided, invoke it - otherwise just return what we've got.
      joined_paths = valid_paths.map { |home_path| File.join(home_path, *args) }
      if block_given?
        joined_paths.each { |p| yield p }
      else
        joined_paths
      end
    end

    def self.path_separator
        File::SEPARATOR
    end
end
