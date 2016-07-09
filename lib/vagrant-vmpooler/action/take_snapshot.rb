require "log4r"

module VagrantPlugins
  module Vmpooler
    module Action
      # This reboots a running server, if there is one.
      class TakeSnapshot
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::take_snapshot")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_vmpooler.snapshoting_server"))
            # make api call to snapshot server

          end

          @app.call(env)
        end
      end
    end
  end
end
