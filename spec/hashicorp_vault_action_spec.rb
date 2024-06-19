describe Fastlane::Actions::HashicorpVaultAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The hashicorp_vault plugin is working!")

      Fastlane::Actions::HashicorpVaultAction.run(nil)
    end
  end
end
