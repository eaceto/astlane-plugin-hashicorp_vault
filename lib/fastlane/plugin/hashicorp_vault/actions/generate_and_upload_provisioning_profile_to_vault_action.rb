require 'fastlane/action'
require 'sigh'
require 'vault'
require 'fileutils'

module Fastlane
  module Actions
    class GenerateAndUploadProvisioningProfileToVaultAction < Action
      def self.run(params)
        app_identifier = params[:app_identifier]
        username = params[:username]
        team_id = params[:team_id]
        profile_name = params[:profile_name]
        profile_type = params[:type]

        # Generate or renew provisioning profile using sigh
        profile_path = Fastlane::Actions::SighAction.run(
          app_identifier: app_identifier,
          username: username,
          team_id: team_id,
          provisioning_name: profile_name,
          output_path: ".",
          force: true,
          adhoc: profile_type == 'adhoc',
          development: profile_type == 'development',
          enterprise: profile_type == 'enterprise',
          skip_install: true
        )

        UI.user_error!("Failed to create provisioning profile") unless profile_path

        # Read provisioning profile data
        provisioning_profile_data = File.read(profile_path)

        # Upload to Vault
        vault_address = params[:vault_address]
        vault_token = params[:vault_token]
        vault_path = params[:vault_path]

        Vault.address = vault_address
        Vault.token = vault_token

        Vault.logical.write(vault_path, profile: provisioning_profile_data)

        UI.success("Provisioning profile successfully generated and uploaded to Vault")
      end

      def self.description
        "Generate or renew provisioning profiles and upload them to HashiCorp Vault"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :type,
                                       description: "The type of provisioning profile to create (appstore, adhoc, development, enterprise)",
                                       verify_block: proc do |value|
                                         UI.user_error!("No type given, pass using `type: 'type'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                       description: "The bundle identifier of your app",
                                       verify_block: proc do |value|
                                         UI.user_error!("No app identifier given, pass using `app_identifier: 'com.example.app'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :username,
                                       description: "Your Apple ID username",
                                       verify_block: proc do |value|
                                         UI.user_error!("No Apple ID username given, pass using `username: 'email@example.com'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :team_id,
                                       description: "Your Apple Developer Team ID",
                                       verify_block: proc do |value|
                                         UI.user_error!("No team ID given, pass using `team_id: 'TEAMID'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :profile_name,
                                       description: "The name of the provisioning profile",
                                       verify_block: proc do |value|
                                         UI.user_error!("No provisioning profile name given, pass using `profile_name: 'profile_name'`") unless value && !value.empty?
                                       end),
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
          FastlaneCore::ConfigItem.new(key: :vault_path,
                                       description: "The path in Vault to store the provisioning profile",
                                       verify_block: proc do |value|
                                         UI.user_error!("No Vault path given, pass using `vault_path: 'path'`") unless value && !value.empty?
                                       end)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
