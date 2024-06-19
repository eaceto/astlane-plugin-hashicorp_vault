require 'fastlane/action'
require 'vault'
require 'fileutils'

module Fastlane
  module Actions
    class DownloadProvisioningProfileFromVaultAction < Action
      def self.run(params)
        vault_address = params[:vault_address]
        vault_token = params[:vault_token]
        provisioning_profile_path = params[:provisioning_profile_path]

        Vault.address = vault_address
        Vault.token = vault_token

        # Download provisioning profile
        profile_secret = Vault.logical.read(provisioning_profile_path)
        profile_data = profile_secret.data[:profile]
        profile_file = File.join(Dir.pwd, "profile.mobileprovision")

        File.open(profile_file, "wb") do |file|
          file.write(profile_data)
        end

        # Install provisioning profile
        install_provisioning_profile(profile_file)
      end

      def self.install_provisioning_profile(profile_file)
        # Copy provisioning profile to the correct directory
        profiles_path = File.expand_path("~/Library/MobileDevice/Provisioning Profiles")
        FileUtils.mkdir_p(profiles_path)
        FileUtils.cp(profile_file, profiles_path)
      end

      def self.description
        "Download and install a provisioning profile from HashiCorp Vault"
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
          FastlaneCore::ConfigItem.new(key: :provisioning_profile_path,
                                       description: "The path in Vault to the provisioning profile",
                                       verify_block: proc do |value|
                                         UI.user_error!("No provisioning profile path given, pass using `provisioning_profile_path: 'path'`") unless value && !value.empty?
                                       end)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
