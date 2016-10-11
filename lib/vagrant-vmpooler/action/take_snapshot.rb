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
            provider_config = env[:machine].provider_config

            token = provider_config.token
            url = provider_config.url
            verbose = provider_config.verbose
            hostname = env[:machine].id
            begin
              response = Pooler.snapshot(verbose, url, hostname, token)
              if response['ok'] == false
                env[:ui].info(I81n.t("vagrant_vmpooler.errors.failed_snapshot"))
                env[:ui].info(response)
              end
            rescue TokenError => e
              env[:ui].warn(I18n.t("vagrant_vmpooler.errors.no_token_error"))
              env[:ui].info(I81n.t("vagrant_vmpooler.errors.failed_snapshot"))
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
