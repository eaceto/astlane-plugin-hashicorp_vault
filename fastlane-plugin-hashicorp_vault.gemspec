lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/hashicorp_vault/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-hashicorp_vault'
  spec.version       = Fastlane::HashicorpVault::VERSION
  spec.author        = 'Ezequiel (Kimi) Aceto'
  spec.email         = 'ezequiel.aceto@gmail.com'

  spec.summary       = 'Manage provisioning profiles and certificates using Vault by HashiCorp'
  spec.homepage      = "https://github.com/eaceto/fastlane-plugin-hashicorp_vault"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'

  s.add_runtime_dependency 'fastlane', '>= 2.0.0'
  s.add_runtime_dependency 'sigh', '~> 2.0'
  s.add_runtime_dependency 'vault', '~> 0.18.1'
end
