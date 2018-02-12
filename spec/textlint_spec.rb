# frozen_string_literal: true

require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerTextlint do
    it "should be a plugin" do
      expect(Danger::DangerTextlint.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @textlint = @dangerfile.textlint
      end

      describe ".parse" do
        subject(:errors) do
          fixture_path = File.expand_path("../fixtures/textlint_result.json", __FILE__)
          fixture = File.read(fixture_path)

          @textlint.parse(fixture)
        end

        it "has 6 errors" do
          expect(errors.size).to eq(6)
        end

        it "is mapped to be follow hash about index 0" do
          expected = {
            file_path: "/Users/your/github/sample_repository/articles/1.md",
            line: 3,
            severity: 2,
            message: "文末が\"。\"で終わっていません。(preset-ja-technical-writing/ja-no-mixed-period)"
          }
          expect(errors[0]).to eq(expected)
        end
      end
    end
  end
end
