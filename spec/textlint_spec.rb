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

        allow(Dir).to receive(:pwd).and_return("/Users/your/github/sample_repository")
      end

      describe ".parse" do
        subject(:expect_message) do
          "文末が\"。\"で終わっていません。(preset-ja-technical-writing/ja-no-mixed-period)"
        end

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
            file_path: "articles/1.md",
            line: 3,
            severity: "fail",
            message: expect_message
          }
          expect(errors[0]).to eq(expected)
        end
      end

      describe ".lint" do
        subject(:expect_message) do
          "文末が\"。\"で終わっていません。(preset-ja-technical-writing/ja-no-mixed-period)"
        end

        before do
          fixture_path = File.expand_path("../fixtures/textlint_result.json", __FILE__)
          fixture = File.read(fixture_path)
          allow(@textlint).to receive(:run_textlint).and_return fixture

          @textlint.lint
        end

        it "status_report" do
          status_report = @textlint.status_report
          expect(status_report[:errors].size).to be > 0
        end

        it "violation_report" do
          violation_report = @textlint.violation_report
          expect(violation_report[:errors][0]).to eq(
            Violation.new(expect_message, false, "articles/1.md", 3)
          )
        end
      end
    end
  end
end
