require 'yard'

module YARD::CodeObjects
  module Chef
    # The chef object will be the root of your namespace
    class ChefObject < YARD::CodeObjects::NamespaceObject
      # We initialize certain data in the handler and not when creating the
      # code object. Thus the state here.
      attr_accessor :initialized

      # Creates a new ChefObject object.
      #
      # @param namespace [NamespaceObject] namespace to which the object belongs
      # @param name [String] name of the ChefObject
      #
      # @return [ChefObject] the newly created ChefObject
      #
      def initialize(namespace, name)
        super(namespace, name)
      end

      # Register a chef element class.
      #
      # @param element [Class] chef element class
      #
      def self.register_element(element)
        @@chef_elements ||= {}
        @@chef_elements[element] = self
      end

      # Factory for creating and registering chef element object in
      # YARD::Registry.
      #
      # @param namespace [NamespaceObject] namespace to which the object must
      # belong
      # @param name [String] name of the chef element
      # @param type [Symbol, String] type of the chef element
      #
      # @return [<type>Object] the element object
      #
      # TODO: Remove namespace!
      def self.register(_namespace, name, type)
        element = @@chef_elements[type]
        raise "Invalid chef element type #{type}" unless element
        element_obj = YARD::Registry.resolve(:root, "#{type}::#{name}")
        if element_obj.nil?
          element_obj = element.new(:root, "#{type}::#{name}")
          log.info "Created [#{type.to_s.capitalize}] #{element_obj.name} => #{element_obj.namespace}"
        end
        element_obj
      end

      # Returns children of an object of a particular type.
      #
      # @param type [Symbol] type of ChefObject to be selected
      #
      # @return [Array<ChefObject>] list of ChefObjects
      #
      def children_by_type(type)
        children = YARD::Registry.all(type)
        children.select { |child| child.parent == self }
      end
    end
  end
end
