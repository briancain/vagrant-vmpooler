require "log4r"

module VagrantPlugins
  module Vmpooler
    module Action
      class TerminateInstance
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::terminate_instance")
        end

        def call(env)
        end
      end
    end
  end
end
