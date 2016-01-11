#
# Author:: Anicheev Serghei (<sanicheev@tacitknowledge.com>)
# Copyright:: Copyright (c) 2016 Tacit Knowledge.
#

require 'mixlib/config'

module CookbookCreator
  class Config
    extend Mixlib::Config
      config_strict_mode true
      configurable :maintainer
      configurable :maintainer_email
      configurable :provisioner
      configurable :license
      configurable :platform
      configurable :driver
      configurable :supermarket_url
      configurable :lwrp
      configurable :lib
      configurable :generator_cookbook
      configurable :image
  end
end
