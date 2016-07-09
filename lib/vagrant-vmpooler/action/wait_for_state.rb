require 'log4r'
require 'timeout'

module VagrantPlugins
  module Vmpooler
    module Action
      # This action will wait for a machine to reach a specific state or quit by timeout.
      class WaitForState
        def initialize(app, env, state, timeout)
          @app = app
          @logger = Log4r::Logger.new('vagrant_vmpooler::action::wait_for_state')
          @state = Array.new(state).flatten
          @timeout = timeout
        end

        def call(env)
          env[:result] = true
          state = env[:machine].state.id.to_sym

          if @state.include?(state)
            @logger.info("Machine already at status #{ state.to_s }")
          else
            @logger.info("Waiting for machine to reach state...")
            begin
              Timeout.timeout(@timeout) do
                sleep 2 until @state.include?(env[:machine].state.id)
              end
            rescue Timeout::Error
              env[:result] = false
            end

            @app.call(env)
          end
        end
      end
    end
  end
end
