module VagrantPlugins
  module Vmpooler
    module Action
      class MessageServerRunning
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_vmpooler.server_running", name: env[:machine].id))
          @app.call(env)
        end
      end
    end
  end
end
