include Helpers::ChefHelper

def init
  sections.push :attribute
end

# Something is wrong here. Objects should be accessible via options.objects
# or @objects, but those are empty. Use this as a quick workaround until a
# a nice fix is found.
def objects
  Registry.all
end
