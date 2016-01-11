require 'chef'
require 'ohai'
require 'chef/config'

module CookbookCreator
class Runner

    def initialize(cookbook_path, run_list)
      @cookbook_path = File.expand_path(cookbook_path)
      @run_list = run_list
      @formatter = nil
      @ohai = nil
    end

    def converge
      configure
      Chef::Runner.new(run_context).converge
    rescue Chef::Exceptions::CookbookNotFound => e
      message = "Could not find cookbook(s) to satisfy run list #{run_list.inspect} in #{cookbook_path}"
      raise CookbookNotFound.new(message, e)
    rescue => e
      raise ChefConvergeError.new("Chef failed to converge: #{e}", e)
    end

    def run_context
      @run_context ||= policy.setup_run_context
    end

    def policy
      return @policy_builder if @policy_builder
      @policy_builder = Chef::PolicyBuilder::Dynamic.new("generator-cookbook", ohai.data, {}, nil, formatter)
      @policy_builder.load_node
      @policy_builder.build_node
      @policy_builder.node.run_list(@run_list)
      @policy_builder.expand_run_list
      @policy_builder
    end

    def configure
      Chef::Config.solo = true
      Chef::Config.cookbook_path = @cookbook_path
      Chef::Config.color = true
      Chef::Config.diff_disabled = true
      # atomic file operations on Windows require Administrator privileges to be able to read the SACL from a file
      # Using file_staging_uses_destdir(true) will get us inherited permissions indirectly on tempfile creation
      Chef::Config.file_atomic_update = false if Chef::Platform.windows?
      Chef::Config.file_staging_uses_destdir = true # Default in Chef 12+
    end

    def ohai
      return @ohai if @ohai

      @ohai = Ohai::System.new
      @ohai.all_plugins(["platform", "platform_version"])
      @ohai
    end

    def formatter
      @formatter ||=
        Chef::EventDispatch::Dispatcher.new.tap do |d|
          d.register(Chef::Formatters.new(:doc, stdout, stderr))
        end
    end

    def stdout
      $stdout
    end

    def stderr
      $stderr
    end

end
end
