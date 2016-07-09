require "log4r"

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
          env[:machine_state_id] = read_state(env[:machine])
          @app.call(env)
        end

        def read_state(machine)
          id = machine.id
          return :not_created if id.nil?

          provider_config = machine.provider_config
          verbse = provider_config.verbose
          url = provider_config.url

          server = Pooler.query(verbose, url, id)
          if server['ok'] == false
            @logger.info(I18n.t("vagrant_vmpooler.not_created"))
            machine.id = nil
            return :not_created
          end

          return :created
        end

      end
    end
  end
end
