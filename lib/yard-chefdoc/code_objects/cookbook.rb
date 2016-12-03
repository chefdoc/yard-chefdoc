require 'yard'

module YARD::CodeObjects
  module Chef
    # A CookbookObject represents a Chef cookbook.
    # See http://wiki.opscode.com/display/chef/Cookbooks for more information
    # about cookbooks.
    #
    class CookbookObject < ChefObject
      register_element :cookbook

      attr_accessor :docstring_type

      # Cookbook metadata
      attr_accessor :dependencies
      attr_accessor :version
      attr_accessor :source_url
      attr_accessor :issues_url
      attr_accessor :maintainer
      attr_accessor :maintainer_email
      attr_accessor :license
      attr_accessor :platforms
      attr_accessor :gems

      # Creates a new CookbookObject instance.
      # @param namespace [NamespaceObject] namespace to which the cookbook
      # belongs
      # @param name [String] name of the cookbook
      #
      # @return [CookbookObject] the newly created CookbookObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @docstring_type = :markdown
      end

      # Libraries defined in the cookbook.
      # Catches all classes, modules and defintion directly defined without a namespace
      #
      # @return [Array] libraries in the cookbook
      #
      def libraries
        modules = YARD::Registry.all(:module)
        classes = YARD::Registry.all(:class)
        root_definitions = YARD::Registry.all(:method).select { |m| m.path =~ /^root#/ }

        classes + modules + root_definitions
      end

      def metadata
        [@version, @maintainer, @dependencies]
      end
    end
  end
end
