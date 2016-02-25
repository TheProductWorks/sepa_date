# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sepa_date/version"

Gem::Specification.new do |s|
  s.name        = 'sepa_date'
  s.version     = SepaDate::VERSION
  s.date        = '2016-02-05'
  s.summary     = "SEPA Date"
  s.description = "Date helper to determine SEPA payment dates."
  s.authors     = ["Máté Marjai"]
  s.email       = 'mate.marjai@gmail.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]
  s.homepage    =
    'http://rubygems.org/gems/sepa_date'
  s.license       = 'MIT'
  s.executables   = ["sepa_date_configure"]

  s.add_runtime_dependency "holiday", "~> 0.0", ">= 0.0.1"
  s.add_runtime_dependency "business_time", "~> 0.7", ">= 0.7.4"
  s.add_development_dependency "rake", "~> 10.5", ">= 10.5.0"
  s.add_development_dependency "minitest", "~> 5.8", ">= 5.8.4"
end
