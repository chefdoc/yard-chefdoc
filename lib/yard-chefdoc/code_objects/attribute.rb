require 'yard'

module YARD::CodeObjects
  module Chef
    class AttributeObject < ChefObject
      register_element :attribute
      attr_accessor :attributes

      # Creates a new instance of the AttributeObject which represents a file in
      # the attributes directory.
      #
      # @param namespace [NamespaceObject] namespace to which the attribute belongs
      # @param name [String] name of the attribute file
      #
      # @return [AttributeObject] the newly created AttribteObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @attributes = []
      end

      # Add a single attribute as an Attribute object (see below)
      #
      # @param h [Hash] The attribute hash to add
      #
      def add(h)
        @attributes.push(Attribute.new(h))
      end
    end

    # Simple class to handle Attributes and their specifics
    class Attribute
      attr_accessor :default, # The default value
                    :path, # The attributes Hash path. Something like ['cookbook']['one']['two']
                    :docstring, # The attrbitues docstring
                    :precedence # The precedence the attribute is set with

      def initialize(h)
        h.each { |k, v| instance_variable_set("@#{k}", v) }
      end
    end
  end
end
