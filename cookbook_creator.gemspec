Gem::Specification.new do |s|
  s.name        = 'cookbook_creator'
  s.version     = '0.0.3'
  s.date        = '2016-01-11'
  s.summary     = "Everything required for cookbook generation"
  s.description = "This gem is used to generate cookbook skeleton"
  s.authors     = ['Serghei Anicheev']
  s.email       = 'sanicheev@tacitknowledge.com'
  s.require_paths = ['lib']
  s.required_ruby_version = '~> 2.2.1'
  s.bindir       = 'bin'
  s.executables  = [ 'cookbook_create' ]
  s.files = %w(README.md) + Dir.glob("*.gemspec") +
      Dir.glob("{lib,spec}/**/*", File::FNM_DOTMATCH).reject { |f|  File.directory?(f) }
  s.add_dependency "chef", "~> 12.6.0"
  s.add_dependency "bundler"
  s.add_dependency "berkshelf", "~> 4.0.1"
  s.add_dependency "berkshelf-api-client", "~> 2.0.0"
  s.add_dependency "chef-zero", "~> 4.4.0"
  s.add_dependency "kitchen", "~> 0.0.3"
  s.add_dependency "json", "~> 1.8.3"
  s.add_dependency "ohai", "~> 8.8.1"
  s.add_dependency "rake", "~> 10.4.2"
  s.add_dependency "rspec", "~> 3.4.0"
  s.add_dependency "chefspec", "~> 4.5.0"
  s.add_dependency "serverspec", "~> 2.25.0"
  s.add_dependency "mixlib-cli", "~> 1.5.0"
  s.add_dependency "mixlib-config", "~> 2.2.1"
 
  s.homepage    =
    'http://rubygems.org/gems/cookbook_creator'
  s.license       = 'Free License'
end
