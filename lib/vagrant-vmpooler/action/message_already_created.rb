module VagrantPlugins
  module Vmpooler
    module Action
      class MessageAlreadyCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info("vagrant_vmpooler.already_status", :status => "created")
          @app.call(env)
        end
      end
    end
  end
end
