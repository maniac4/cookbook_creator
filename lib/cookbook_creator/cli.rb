#
# Author:: Anicheev Serghei (<sanicheev@tacitknowledge.com>)
# Copyright:: Copyright (c) 2016 Tacit Knowledge.
#

require 'mixlib/cli'

module CookbookCreator
  class MCLI
    include Mixlib::CLI

    option :config_file, 
      :short => "-c config_file",
      :long  => "--config",
      :description => "The configuration file to use",
      :default => ConfigLoader.new(nil, nil).config_location

    option :generator_cookbook,
      :short => "-g generator_cookbook",
      :long => "--generator_cookbook",
      :description => "Path to generator cookbook templates",
      :default => File.expand_path("../skeletons", __FILE__)

    option :maintainer, 
      :short => "-m maintainer",
      :long  => "--maintainer",
      :description => "Maintaining organisation",
      :default => 'Example Org.'

    option :maintainer_email, 
      :short => "-e maintainer_email",
      :long  => "--maintainer_email",
      :description => "Maintainers Email",
      :default => 'operator@example.org'

    option :provisioner,
      :short => "-p provisioner",
      :long  => "--provisioner",
      :description => "Provisioner to use",
      :default => 'chef_zero'

    option :license,
      :short => "-l license",
      :long  => "--license",
      :description => "License to use",
      :default => 'all_rights'

    option :platform,
      :short => "-P platform",
      :long  => "--platform",
      :description => "Platform to use",
      :default => 'centos-7.1'

    option :driver,
      :short => "-d driver",
      :long  => "--driver",
      :description => "Driver to use",
      :default => 'docker'

    option :image,
      :short => "-i driver",
      :long  => "--image",
      :description => "Docker image to use",
      :default => 'centos-7.1'

    option :supermarket_url,
      :short => "-s supermarket_url",
      :long  => "--supermarket_url",
      :description => "Supermarket URL",
      :default => 'https://supermarket.chef.io'

    option :lwrp,
      :short => "-L",
      :long  => "--lwrp",
      :description => "Should cookbook contain LWRP?",
      :boolean => true,
      :default => false

    option :lib,
      :short => "-i",
      :long  => "--lib",
      :description => "Should cookbook contain lib?",
      :boolean => true,
      :default => false

    option :help,
      :short => "-h",
      :long => "--help",
      :description => "Show this message",
      :on => :tail,
      :boolean => true,
      :show_options => true,
      :exit => 0

    def run(argv=[])
      parse_options(argv)
    end

  end
end
