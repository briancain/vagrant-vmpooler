$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-vmpooler/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-vmpooler"
  s.version       = VagrantPlugins::Vmpooler::VERSION
  s.platform      = Gem::Platform::RUBY
  s.license       = "Apache"
  s.authors       = "Brian Cain"
  s.email         = "brian.cain@puppet.com"
  s.homepage      = "https://github.com/briancain/vagrant-vmpooler"
  s.summary       = "Enables Vagrant to manage machines in vmpooler."
  s.description   = "Enables Vagrant to manage machines in vmpooler."

  s.add_runtime_dependency "vmfloaty", ">= 0.5.0"

  s.add_development_dependency "rspec-its"
end
