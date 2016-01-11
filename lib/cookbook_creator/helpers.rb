#
# Author:: Anicheev Serghei (<sanicheev@tacitknowledge.com>)
# Copyright:: Copyright (c) 2016 Tacit Knowledge.
#

module CookbookCreator
  class Helpers

    def self.load_config_file(default_options, modified_options)
      config_file = default_options.merge!(modified_options)[:config_file]
      File.exists?(config_file) ? config_file : raise_er
    end

    def raise_er
      raise 'Selected config file does not exists or does not have read permissions'
    end

    def self.merge_configs(default_config, config, sym_hash)
      combined_config = default_config.merge!(sym_hash)
      combined_config_options = combined_config.merge(config)
      config.replace(combined_config_options)
    end

  end
end
