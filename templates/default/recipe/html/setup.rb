def init
  sections.push :recipe, [:source]
end

def source
  return if object.source.nil?
  erb(:source)
end
