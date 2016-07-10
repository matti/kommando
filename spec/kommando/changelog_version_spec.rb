require 'spec_helper'

describe "CHANGELOG" do
  describe 'version' do
    it 'matches Kommando::VERSION' do
      changelog_contents = File.read "CHANGELOG.md"
      changelog_topmost_version = changelog_contents.match(/## (\d+\.\d+\.\d+)/)[1]

      expect(changelog_topmost_version).to eq Kommando::VERSION
    end
  end
end
