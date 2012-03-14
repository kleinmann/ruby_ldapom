# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ruby_ldapom/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Uwe Kleinmann"]
  gem.email         = ["uwe@kleinmann.org"]
  gem.description   = %q{A simple ldap object mapper for ruby.}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/kleinmann/ruby_ldapom"

  gem.add_dependency("net-ldap", "~> 0.2.2")

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ruby_ldapom"
  gem.require_paths = ["lib"]
  gem.version       = RubyLdapom::VERSION
end
