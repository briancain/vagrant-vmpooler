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

            if response_body[id]['ok'] == false
              # the only way this can happen is if the vm existed at one point
              # but got deleted from vmpoolers redis db. We should probably
              # still delete it from vagrants internal state if this is true
              env[:ui].info(I18n.t("vagrant_vmpooler.not_deleted"))
            else
              env[:ui].info(I18n.t("vagrant_vmpooler.deleted"))
              env[:machine].id = nil
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
