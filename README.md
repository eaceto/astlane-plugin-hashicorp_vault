# hashicorp_vault plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-hashicorp_vault)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-hashicorp_vault`, add it to your project by running:

```bash
fastlane add_plugin hashicorp_vault
```

## About hashicorp_vault

Manage provisioning profiles and certificates using Vault by HashiCorp

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Example

Download and install a certificate

```rb
download_certificate_from_vault(
  vault_address: 'https://your-vault-server.com',
  vault_token: 'your-vault-token',
  certificate_path: 'path/to/certificate/in/vault'
)
```

Download and install a provisioning profile

```rb
download_provisioning_profile_from_vault(
  vault_address: 'https://your-vault-server.com',
  vault_token: 'your-vault-token',
  provisioning_profile_path: 'path/to/profile/in/vault'
)
```

Generate (or renew) and upload provisioning profile

```rb
generate_and_upload_provisioning_profile_to_vault(
  type: 'appstore', # or 'adhoc', 'development', 'enterprise'
  app_identifier: 'com.example.app',
  username: 'email@example.com',
  team_id: 'TEAMID',
  profile_name: 'profile_name',
  vault_address: 'https://your-vault-server.com',
  vault_token: 'your-vault-token',
  vault_path: 'path/in/vault'
)
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use

```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
