require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe "with Dangerfile" do
    before do
      @dangerfile = testing_dangerfile
      @textlint = @dangerfile.textlint

      # stub
      allow(Dir).to receive(:pwd).and_return("/Users/your/github/sample_repository")
      allow(@textlint).to receive(:textlint_path).and_return("./node_modules/.bin/textlint")
      allow(@textlint.git).to receive(:added_files).and_return([])
      allow(@textlint.git).to receive(:modified_files).and_return([])
      allow(@textlint.git).to receive(:deleted_files).and_return([])
    end

    let(:fixture) do
      fixture_path = File.expand_path("../fixtures/textlint_result.json", __FILE__)
      File.read(fixture_path)
    end

    describe ".parse" do
      let(:expect_message) do
        "文末が\"。\"で終わっていません。(preset-ja-technical-writing/ja-no-mixed-period)"
      end

      context "with default max_severity" do
        subject(:errors) do
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

      context "with .max_severity = 'warn'" do
        subject(:errors) do
          @textlint.max_severity = "warn"
          @textlint.parse(fixture)
        end

        it "all errors severity are warn" do
          expect(errors.all? { |error| error[:severity] == "warn" }).to be true
        end
      end
    end

    describe ".lint" do
      let(:expect_message) do
        "文末が\"。\"で終わっていません。(preset-ja-technical-writing/ja-no-mixed-period)"
      end

      # stub for simulate to run textlint
      before { allow(@textlint).to receive(:run_textlint).and_return fixture }

      context "with default max_severity" do
        before { @textlint.lint }

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

      context "with .max_severity = 'warn'" do
        before do
          @textlint.max_severity = "warn"
          @textlint.lint
        end

        it "status_report" do
          status_report = @textlint.status_report
          expect(status_report[:errors].size).to eq(0)
          expect(status_report[:warnings].size).to be > 0
        end

        it "violation_report" do
          violation_report = @textlint.violation_report
          expect(violation_report[:errors].size).to eq(0)
          expect(violation_report[:warnings][0]).to eq(
            Violation.new(expect_message, false, "articles/1.md", 3)
          )
        end
      end
    end

    describe ".target_files" do
      let(:file1) { "articles/1.md" }
      let(:file2) { "articles/2.md" }
      let(:file3) { "articles/3.md" }

      before do
        allow(@textlint.git).to receive(:added_files).and_return([file1])
        allow(@textlint.git).to receive(:modified_files).and_return([file2])
      end

      it "are add and modified files only" do
        allow(@textlint.git).to receive(:deleted_files).and_return([])

        expect(@textlint.send(:target_files)).to match_array([file1, file2])
      end

      it "are also include removed file" do
        allow(@textlint.git).to receive(:deleted_files).and_return([file3])

        expect(@textlint.send(:target_files)).to match_array([file1, file2])
      end
    end
  end
end
