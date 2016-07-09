module VagrantPlugins
  module Vmpooler
    module Action
      class IsPaused
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = env[:machine].state.id == :paused
          @app.call(env)
        end
      end
    end
  end
end
