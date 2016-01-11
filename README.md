# Cookbook Creator

Cookbook Creator role is to provide lightweight mechanism of initial cookbook generation from template.

## Installation

You can install it by using a command:
`gem install cookbook_creator`

## Dependencies

Cookbook Creator during its installation will also install required gems:
* chef
* berkshelf
* kitchen
* json
* ohai
* rake
* rspec
* chefspec
* serverspec
* mixlib-cli
* mixlib-config
* chef-zero

## Usage

`cookbook_create <cookbook_name> <options>`

Where:
* <cookbook_name> is obligatory
* <options> can be:
  - `-c, --config <path_to_custom_config_file>`
  - `-g, --generator_cookbook <path to custom cookbook template>`
  - `-m, --maintainer <maintainer>`
  - `-e, --maintainer_email <maintainer_email>`
  - `-p, --provisioner <provisioner_to_use>` # Default is chef_zero
  - `-l, --license <license_name>`
  - `-P, --platform <platform>`
  - `-d, --driver <driver>` # Docker is the default
  - `-i, --image <image_name> # Used only if selected driver is docker`
  - `-s, --supermarket_url <url>` # Custom supermarket URL. Is usefull in case we have our own private supermarket
  - `-L, --lwrp` # Will be generated LWRP skeleton
  - `-b, --lib` # Will be generated library skeleton

## Config options

Config file could has following options:
  - `maintainer '<maintainer>'`
  - `maintainer_email '<maintainer_email>'`
  - `provisioner '<provisioner>'`
  - `license '<license>'`
  - `platform '<platform>'`
  - `driver '<driver>'`
  - `supermarket_url '<supermarket_url>'`
  - `lwrp '<true_or_false>'`
  - `lib '<true_or_false>'`
  - `generator_cookbook '<path_to_custom_templates>'`
  - `image '<docker_image>'`

## Config locations

By default Cookbook Creator will search for config file in following places:
* Under `env['COOKBOOK_CREATOR_HOME']/generator.rb` if set
* Under `Current directory/generator.rb`
* Under `Current directory/.generator/generator.rb`
* Under `$HOME/.generator/generator.rb`

## Options merging

Options will be merged in the following order:
* Initially will be build hash with default options from CLI
* CLI options will be overwritten by the options within config file
* Config file options will be overwritten by any arguments which will be passed to the script

*WARNING:* Cookbook Creator can have some bugs.
Please report to sanicheev@tacitknowledge.com if you will find any.
