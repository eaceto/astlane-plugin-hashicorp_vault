require 'fastlane/action'
require 'vault'

module Fastlane
  module Actions
    class DownloadCertificateFromVaultAction < Action
      def self.run(params)
        vault_address = params[:vault_address]
        vault_token = params[:vault_token]
        certificate_path = params[:certificate_path]

        Vault.address = vault_address
        Vault.token = vault_token

        # Download certificate
        cert_secret = Vault.logical.read(certificate_path)
        cert_data = cert_secret.data[:certificate]
        cert_file = File.join(Dir.pwd, "certificate.p12")

        File.open(cert_file, "wb") do |file|
          file.write(cert_data)
        end

        # Install certificate
        install_certificate(cert_file)
      end

      def self.install_certificate(cert_file)
        # Security command to import the certificate
        sh("security import #{cert_file} -k #{ENV['HOME']}/Library/Keychains/login.keychain -T /usr/bin/codesign")
      end

      def self.description
        "Download and install a certificate from HashiCorp Vault"
      end

      def self.authors
        ["Ezequiel (Kimi) Aceto"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :vault_address,
                                       description: "The address of the HashiCorp Vault server",
                                       verify_block: proc do |value|
                                         UI.user_error!("No Vault address given, pass using `vault_address: 'address'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :vault_token,
                                       description: "The token to authenticate with HashiCorp Vault",
                                       verify_block: proc do |value|
                                         UI.user_error!("No Vault token given, pass using `vault_token: 'token'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :certificate_path,
                                       description: "The path in Vault to the certificate",
                                       verify_block: proc do |value|
                                         UI.user_error!("No certificate path given, pass using `certificate_path: 'path'`") unless value && !value.empty?
                                       end)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
