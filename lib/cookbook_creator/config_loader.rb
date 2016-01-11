#
# Author:: Anicheev Serghei (<sanicheev@tacitknowledge.com>)
# Copyright:: Copyright (c) 2016 Tacit Knowledge.
#
# Initially this code block was developed by Chef community.
# But in order to fit for our needs it was modified
#


require 'cookbook_creator/null_logger'
require 'cookbook_creator/pathhelper'
require 'pathname'

module CookbookCreator
  class ConfigLoader

    # Path to a config file requested by user, (e.g., via command line option). Can be nil
    attr_accessor :explicit_config_file

    def initialize(explicit_config_file, logger=nil)
      @explicit_config_file = explicit_config_file
      @generator_config_dir = nil
      @config_location = nil
      @logger = logger || NullLogger.new
    end

    def no_config_found?
      config_location.nil?
    end

    def config_location
      @config_location ||= (explicit_config_file || locate_local_config)
    end

    def generator_config_dir
      if @generator_config_dir.nil?
        @generator_config_dir = false
        full_path = working_directory.split(File::SEPARATOR)
        (full_path.length - 1).downto(0) do |i|
          candidate_directory = File.join(full_path[0..i] + [".generator"])
          if File.exist?(candidate_directory) && File.directory?(candidate_directory)
            @generator_config_dir = candidate_directory
            break
          end
        end
      end
      @generator_config_dir
    end

    def load
      # Ignore it if there's no explicit_config_file and can't find one at a
      # default path.
      return false if config_location.nil?

      if explicit_config_file && !path_exists?(config_location)
        raise "Specified config file #{config_location} does not exist"
      end

      # Have to set Config.config_file b/c other config is derived from it.
      Config.config_file = config_location
      read_config(IO.read(config_location), config_location)
    end

    # (Private API, public for test purposes)
    def env
      ENV
    end

    # (Private API, public for test purposes)
    def path_exists?(path)
      Pathname.new(path).expand_path.exist?
    end

    private

    def have_config?(path)
      if path_exists?(path)
        logger.info("Using config at #{path}")
        true
      else
        logger.debug("Config not found at #{path}, trying next option")
        false
      end
    end

    def locate_local_config
      candidate_configs = []

      # Look for $COOKBOOK_GENERATOR_HOME/generator.rb (allow multiple generator config on same machine)
      if env['COOKBOOK_GENERATOR_HOME']
        candidate_configs << File.join(env['COOKBOOK_GENERATOR_HOME'], 'generator.rb')
      end
      # Look for $PWD/generator.rb
      if Dir.pwd
        candidate_configs << File.join(Dir.pwd, 'generator.rb')
      end
      # Look for $UPWARD/.generator/generator.rb
      if generator_config_dir
        candidate_configs << File.join(generator_config_dir, 'generator.rb')
      end
      # Look for $HOME/.generator/generator.rb
      PathHelper.home('.generator') do |dot_generator_dir|
        candidate_configs << File.join(dot_generator_dir, 'generator.rb')
      end

      candidate_configs.find do | candidate_config |
        have_config?(candidate_config)
      end
    end

    def working_directory
      Dir.pwd
    end

    def read_config(config_content, config_file_path)
      Config.from_string(config_content, config_file_path)
    rescue SignalException
      raise
    rescue SyntaxError => e
      message = ""
      message << "You have invalid ruby syntax in your config file #{config_file_path}\n\n"
      message << "#{e.class.name}: #{e.message}\n"
      if file_line = e.message[/#{Regexp.escape(config_file_path)}:[\d]+/]
        line = file_line[/:([\d]+)$/, 1].to_i
        message << highlight_config_error(config_file_path, line)
      end
      raise ChefConfig::ConfigurationError, message
    rescue Exception => e
      message = "You have an error in your config file #{config_file_path}\n\n"
      message << "#{e.class.name}: #{e.message}\n"
      filtered_trace = e.backtrace.grep(/#{Regexp.escape(config_file_path)}/)
      filtered_trace.each {|bt_line| message << "  " << bt_line << "\n" }
      if !filtered_trace.empty?
        line_nr = filtered_trace.first[/#{Regexp.escape(config_file_path)}:([\d]+)/, 1]
        message << highlight_config_error(config_file_path, line_nr.to_i)
      end
      raise ChefConfig::ConfigurationError, message
    end


    def highlight_config_error(file, line)
      config_file_lines = []
      IO.readlines(file).each_with_index {|l, i| config_file_lines << "#{(i + 1).to_s.rjust(3)}: #{l.chomp}"}
      if line == 1
        lines = config_file_lines[0..3]
      else
        lines = config_file_lines[Range.new(line - 2, line)]
      end
      "Relevant file content:\n" + lines.join("\n") + "\n"
    end

    def logger
      @logger
    end

  end
end
