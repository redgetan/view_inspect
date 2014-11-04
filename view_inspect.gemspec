require File.expand_path('../lib/view_inspect/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "view_inspect"
  s.version = ViewInspect::VERSION

  s.required_rubygems_version = ">= 1.9.3"

  s.authors = ["Reginald Tan"]
  s.email = "redge.tan@gmail.com"
  s.summary = "Shows you the source location of a server-side or client-side rendered DOM element"
  s.description = "Shows you the source location of a server-side or client-side rendered DOM element. Works with Rails 3 and 4"
  s.files = `git ls-files`.split($/)
  s.homepage = "http://github.com/redgetan/view_inspect"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"

  s.add_dependency "nokogiri"
end

