def init
  super
  @page_title = page_title
  if @file
    if @file.attributes[:namespace]
      @object = options.object = Registry.at(@file.attributes[:namespace]) || Registry.root
    end
    @breadcrumb_title = "File: #{@file.title}"
    @page_title = 'Cookbook Documentation'
    sections :layout, [:title, [T('cookbook')]]
  elsif object == '_index.html'
    @object = options.object = Registry.root
    sections :layout, [:title, [T('cookbook')]]
  end
end

def layout
  @nav_url = url_for_list(nav_select(options.index || options.object.type))

  @path = if !object || object.is_a?(String)
            nil
          elsif @file
            @file.path
          elsif !object.is_a?(YARD::CodeObjects::NamespaceObject)
            object.parent.path
          else
            object.path
          end

  erb(:layout)
end

def nav_select(type)
  case type.to_s
  when 'recipe'
    'recipes'
  when 'attribute'
    'attributes'
  when 'resource'
    'resources'
  when 'module', 'class'
    'libraries'
  when 'cookbook', 'root'
    'file'
  else
    'recipes'
  end
end

def javascripts
  super
end

def stylesheets
  super + %w[css/chefdoc.css]
end

# Add yard-chef specific menus
# Methods generate_#{type}_list  must be defined in fulldoc/html/setup.rb
def menu_lists
  [
    { type: 'recipes', title: 'Recipes', search_title: 'Recipe List' },
    { type: 'attributes', title: 'Attributes', search_title: 'Attributes List' },
    { type: 'resources', title: 'Resources', search_title: 'Resource List' },
    { type: 'libraries', title: 'Libraries', search_title: 'Libraries List' },
    { type: 'file', title: 'Files', search_title: 'File List' }
  ]
end

def page_title
  if object == '_index.html'
    'Cookbook Documentation'
  elsif object.is_a? CodeObjects::Base
    case object.type
    when :cookbook
      "Cookbook: #{object.name}"
    when :module, :class
      format_object_title(object)
    end
  end
end
