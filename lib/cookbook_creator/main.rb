#
# Author:: Anicheev Serghei (<sanicheev@tacitknowledge.com>)
# Copyright:: Copyright (c) 2016 Tacit Knowledge.
#

require 'mixlib/cli'
require 'mixlib/config'
require 'cookbook_creator/config_loader'
require 'cookbook_creator/cli'
require 'cookbook_creator/helpers'
require 'cookbook_creator/generator'
require 'cookbook_creator/runner'
require 'cookbook_creator/config'

module CookbookCreator
  class Main

    attr_reader :params

    def initialize(argv=[])
      @cookbook_name = argv[0]
      @params = argv
    end  

    def run
      config_location = ConfigLoader.new(nil, nil).config_location
      CookbookCreator::MCLI.use_separate_default_options true
      cli = CookbookCreator::MCLI.new
      cli.run(@params)
      generator_config = Helpers::load_config_file(cli.default_config, cli.config)
      Config.from_file(generator_config)
      sym_hash = Config.configuration.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      Helpers.merge_configs(cli.default_config, cli.config, sym_hash)
      run_list = ["recipe[code_generator::cookbook]"]
      cookbook_root =  Generator::Context.cookbook_root
      runner = Runner.new(cli.config[:generator_cookbook], run_list)  
      Generator.setup_context(cli.config)
      runner.converge
    end

  end
end
