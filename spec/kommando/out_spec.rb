require 'spec_helper'
require 'tempfile'

describe Kommando do
  describe 'out' do
    it 'is empty if not run' do
      expect(Kommando.new("").out).to eq ""
    end

    it 'has the stdout' do
      uptime = Kommando.new "uptime"
      uptime.run
      uptime

      expect(uptime.out).to match /\d+ users, load averages:/
    end

    describe 'on' do
      it "matches" do
        k = Kommando.new "$ printf 'name: '; read N; printf \"$N OK\""

        matched_string = false
        k.out.on "hello OK" do
          matched_string = true
        end

        matched_regexp = false
        k.out.on /hello OK/ do
          matched_regexp = true
        end

        never_matched = true
        k.out.on /not there in out/ do
          never_matched = false
        end

        k.in << "hello\n"
        k.run

        expect(matched_string).to be true
        expect(matched_regexp).to be true
        expect(never_matched).to be true
      end
    end
  end
end
