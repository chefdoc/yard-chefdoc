# frozen_string_literal: true

module YARD::Templates::Helpers
  # The chef helper module
  module ChefHelper
    # Returns children of an object of a particular type sorted the chef
    # way. This means that the object with the name 'default' will be first
    # and any remaining objects will be sorted alphabetically.
    #
    # @param type [Symbol] type of CookbookObject to be selected
    #
    # @return [Array<CookbookObject>] list of CookbookObjects
    #
    def chefsorted_objects(type = nil)
      children = ::YARD::Registry.all.select { |o| o.type == type }.sort { |x, y| x.name.to_s <=> y.name.to_s }
      default_index = children.find_index { |r| r.name.to_s == 'default' }

      return children if default_index.nil?

      default_child = children.delete_at(default_index)
      [default_child].concat(children)
    end
  end
end
