Gem::Specification.new do |s|
  s.name = "view_inspect"
  s.version = ViewInspect::VERSION

  s.required_rubygems_version = ">= 1.9.3"

  s.authors = ["Reginald Tan"]
  s.email = "redge.tan@gmail.com"
  s.summary = "Shows you the source location of a DOM element"
  s.description = "Shows you the source location of a DOM element. Works with Erb and Haml templates and Javascript generated DOM"
  s.files = `git ls-files`.split($/)
  s.homepage = "http://github.com/redgetan/view_inspect"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"

  s.add_dependency "nokogiri"
end

