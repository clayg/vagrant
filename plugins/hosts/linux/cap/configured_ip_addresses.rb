# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

require "pathname"
require "tempfile"

require "vagrant/util/downloader"
require "vagrant/util/file_checksum"
require "vagrant/util/powershell"
require "vagrant/util/subprocess"

module VagrantPlugins
  module HostLinux
    module Cap
      class ConfiguredIPAddresses

        @@logger = Log4r::Logger.new("vagrant::host::linux::configured_ip_address")

        def self.configured_ip_addresses(env)
          script_path = File.expand_path("../../scripts/host_info.ps1", __FILE__)
          script_path = Vagrant::Util::Platform.wsl_to_windows_path(script_path)
          r = Vagrant::Util::PowerShell.execute(script_path)
          @@logger.debug("ps output: #{r.stderr}")
          if r.exit_code != 0
            raise Vagrant::Errors::PowerShellError,
              script: script_path,
              stderr: r.stderr
          end

          res = JSON.parse(r.stdout)["ip_addresses"]
          Array(res)
        end
      end
    end
  end
end
