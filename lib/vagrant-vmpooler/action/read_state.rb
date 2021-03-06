require "log4r"
require 'vmfloaty/pooler'

module VagrantPlugins
  module Vmpooler
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class ReadState
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::read_state")
        end

        def call(env)
          env[:machine_state_id] = read_state(env)
          @app.call(env)
        end

        def read_state(env)
          machine = env[:machine]
          id = machine.id
          return :not_created if id.nil?

          provider_config = machine.provider_config
          verbose = provider_config.verbose
          url = provider_config.url

          server = Pooler.query(verbose, url, id)
          if server['ok'] == false
            env[:ui].warn(I18n.t("vagrant_vmpooler.not_created"))
            machine.id = nil
            return :not_created
          elsif server[id]["state"] == "destroyed"
            env[:ui].warn(I18n.t("vagrant_vmpooler.deleted"))
            machine.id = nil
            return :not_created
          end

          return :created
        end

      end
    end
  end
end
