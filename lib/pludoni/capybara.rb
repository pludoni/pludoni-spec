
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 300)
end
Capybara.javascript_driver = :poltergeist

module PoltergeistHelper
  # render screenshot of current page to /screenshot.jpg
  def screenshot(name="screenshot")
    page.driver.render(Rails.root.join("public/#{name}.jpg").to_s,full: true)
  end

  def simple_t(lab)
    I18n.t("simple_form.labels.defaults.#{lab}")
  end

  # 404 Fehlern vorbeugen -> Wir haben paperclip tmp in usage, also werden
  # hochgeladene Logos nicht angezeigt
  # -> 404 -> Test Failure
  def stub_logo!
    logo = Object.new
    def logo.url(whatever) "" end
    Company.any_instance.stub :logo => logo
  end

  # skip any confirm: "Really delete?"
  def skip_confirm(page)
    page.evaluate_script('window.confirm = function() { return true; }')
  end
end
