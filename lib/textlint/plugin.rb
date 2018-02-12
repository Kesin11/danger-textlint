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
  # @example Run textlint and send as inline comment.
  #
  #          textlint.lint "./articles/*.md"
  #
  # @example Keep severity until warning.
  #
  #          textlint.max_severity = "warn"
  #          textlint.lint "./articles/*.md"
  #
  # @see  Kesin11/danger-textlint
  # @tags lint, textlint
  #
  class DangerTextlint < Plugin
    # textlint lint target path
    # @return [String]
    attr_accessor :target_path

    # .textlintrc path
    # @return [String]
    attr_accessor :config_file

    # Set max danger reporting severity
    # choice: nil or "warn"
    # @return [String]
    attr_accessor :max_severity

    # Execute textlint and send comment
    # @return [void]
    def lint
      bin = textlint_path
      result_json = run_textlint(bin, target_path)
      errors = parse(result_json)
      send_comment(errors)
    end

    # Parse textlint json report
    # @param [String]
    #         Report json output by textlint -f json
    # @return [Array<Hash>]
    def parse(json)
      result = JSON(json)
      dir = "#{Dir.pwd}/"
      severity_method = {
        1 => "warn",
        2 => "fail"
      }

      result.flat_map do |file|
        file_path = file["filePath"]
        file["messages"].map do |message|
          severity = max_severity == "warn" ? 1 : message["severity"]
          {
            file_path: file_path.gsub(dir, ""),
            line: message["line"],
            severity: severity_method[severity],
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
      command = "#{command} #{target_path}"
      p command
      command
    end

    def run_textlint(bin, target_path)
      command = textlint_command(bin, target_path)
      `#{command}`
    end

    def send_comment(errors)
      errors.each do |error|
        send(error[:severity], error[:message], file: error[:file_path], line: error[:line])
      end
    end
  end
end
