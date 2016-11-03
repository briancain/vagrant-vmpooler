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

      # The password to use to log
      # into the vmpooler machine
      #
      # @return [String]
      attr_accessor :password

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

      def read_config
        conf_file = {}
        begin
          conf_file = YAML.load_file("#{Dir.home}/.vmfloaty.yml")
        rescue
          # vagrant debug?
        end
        conf_file
      end

      def finalize!
        conf_file = read_config

        # if conf_file is false the file
        # exists but there are no keys inside it
        if conf_file != false
          if conf_file['token']
            @token = conf_file['token']
          else
            @token = nil
          end

          if conf_file['url']
            @url = conf_file['url']
          else
            @url = nil
          end
        end

        @url = nil if @url == UNSET_VALUE
        @verbose = false if @verbose == UNSET_VALUE
        @os = nil if @os == UNSET_VALUE
        @ttl = nil if @ttl == UNSET_VALUE
        @disk = nil if @disk == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE
        @token = nil if @token == UNSET_VALUE
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
        @password = UNSET_VALUE
      end
    end
  end
end
