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
  s.files       = ["lib/sepa_date.rb"]
  s.homepage    =
    'http://rubygems.org/gems/sepa_date'
  s.license       = 'MIT'

  s.add_runtime_dependency "holiday"
  s.add_runtime_dependency "business_time"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
end
