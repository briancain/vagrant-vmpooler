require "log4r"
require "ipaddr"

module VagrantPlugins
  module Vmpooler
    module Action
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReadSSHInfo
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::read_ssh_info")
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:machine])

          @app.call(env)
        end

        def read_ssh_info(machine)
          id = machine.id
          return nil if id.nil?

          provider_config = machine.provider_config
          verbose = provider_config.verbose
          url = provider_config.url
          password = provider_config.password
          os = provider_config.os

          server = Pooler.query(verbose, url, id)
          if server['ok'] == false
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          else
            if os =~ /win/i
              username = 'Administrator'
            else
              username = 'root'
            end

            host = server[id]['domain'].nil? ? id : "#{id}.#{server[id]['domain']}"
            ssh_info = {
              :host => host,
              :username => username,
              :password => password
            }
            ssh_info.merge! server[id]
            return ssh_info
          end
        end
      end
    end
  end
end
