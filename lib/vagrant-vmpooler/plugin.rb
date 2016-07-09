begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant vmpooler plugin must be run within Vagrant."
end

module VagrantPlugins
  module Vmpooler
    class Plugin < Vagrant.plugin("2")
      name "Vmpooler"
      description <<-DESC
      This plugin installs a provider that allows Vagrant to manage
      machines in vmpooler.
      DESC

      config(:vmpooler, :provider) do
        require_relative "config"
        Config
      end

      provider(:vmpooler, parallel:true) do
        Vmpooler.init_i18n
        Vmpooler.init_logging

        require_relative 'provider'
        Provider
      end
    end
  end
end
