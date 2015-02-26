require "pludoni/capybara"
RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
require "timecop"
require 'i18n/missing_translations'
# require 'rspec/retry'
at_exit { I18n.missing_translations.dump }
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)


RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.tty = true
  config.before do
    ActionMailer::Base.deliveries.clear
  end

  # Freeze Time using Timecop
  # freeze_time: "2012-09-01 12:12:12"
  config.around(:each) do |example|
    ex = defined?(example.example) ? example.example : example # rspec 2.14...
    if time = ex.metadata[:freeze_time]
      begin
        Timecop.freeze(Time.parse(time)) do
          example.run
        end
      ensure
        Timecop.return
      end
    else
      example.run
    end
  end

  # Skip = pending all examples
  config.around(:each, :skip => true) do |example|
    example.metadata[:pending] = true
    example.metadata[:execution_result][:pending_message] = "Skipped #{example.to_s}"
  end

  # Activate ActionController Caching
  # caching: true
  config.around(:each, :caching => true) do |example|
    caching, ActionController::Base.perform_caching = ActionController::Base.perform_caching, true
    store, ActionController::Base.cache_store = ActionController::Base.cache_store, :memory_store
    silence_warnings { Object.const_set "RAILS_CACHE", ActionController::Base.cache_store }
    example.run
    silence_warnings { Object.const_set "RAILS_CACHE", store }
    ActionController::Base.cache_store = store
    ActionController::Base.perform_caching = caching
  end

  config.around(:each, :timeout) do |example|
    if example.metadata[:timeout]
      time = 10 unless time.kind_of?(Numeric)
      Timeout.timeout(time) do
        example.run
      end
    else
      example.run
    end
  end

end


silence_warnings do
  begin
  require "bcrypt"
  BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST
  rescue StandardError
  end
end

require "pludoni/mail_helper"
require "pludoni/be_valid"
require "pludoni/translation_helper"




