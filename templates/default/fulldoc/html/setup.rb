include Helpers::ChefHelper

# Register custom stylesheets
def init
  # Maybe add an API endpoint for stats at some time
  # asset('api/stats.json', JSON.pretty_generate(YARD::CLI::Stats.new(false).statistics_hash))

  asset('css/chefdoc.css', file('css/chefdoc.css', true))

  super
end

def stylesheets_full_list
  %w[css/full_list.css css/common.css]
end

# Generates searchable recipe list in the output.
def generate_recipes_list
  recipes = chefsorted_objects(:recipe)
  generate_full_list(recipes, 'Recipe', 'recipes')
end

# Generates searchable attribute list in the output.
def generate_attributes_list
  attributes = chefsorted_objects(:attribute)
  generate_full_list(attributes, 'Attribute', 'attributes')
end

# Generates searchable resource list in the output.
def generate_resources_list
  resources = chefsorted_objects(:resource)
  generate_full_list(resources, 'Resource', 'resources')
end

# Called by menu_lists in layout/html/setup.rb by default
def generate_libraries_list
  libraries = YARD::Registry.all(:cookbook).first.libraries
  generate_full_list(libraries, 'Library', 'libraries')
end

def generate_full_list(objects, title, type)
  @items = objects
  @list_title = "#{title} List"
  @list_type = type.to_s
  asset(url_for_list(@list_type), erb(:full_list))
end

# The Class and class_list definition below are copies taken from YARD.
# @api private
class TreeContext
  def initialize
    @depth = 0
    @even_odd = Alternator.new(:even, :odd)
  end

  def nest
    @depth += 1
    yield
    @depth -= 1
  end

  # @return [String] Returns a css pixel offset, e.g. "30px"
  def indent
    "#{(@depth + 2) * 15}px"
  end

  def classes
    classes = []
    classes << 'collapsed' if @depth > 0
    classes << @even_odd.next if @depth < 2
    classes
  end

  class Alternator
    def initialize(first, second)
      @next = first
      @after = second
    end

    def next
      @next, @after = @after, @next
      @after
    end
  end
end

# rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
# @return [String] HTML output of the classes to be displayed in the
#    full_list_class template.
def class_list(root = Registry.root, tree = TreeContext.new)
  out = ''
  children = run_verifier(root.children)
  if root == Registry.root
    children += @items.select { |o| o.namespace.is_a?(CodeObjects::Proxy) }
  end
  children.compact.sort_by(&:path).each do |child|
    next if child.is_a?(::YARD::CodeObjects::Chef::RecipeObject)
    next unless child.is_a?(CodeObjects::NamespaceObject)
    name = child.namespace.is_a?(CodeObjects::Proxy) ? child.path : child.name
    has_children = run_verifier(child.children).any? { |o| o.is_a?(CodeObjects::NamespaceObject) }
    out << "<li id='object_#{child.path}' class='#{tree.classes.join(' ')}'>"
    out << "<div class='item' style='padding-left:#{tree.indent}'>"
    out << "<a class='toggle'></a> " if has_children
    out << linkify(child, name)
    out << " &lt; #{child.superclass.name}" if child.is_a?(CodeObjects::ClassObject) && child.superclass
    out << "<small class='search_info'>"
    out << child.namespace.title
    out << '</small>'
    out << '</div>'
    tree.nest do
      out << "<ul>#{class_list(child, tree)}</ul>" if has_children
    end
    out << '</li>'
  end
  out
end
# rubocop:enable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
