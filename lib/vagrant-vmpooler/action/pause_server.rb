require "log4r"

module VagrantPlugins
  module Vmpooler
    module Action
      # This pauses a running server, if there is one.
      class PauseServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::pause_server")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_vmpooler.pausing_server"))

          end

          @app.call(env)
        end
      end
    end
  end
end
