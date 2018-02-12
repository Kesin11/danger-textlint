require "mkmf"
require "json"

module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Kenta Kase/danger-textlint
  # @tags monday, weekends, time, rattata
  #
  class DangerTextlint < Plugin
    # textlint lint target path
    # @return [String]
    attr_accessor :target_path

    # .textlintrc path
    # @return [String]
    attr_accessor :config_file

    # Max danger reporting severity
    # default: "fail"
    # @return [String]
    attr_accessor :max_severity

    # Execute textlint
    # @return [void]
    #
    def lint
      bin = textlint_path
      result_json = run_textlint(bin, target_path)
      errors = parse(result_json)
    end

    def parse(json)
      result = JSON(json)

      result.flat_map do |file|
        file_path = file["filePath"]
        file["messages"].map do |message|
          {
            file_path: file_path,
            line: message["line"],
            severity: 2,
            message: "#{message['message']}(#{message['ruleId']})"
          }
        end
      end
    end

    private

    def textlint_path
      local = "./node_modules/.bin/textlint"
      File.exist?(local) ? local : find_executable("textlint")
    end

    def textlint_command(bin, target_path)
      command = "#{bin} -f json"
      command << " -c #{config_file}" if config_file
      "#{command} #{target_path}"
    end

    def run_textlint(bin, target_path)
      command = textlint_command(bin, target_path)
      `#{command}`
    end
  end
end
