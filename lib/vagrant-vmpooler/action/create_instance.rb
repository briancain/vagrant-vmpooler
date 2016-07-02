require "log4r"
require "vmfloaty/pooler"

module VagrantPlugins
  module Vmpooler
    module Action
      class CreateInstance
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::create_instance")
        end

        def call(env)
          config = env[:machine].provider_config

          token = provider_config.token
          url = provider_config.url
          os = provider_config.os
          ttl = provider_config.ttl
          disk = provider_config.disk
          verbose = provider_config.verbose

          if !url
            raise Errors::NoURLError,
              :message => "There was no provided url to connect to vmpooler with"
          end

          if !token
            env[:ui].warn("There was no token provided. All vms will only last 2 hours.")
          end

          if !os
            raise Errors::NoURLError,
              :message => "There was no operatingystem provided"
          end

          env[:ui].info("Launching an instance with the following settings...")
          env[:ui].info("-- URL: #{url}")
          env[:ui].info("-- OS: #{os}")
          env[:ui].info("-- TTL: #{ttl}")
          env[:ui].info("-- Disk: #{disk}")

          response_body = Pooler.retrieve(verbose, os, token, url)
          if response_body["ok"]
            response_body.delete("ok")
            env[:machine].id = response_body.keys.first

            env[:ui].info("Your machine should be ready to go!")
          else
            raise Errors::FailedRequest,
              :message => "Could not properly get a vm:\n #{response_body}"
          end
        end
      end
    end
  end
end
