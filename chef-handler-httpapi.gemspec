Gem::Specification.new do |s|
  s.name        = "chef-handler-httpapi"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eike Waldt"]
  s.email       = ["waldt@b1-systems.de"]
  s.homepage    = "https://github.com/b1-systems/chef-handler-httpapi"
  s.summary     = %q{An exception handler for OpsCode Chef doing http post via net/http)}
  s.description = %q{An exception handler for OpsCode Chef doing http post via net/http)}
  s.has_rdoc    = false
  s.license     = "GPLv3"

  s.add_dependency("chef")

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib/chef/handler"]
end
