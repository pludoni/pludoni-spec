if `whoami`["jenkins"]
  require 'simplecov'
  require 'simplecov-rcov-text'
  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovTextFormatter.new.format(result)
    end
  end
  # SimpleCov.add_filter 'app/models/crawler/dresdende/'
  # SimpleCov.add_filter 'app/models/drupalapi/'
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start 'rails' do
    add_filter do |source_file|
      source_file.lines.count < 10
    end
    add_group "Long files" do |src_file|
      src_file.lines.count > 150
    end
  end
end
