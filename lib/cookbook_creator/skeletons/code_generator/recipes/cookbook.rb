context = CookbookCreator::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)

# cookbook root dir
directory cookbook_dir

# metadata.rb
template "#{cookbook_dir}/metadata.rb" do
  helpers(CookbookCreator::Generator::TemplateHelper)
  action :create_if_missing
end

# README
template "#{cookbook_dir}/README.md" do
  helpers(CookbookCreator::Generator::TemplateHelper)
  action :create_if_missing
end

# chefignore
cookbook_file "#{cookbook_dir}/chefignore"

# Berks
template "#{cookbook_dir}/Berksfile" do
  helpers(CookbookCreator::Generator::TemplateHelper)
  source 'Berksfile.erb'
  action :create_if_missing
end

# CookbookCreator & Serverspec
template "#{cookbook_dir}/.kitchen.yml" do
  source 'kitchen.yml.erb'
  helpers(CookbookCreator::Generator::TemplateHelper)
  action :create_if_missing
end

directory "#{cookbook_dir}/test/integration/default/serverspec" do
  recursive true
end

directory "#{cookbook_dir}/test/integration/helpers/serverspec" do
  recursive true
end

cookbook_file "#{cookbook_dir}/test/integration/helpers/serverspec/spec_helper.rb" do
  source 'serverspec_spec_helper.rb'
  action :create_if_missing
end

template "#{cookbook_dir}/test/integration/default/serverspec/default_spec.rb" do
  source 'serverspec_default_spec.rb.erb'
  helpers(CookbookCreator::Generator::TemplateHelper)
  action :create_if_missing
end

# Chefspec
directory "#{cookbook_dir}/spec/unit/recipes" do
  recursive true
end

cookbook_file "#{cookbook_dir}/spec/spec_helper.rb" do
  source "spec_helper.rb"
  action :create_if_missing
end

template "#{cookbook_dir}/spec/unit/recipes/default_spec.rb" do
  source "recipe_spec.rb.erb"
  helpers(CookbookCreator::Generator::TemplateHelper)
  action :create_if_missing
end

# Recipes
directory "#{cookbook_dir}/recipes"

template "#{cookbook_dir}/recipes/default.rb" do
  source "recipe.rb.erb"
  helpers(CookbookCreator::Generator::TemplateHelper)
  action :create_if_missing
end

# Libraries
if context.lib
  directory "#{cookbook_dir}/libraries"

  template "#{cookbook_dir}/libraries/default.rb" do
    source "library.rb.erb"
    helpers(CookbookCreator::Generator::TemplateHelper)
    action :create_if_missing
  end
end

#LWRP
if context.lwrp
  directory "#{cookbook_dir}/resources"
  directory "#{cookbook_dir}/providers"

  template "#{cookbook_dir}/resources/default.rb" do
    source "resource.rb.erb"
    helpers(CookbookCreator::Generator::TemplateHelper)
    action :create_if_missing
  end

  template "#{cookbook_dir}/providers/default.rb" do
    source "provider.rb.erb"
    helpers(CookbookCreator::Generator::TemplateHelper)
    action :create_if_missing
  end
end

# git
cookbook_file "#{cookbook_dir}/.gitignore" do
  source "gitignore"
end
