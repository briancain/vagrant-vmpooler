module VagrantPlugins
  module Vmpooler
    module Action
      class IsSuspended
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = env[:machine].state.id == :suspended
          @app.call(env)
        end
      end
    end
  end
end
