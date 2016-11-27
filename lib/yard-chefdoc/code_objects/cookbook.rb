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

      # Short description for the cookbook.
      #
      # @param short_desc [String] short description for the cookbook
      #
      # @return [String] short description for the cookbook
      #
      attr_accessor :short_desc

      # Version of the cookbook.
      #
      # @param version [String] version for the cookbook
      #
      # @return [String] version for the cookbook
      #
      attr_accessor :version

      # Creates a new CookbookObject instance.
      # @param namespace [NamespaceObject] namespace to which the cookbook
      # belongs
      # @param name [String] name of the cookbook
      #
      # @return [CookbookObject] the newly created CookbookObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @libraries = []
        @docstring_type = :markdown
      end

      # Dependencies of the cookbook.
      #
      # @return [Array<MethodObject>] dependencies of the cookbook
      #
      # TODO: Impement this! And display it in some nice way!
      def dependencies
        []
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
    end
  end
end
