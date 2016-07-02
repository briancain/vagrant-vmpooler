require 'pathname'
require 'vagrant/action/builder'

module VagrantPlugins
  module Vmpooler
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin

      # This action is what halts the remote machine
      def self.action_halt
        raise "This action is not supported with vmpooler"
      end

      def self.action_destroy
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
      end

      # This action is called to SSH into the machine.
      def self.action_ssh
      end

      def self.action_prepare_boot
        Vagrant::Action::Builder.new.tap do |b|
          b.use Provision
          b.use SyncedFolders
          b.use WarnNetworks
        end
      end

      # This action is called when `vagrant up` is called.
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use HandleBox
          b.use ConfigValidate
          #b.use BoxCheckOutdated
          b.use Call, IsCreated do |env1, b2|
            if env1[:result]
              # box already exists
              b1.use Call, IsStopped do |env2, b2|
                if env2[:result]
                  b2.use action_prepare_boot
                  b2.use StartInstance # restart this instance
                else
                  b2.use MessageAlreadyCreated
                end
              end
            else
              # obtain new vm
              b1.use action_prepare_boot
              b1.use CreateInstance
            end
          end
        end
      end

      # This action is called when `vagrant reload` is called.
      def self.action_reload
      end

      # autoload the various actions
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :IsCreated, action_root.join("is_created")
      autoload :CreateInstance, action_root.join("create_instance")
      autoload :TerminateInstance, action_root.join("terminate_instance")
    end
  end
end
