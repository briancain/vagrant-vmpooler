require "log4r"

require "vagrant/util/subprocess"
require "vagrant/util/which"

module VagrantPlugins
  module Vmpooler
    module Action
      # This middleware uses `rsync` to sync the folders over to the
      # remote instance.
      class SyncFolders
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_vmpooler::action::sync_folders")
        end

        def call(env)
          @app.call(env)

          ssh_info = env[:machine].ssh_info

          env[:machine].config.vm.synced_folders.each do |id, data|
            # ignore disabled shared folders
            if data[:disabled]
              @logger.info "Not syncing disabled folder: #{data[:hostpath]} => #{data[:guestpath]}"
              next
            end

            unless Vagrant::Util::Which.which('rsync')
              @logger.info "please install rsync first"
              break
            end

            hostpath  = File.expand_path(data[:hostpath], env[:root_path])
            # rsync interprets paths with colons as remote locations.
            # "cygdrive" path for cygwin on windows.
            if Vagrant::Util::Platform.windows?
              hostpath = Vagrant::Util::Subprocess.execute("cygpath", "-u", "-a", hostpath).stdout.chomp
            end
            guestpath = data[:guestpath]

            # Make sure there is a trailing slash on the host path to
            # avoid creating an additional directory with rsync
            hostpath = "#{hostpath}/" if hostpath !~ /\/$/

            env[:ui].info(I18n.t("vagrant_vmpooler.rsync_folder",
                                :hostpath => hostpath,
                                :guestpath => guestpath))

            # Create the guest path
            # Use sudo only when it is necessary
            cmd_mkdir = "mkdir -p '#{guestpath}'"
            cmd_chown = "chown #{ssh_info[:username]} '#{guestpath}'"
            if env[:machine].communicate.execute(cmd_mkdir, :error_check => false) != 0 then
              env[:machine].communicate.sudo(cmd_mkdir)
            end
            if env[:machine].communicate.execute(cmd_chown, :error_check => false) != 0 then
              env[:machine].communicate.sudo(cmd_chown)
            end

            #collect rsync excludes specified :rsync_excludes=>['path1',...] in synced_folder options
            excludes = ['.vagrant/', 'Vagrantfile', *Array(data[:rsync_excludes])].uniq

            # Rsync over to the guest path using the SSH info
            if env[:machine].config.ssh.proxy_command
              proxy_cmd = "-o ProxyCommand='#{env[:machine].config.ssh.proxy_command}'"
            else
              proxy_cmd = ''
            end

            # poor workaround for poor ipv6 handling of rsync
            if ssh_info[:host].include? ':'
              user_at_host = "[#{ssh_info[:username]}@#{ssh_info[:host]}]"
            else
              user_at_host = ssh_info[:username] + "@" + ssh_info[:host]
            end

            command = [
              'rsync', '--verbose', '--archive', '-z', '--delete',
              *excludes.map{|e|['--exclude', e]}.flatten,
              '-e', "ssh -p #{ssh_info[:port]} -o StrictHostKeyChecking=no #{proxy_cmd} #{ssh_key_options(ssh_info)}",
              hostpath,
              user_at_host + ":" + guestpath]

            r = Vagrant::Util::Subprocess.execute(*command)
            if r.exit_code != 0
              raise Errors::RsyncError,
                :guestpath => guestpath,
                :hostpath => hostpath,
                :stderr => r.stderr
            end
          end
        end

        private

        def ssh_key_options(ssh_info)
          # Ensure that `private_key_path` is an Array (for Vagrant < 1.4)
          Array(ssh_info[:private_key_path]).map { |path| "-i '#{path}' " }.join
        end
      end
    end
  end
end
