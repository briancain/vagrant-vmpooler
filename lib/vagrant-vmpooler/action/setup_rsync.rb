
module VagrantPlugins
  module Vmpooler
    module Action
      class SetupRsync
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::setup_rsync")
        end

        def determine_packman(os_flavor)
          if os_flavor =~ /centos|fedora|redhat/i
            cmd_install_rsync = "yum install rsync.x86_64 -y"
          elsif os_flavor =~ /debian|ubuntu/i
            cmd_install_rsync = "apt-get install rsync -y"
          else
            raise Errors::CannotSetupRsync,
              :message => "Could not install rsync on os provided"
          end

          cmd_install_rsync
        end

        def call(env)
          ssh_info = env[:machine].ssh_info
          os_flavor = env[:machine].provider_config.os
          cmd_install_rsync = determine_packman(os_flavor)

          env[:ui].info(I18n.t("vagrant_vmpooler.install_rsync"))
          env[:machine].communicate.execute(cmd_install_rsync, :error_check => true)
          @app.call(env)
        end
      end
    end
  end
end
