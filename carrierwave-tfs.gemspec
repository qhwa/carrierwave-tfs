# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "carrierwave-tfs"
  s.version     = "0.2.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Lee","Nowa Zhu"]
  s.email       = ["huacnlee@gmail.com","nowazhu@gmail.com"]
  s.homepage    = "https://github.com/huacnlee/carrierwave-tfs"
  s.summary     = %q{Taobao TFS support for CarrierWave}
  s.description = %q{Taobao TFS support for CarrierWave}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "carrierwave", [">= 0.5.6"]
  s.add_dependency "rtfs", ['~> 0.1.0']
  s.add_development_dependency "rspec", ["~> 2.6"]
  s.add_development_dependency "rake", ["~> 0.9"]
end

