require 'log4r'
require 'vagrant'

module VagrantPlugins
  module Vmpooler
    class Provider < Vagrant.plugin("2", :provider)
      def initialize(machine)
        @machine = machine
      end

      def action(name)
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end

      def ssh_info
        # Run a custom action called "read_ssh_info" which does what it
        # says and puts the resulting SSH info into the `:machine_ssh_info`
        # key in the environment.
        env = @machine.action("read_ssh_info")
        env[:machine_ssh_info]
      end

      def state
        env = @machine.action("read_state")
        state_id = env[:machine_state_id]

        # Maybe extract this out into locales like how other plugins handle this
        # to avoid a complicated case statement
        short = "vagrant_vmpooler.states.short_#{state_id}"
        long = "vagrant_vmpooler.states.long_#{state_id}"

        Vagrant::MachineState.new(state_id, short, long)
      end

      def to_s
        id = "new"
        if !@machine.id.nil?
          id = @machine.id
        end

        "Vmpooler (#{id})"
      end
    end
  end
end
