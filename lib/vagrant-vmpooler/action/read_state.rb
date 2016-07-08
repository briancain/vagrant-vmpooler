require "log4r"

module VagrantPlugins
  module AWS
    module Action
      class ReadState
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::read_state")
        end

        def call(env)
          env[:machine_state_id] = read_state(env[:machine])

          @app.call(env)
        end

        def read_state(machine)
          return :not_created if machine.id.nil?

          # query vmpooler for status
        end
      end
    end
  end
end
