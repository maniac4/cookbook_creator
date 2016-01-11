#
# Author:: Anicheev Serghei (<sanicheev@tacitknowledge.com>)
# Copyright:: Copyright (c) 2016 Tacit Knowledge.
#
# Initially this code block was developed by Chef community.
# But in order to fit for our needs it was modified
#

module CookbookCreator

  module Generator
    # This is here to hold attr_accessor data for Generator context variables
    class Context


      def self.add_attr(name)
        @attributes ||= [ ]

        if !@attributes.include?(name)
          @attributes << name
          attr_accessor(name)
        end
      end

        def self.cookbook_root
          File.dirname(cookbook_full_path)
        end

        def self.cookbook_full_path
          File.expand_path(cookbook_name_or_path, Dir.pwd)
        end
      
        def self.cookbook_name_or_path
           name = ARGV[0]
           File.expand_path(name, Dir.pwd)
        end

        def self.recipe
          "cookbook"
        end

        def self.recipe_name
          "default"
        end

        def self.cookbook_name
          File.basename(cookbook_full_path)
        end

        def self.have_git?
          path = ENV["PATH"] || ""
          paths = path.split(File::PATH_SEPARATOR)
          paths.any? {|bin_path| File.exist?(File.join(bin_path, "git#{RbConfig::CONFIG['EXEEXT']}"))}
        end

      def self.reset
        return if @attributes.nil?

        @attributes.each do |attr|
          remove_method(attr)
        end

        @attributes = nil
      end
    end

    def self.reset
      @context = nil
    end

    def self.context
      @context ||= Context.new
    end

    def self.add_attr_to_context(name, value=nil)
      sym_name = name.to_sym
      CookbookCreator::Generator::Context.add_attr(sym_name)
      CookbookCreator::Generator::TemplateHelper.delegate_to_app_context(sym_name)
      context.public_send("#{sym_name}=", value)
    end

    def self.setup_context(config_options)
      CookbookCreator::Generator.add_attr_to_context(:cookbook_root, CookbookCreator::Generator::Context.cookbook_root)
      CookbookCreator::Generator.add_attr_to_context(:cookbook_name, CookbookCreator::Generator::Context.cookbook_name)
      CookbookCreator::Generator.add_attr_to_context(:recipe_name, CookbookCreator::Generator::Context.recipe_name)
      CookbookCreator::Generator.add_attr_to_context(:copyright_holder, config_options[:maintainer])
      CookbookCreator::Generator.add_attr_to_context(:email, config_options[:maintainer_email])
      CookbookCreator::Generator.add_attr_to_context(:license, config_options[:license])
      CookbookCreator::Generator.add_attr_to_context(:provisioner, config_options[:provisioner])
      CookbookCreator::Generator.add_attr_to_context(:driver, config_options[:driver])
      CookbookCreator::Generator.add_attr_to_context(:platform, config_options[:platform])
      CookbookCreator::Generator.add_attr_to_context(:supermarket_url, config_options[:supermarket_url])
      CookbookCreator::Generator.add_attr_to_context(:lwrp, config_options[:lwrp])
      CookbookCreator::Generator.add_attr_to_context(:lib, config_options[:lib])
      CookbookCreator::Generator.add_attr_to_context(:image, config_options[:image])
    end

    module TemplateHelper

      def self.delegate_to_app_context(name)
        define_method(name) do
          CookbookCreator::Generator.context.public_send(name)
        end
      end

      def year
        Time.now.year
      end

      # Prints the short description of the license, suitable for use in a
      # preamble to a file. Optionally specify a comment to prepend to each line.
      def license_description(comment=nil)
        case license
        when 'all_rights'
          result = "Copyright (c) #{year} #{copyright_holder}, All Rights Reserved."
        when 'apache2'
          result = <<-EOH
Copyright #{year} #{copyright_holder}

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
EOH
        when 'mit'
          result = <<-EOH
The MIT License (MIT)

Copyright (c) #{year} #{copyright_holder}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
EOH
        when 'gplv2'
          result = <<-EOH
Copyright (C) #{year}  #{copyright_holder}

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
EOH
        when 'gplv3'
          result = <<-EOH
Copyright (C) #{year}  #{copyright_holder}

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
EOH
        end
        if comment
          # Ensure there's no trailing whitespace
          result.gsub(/^(.+)$/, "#{comment} \\1").gsub(/^$/, "#{comment}")
        else
          result
        end
      end
    end

  end
end
