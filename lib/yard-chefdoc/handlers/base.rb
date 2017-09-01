require 'yard'

module YARD::Handlers
  module Chef
    # Base handler for chef elements.
    class Base < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef

      # Gets the name of the handled object.
      #
      def name
        statement.parameters.first.jump(:string_content, :ident).source
      end

      # Gets the filename which is often used as the object name in chef
      #
      # @return [String] the file name without the rb extension
      #
      def filename
        File.basename(statement.file, '.rb')
      end

      # Registers the cookbook in {YARD::Registry} and returns the same.
      #
      # @return [ChefObject] the ChefObject
      #
      def cookbook
        cbs = YARD::Registry.all(:cookbook)
        raise 'Something went wrong! Found more that one cookbook.' if cbs.length > 1
        raise 'Something went wrong! Could not find any cookbook' if cbs.empty?

        cbs.first
      end
    end
  end
end
