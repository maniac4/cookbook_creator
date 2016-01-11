context = CookbookCreator::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)
p  context.cookbook_root
p context.cookbook_name
exit

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
  cookbook_file "#{cookbook_dir}/Berksfile" do
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

# git
if context.have_git

  cookbook_file "#{cookbook_dir}/.gitignore" do
    source "gitignore"
  end
end
