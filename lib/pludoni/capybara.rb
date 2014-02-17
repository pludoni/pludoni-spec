
RSpec.configure do |config|
  config.after :each, js: true do |example|
    ex = defined?(example.example) ? example.example : example # rspec 2.14...
    exception = ex.exception
    if exception.present? and ex.metadata[:type] == :feature and ex.metadata[:js]
      if defined? screenshot
        puts "made screenshot to /error.jpg (#{exception.inspect})"
        screenshot "error"
      end
    end
  end
end
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 300, js_errors: false)
end
Capybara.javascript_driver = :poltergeist

module PoltergeistHelper
  # render screenshot of current page to /screenshot.jpg
  def screenshot(name="screenshot")
    if defined? page.driver.save_screenshot
      page.driver.save_screenshot "public/#{name}.jpg", full: true
    else
      page.driver.render(Rails.root.join("public/#{name}.jpg").to_s,full: true)
    end
  end

  def simple_t(lab)
    I18n.t("simple_form.labels.defaults.#{lab}")
  end

  # 404 Fehlern vorbeugen -> Wir haben paperclip tmp in usage, also werden
  # hochgeladene Logos nicht angezeigt
  # -> 404 -> Test Failure
  def stub_logo!(object,method=:logo)
    logo = Object.new
    def logo.url(*whatever) "" end
    def logo.method_missing(name,*args) true end
    object.any_instance.stub method => logo, :"#{method}_file_name" => "foo.png"
  end

  # skip any confirm: "Really delete?"
  def skip_confirm(page)
    page.evaluate_script('window.confirm = function() { return true; }')
  end
end

RSpec.configure do |config|
  config.include PoltergeistHelper, type: :feature
end
