require 'vagrant'
require 'yaml'

module VagrantPlugins
  module Vmpooler
    class Config < Vagrant.plugin("2", :config)
      # The token used to obtain vms
      #
      # @return [String]
      attr_accessor :token

      # The url to your vmpooler installation
      #
      # @return [String]
      attr_accessor :url

      # Whether or not to run vmfloaty
      # commands in verbose mode
      #
      # @return [Boolean]
      attr_accessor :verbose

      # The type of operatingsystem to
      # get from the pooler
      #
      # @return [String]
      attr_accessor :os

      # How long the vm should stay
      # active for
      #
      # @return [Integer]
      attr_accessor :ttl

      # Increases default disk space by
      # this size
      #
      # @return [Integer]
      attr_accessor :disk

      #attr_accessor :user

      # ----------------
      # Internal methods
      # ----------------

      def finalize!
        conf_file = {}
        begin
          conf_file = YAML.load_file("#{Dir.home}/.vmfloaty.yml")
        rescue
          # vagrant debug?
        end

        @token = conf_file['token'] if conf_file['token']
        @url = conf_file['url'] if conf_file['url']
      end

      # ----------------
      # Provider methods
      # ----------------

      def initialize(verbose=false)
        @token = UNSET_VALUE
        @url = UNSET_VALUE
        @verbose = UNSET_VALUE
        @os = UNSET_VALUE
        @ttl = UNSET_VALUE
        @disk = UNSET_VALUE
      end
    end
  end
end
