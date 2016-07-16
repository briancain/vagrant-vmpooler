require 'vagrant'

module VagrantPlugins
  module Vmpooler
    module Errors
      class VagrantVmpoolerErrors < Vagrant::Errors::VagrantError
        error_namespace("vagrant_vmpooler.errors")
      end

      class NoURLError < VagrantVmpoolerErrors
        error_key(:vmpooler_url_error)
      end

      class NoOSError < VagrantVmpoolerErrors
        error_key(:no_os_error)
      end

      class FailedRequest < VagrantVmpoolerErrors
        error_key(:bad_request)
      end

      class RsyncError < VagrantVmpoolerErrors
        error_key(:rsync_error)
      end

      class RsyncError < VagrantVmpoolerErrors
        error_key(:install_rsync_error)
      end
    end
  end
end
