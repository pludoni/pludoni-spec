require "pludoni/capybara"
require "timecop"
require 'i18n/missing_translations'
at_exit { I18n.missing_translations.dump }
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# monkeypatch -> Transactions fuer Features
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end

RSpec.configure do |config|
  config.include PoltergeistHelper, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.tty = true
  config.before do
    # # WebMock.disable_net_connect!(:allow_localhost => true)
    ActionMailer::Base.deliveries.clear
  end
  # config.around(:each, type: :feature) do |example|
  #   begin
  #     require "action_mailer_cache_delivery"
  #     ActionMailer::Base.delivery_method = :cache
  #     ActionMailer::Base.clear_cache
  #     example.run
  #   ensure
  #     ActionMailer::Base.delivery_method = :file
  #   end
  # end

  config.after :each do
    if example.exception.present? and example.metadata[:type] == :feature
      if defined? screenshot
        puts "made screenshot to /error.jpg"
        screenshot "error"
      end
    end
  end

  # Freeze Time using Timecop
  # freeze_time: "2012-09-01 12:12:12"
  config.around(:each) do |example|
    if time = example.metadata[:freeze_time]
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


end


silence_warnings do
  require "bcrypt"
  BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST
end

require "pludoni/mail_helper"
require "pludoni/be_valid"
require "pludoni/translation_helper"




