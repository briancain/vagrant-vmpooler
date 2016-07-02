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

      # This action is called when `vagrant destroy` is called.
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, DestroyConfirm do |env, b2|
            if env[:result]
              b2.use Call, IsCreated do |env2, b3|
                if !env2[:result]
                  b3.use MessageNotCreated
                  next
                end

                b3.use TerminateInstance
                b3.use ProvisionerCleanup if defined?(ProvisionerCleanup)
              end
            else
              # wont destroy
            end
          end
        end
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use Provision
          end
        end
      end

      # This action is called to SSH into the machine.
      def self.action_ssh
      end

      def self.action_prepare_boot
        Vagrant::Action::Builder.new.tap do |b|
          b.use Provision
          b.use SyncedFolders
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
      autoload :MessageAlreadyCreated, action_root.join("message_already_created")
    end
  end
end
