include Helpers::ChefHelper
include T('default/module')

def init
  sections :cookbook_title,
           [
             :metadata,
             :docstring,
             :generated_docs,
             [
               :recipes,
               :attributes,
               :resources,
               :libraries
             ]
           ]
end
