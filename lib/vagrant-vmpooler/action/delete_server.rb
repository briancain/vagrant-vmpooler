require 'vagrant/util/retryable'
require 'timeout'
require 'vmfloaty/pooler'

require "log4r"

module VagrantPlugins
  module Vmpooler
    module Action
      # This deletes the running server, if there is one.
      class DeleteServer
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::delete_server")
        end

        def call(env)
          machine = env[:machine]
          id = machine.id

          if id
            provider_config = machine.provider_config
            token = provider_config.token
            url = provider_config.url
            verbose = provider_config.verbose

            env[:ui].info(I18n.t("vagrant_vmpooler.deleting_server"))

            os = []
            os.push(id)
            response_body = Pooler.delete(verbose, url, os, token)

            puts response_body
            if !response_body['ok']
              # todo: write this
              env[:ui].info(I18n.t("vagrant_vmpooler.not_deleted"))
            end
          else
            env[:ui].info(I18n.t("vagrant_vmpooler.not_created"))
          end

          @app.call(env)
        end
      end
    end
  end
end
