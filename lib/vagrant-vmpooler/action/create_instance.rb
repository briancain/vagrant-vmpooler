require "log4r"

module VagrantPlugins
  module Vmpooler
    module Action
      class CreateInstance
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::create_instance")
        end

        def call(env)
        end
      end
    end
  end
end
