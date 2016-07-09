require "log4r"

module VagrantPlugins
  module Vmpooler
    module Action
      # This hard reboots a running server, if there is one.
      class HardRebootServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::hard_reboot_server")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_vmpooler.hard_rebooting_server"))

          end

          @app.call(env)
        end
      end
    end
  end
end
