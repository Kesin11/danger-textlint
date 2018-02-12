# frozen_string_literal: true

require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerTextlint do
    it "should be a plugin" do
      expect(Danger::DangerTextlint.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.textlint
      end
    end

    describe "textlint config" do
      describe ".target_path" do
      end

      describe ".config_file" do
      end
    end

    describe ".send_inline_comment" do
    end

    describe ".lint" do
    end
  end
end
