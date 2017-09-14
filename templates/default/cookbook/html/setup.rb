include Helpers::ChefHelper
include T('default/module')

def init
  @cookbook_statistics = YARD::CLI::Stats.new(false).statistics_hash

  recipe_parts = %I[recipes attributes resources libraries]
  sections [:cookbook_title, :metadata, :docstring, :generated_docs, recipe_parts]
end
