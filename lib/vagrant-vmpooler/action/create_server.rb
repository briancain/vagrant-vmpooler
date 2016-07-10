require "vmfloaty/pooler"
require "log4r"

require 'vagrant/util/retryable'

module VagrantPlugins
  module Vmpooler
    module Action
      class CreateServer
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::create_server")
        end

        def call(env)
          # Get the configs
          provider_config = env[:machine].provider_config

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

          # Output the settings we're going to use to the user
          env[:ui].info(I18n.t("vagrant_vmpooler.launching_server"))
          env[:ui].info(" -- Vmpooler URL: #{url}")
          env[:ui].info(" -- Vmpooler Verbose Mode: #{verbose}")
          env[:ui].info(" -- Image: #{os}")
          env[:ui].info(" -- Additional TTL: #{ttl}") if ttl
          env[:ui].info(" -- Additional Disk: #{disk}") if disk

          # Create the server
          os_arr = {}
          os_arr[os] = 1
          server = Pooler.retrieve(verbose, os_arr, token, url)

          # Store the ID right away so we can track it
          # in this case it's the hostname
          if server['ok'] == false
            raise Errors::GetVMError,
              :message => "Could not retrieve vm from pooler:\n #{server}"
          end

          server_name = server[os]["hostname"]
          env[:machine].id = server_name

          # extend ttl and disk space here
          if ! ttl.nil?
            response_body = Pooler.modify(verbose, url, server_name, token, ttl, nil)
            if response_body['ok'] == false
              env[:ui].warn(I18n.t("vagrant_vmpooler.errors.failed_ttl"))
            end
          end

          if ! disk.nil?
            response_body = Pooler.disk(verbose, url, server_name, token, disk)
            if response_body['ok'] == false
              env[:ui].warn(I18n.t("vagrant_vmpooler.errors.failed_disk_extend"))
            end
          end

          if !env[:interrupted]
            # Clear the line one more time so the progress is removed
            env[:ui].clear_line

            # Wait for SSH to become available
            env[:ui].info(I18n.t("vagrant_vmpooler.waiting_for_ssh"))
            while true
              begin
                # If we're interrupted then just back out
                break if env[:interrupted]
                break if env[:machine].communicate.ready?
              rescue Errno::ENETUNREACH, Errno::EHOSTUNREACH
              end
              sleep 2
            end

            env[:ui].info(I18n.t("vagrant_vmpooler.ready"))
          end

          @app.call(env)
        end
      end
    end
  end
end
