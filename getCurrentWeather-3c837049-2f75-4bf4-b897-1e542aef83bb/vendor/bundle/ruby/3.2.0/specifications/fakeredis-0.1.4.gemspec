# -*- encoding: utf-8 -*-
# stub: fakeredis 0.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "fakeredis".freeze
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Guillermo Iguaran".freeze]
  s.date = "2011-06-20"
  s.description = "Fake implementation of redis-rb for machines without Redis or for testing purposes".freeze
  s.email = ["guilleiguaran@gmail.com".freeze]
  s.homepage = "https://github.com/guilleiguaran/fakeredis".freeze
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Fake redis-rb for your tests".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_development_dependency(%q<rspec>.freeze, [">= 2.0.0"])
end
