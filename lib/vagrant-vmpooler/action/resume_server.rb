require "log4r"

module VagrantPlugins
  module Vmpooler
    module Action
      # This starts a suspended server, if there is one.
      class ResumeServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::resume_server")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_vmpooler.resuming_server"))

            # raise "not implemented"
          end

          @app.call(env)
        end
      end
    end
  end
end
