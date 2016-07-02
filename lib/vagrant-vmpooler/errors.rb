require 'vagrant'

module VagrantPlugins
  module Vmpooler
    module Errors
      class VagrantVmpoolerError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_vmpooler.errors")
      end

      class NoURLError < Vagrant::Errors::VagrantErrors
        error_key(:vmpooler_url_error)
      end

      class NoOSError < Vagrant::Errors::VagrantErrors
        error_key(:no_os_error)
      end

      class FailedRequest < Vagrant::Errors::VagrantErrors
        error_key(:bad_request)
      end
    end
  end
end
