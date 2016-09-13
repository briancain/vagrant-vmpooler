
module VagrantPlugins
  module Vmpooler
    module Action
      class DisableTty
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::disable_tty")
        end

        def call(env)
          ssh_info = env[:machine].ssh_info
          os_flavor = env[:machine].provider_config.os
          disable_tty_command = "sed -i 's/^Defaults\s*requiretty/#Defaults requiretty/' /etc/sudoers"
          # i18n
          env[:ui].info(I18n.t("vagrant_vmpooler.disable_tty"))

          env[:machine].communicate.execute(disable_tty_command, :error_check => true)

          @app.call(env)
        end
      end
    end
  end
end
