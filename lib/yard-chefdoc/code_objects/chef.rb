require 'yard'

module YARD::CodeObjects
  module Chef
    # The chef object will be the root of your namespace
    class ChefObject < YARD::CodeObjects::NamespaceObject
      attr_accessor :file # The file the object appears in
      attr_accessor :header # The header found in the source file

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
        @@chef_elements ||= {} # rubocop:disable Style/ClassVars
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
      def self.register(name, type, file)
        element = @@chef_elements[type]
        raise "Invalid chef element type #{type}" unless element
        element_obj = YARD::Registry.resolve(:root, "#{type}::#{name}")
        if element_obj.nil?
          element_obj = element.new(:root, "#{type}::#{name}")
          log.info "Created [#{type.to_s.capitalize}] #{element_obj.name} => #{element_obj.namespace}"
          element_obj.chef_init(file)
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

      # Does chef specific initalization tasks
      #
      # @param file [String] The file of the object thas is being initialized
      #
      # @return [ChefObject] The (chef) initialized object
      #
      def chef_init(file)
        self.file = file
        self.source = IO.read(File.expand_path(file))
        self.header = find_header_in(source)
        self.docstring = find_description_in(header)
      end

      # Gets the file header if available
      # The header is defined by a every comment line starting at the beginning of the file
      # Until the first blank line. If no blank line is found then the comment is considered
      # the following resource's/blocks docstring.
      #
      # @return [String] The header of the file. Empty if no header is found
      #
      def find_header_in(src)
        h = []
        src.each_line do |line|
          comment = line[/^\s*#\s?(.*)$/, 1]
          break if comment.nil?

          h.push comment
        end

        h.join("\n")
      end

      # Gets the description from the file header.
      # Currently the docstring of recipes, attributes etc. is looked up in the file
      # header and starts with a single line containing the keyword "Description".
      #
      # @return [String] The description
      #
      def find_description_in(header)
        desc_found = false
        docstring = []
        header.each_line do |line|
          if desc_found
            docstring.push line
          elsif line.chomp == 'Description'
            desc_found = true
          end
        end

        docstring.join("\n")
      end
    end
  end
end
