module VagrantPlugins
  module Vmpooler
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info("This machine has already been created")
          @app.call(env)
        end
      end
    end
  end
end
