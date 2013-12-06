# Pludoni Spec helper

Add this line to your application's Gemfile:

```ruby
group :development, :test do
  gem 'pludoni-spec'
end
```

And then your spec-helper:

```ruby
ENV["RAILS_ENV"] ||= 'test'
require "pludoni/coverage"
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "pludoni/spec-helper"

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.use_transactional_fixtures = true
end
```



## On-Demand Modules:

```ruby
# requires and configures Database Cleaner for rspec
require 'pludoni/database-cleaner'

# requires and configures VCR (not part of gems dependencies!)
require 'pludoni/vcr'

# instead of Database Cleaner: patches Active Record thread
require 'pludoni/thread-patch'
```


```ruby
describe MyMailerSpec do
  include MailHelper
  specify do
    # in this scenario, all outgoing deliveries (ActionMailer::Base.deliveries)
    # will be checked for missing translations

    # some methods:
    mail # last ActionMailer::Base.deliveries
    mails # alias for ActionMailer::Base.delivieries
  end
end
```

```ruby
describe MyController do
  include TranslationHelper # will include render_views!!
  specify do
    # will check views if containing Missing Translations
  end
end
```

## spec tags:

```ruby
# TimeCop freeze time, ensures returning to system date
it 'Some example', freeze_time: '2013-10-10 12:12' do
  Time.now.should be constant
end

#enables caching for controller action spec
it 'Some example', caching: true do
end

it 'Timeout', timeout: 10 do
  fail 'this scenario if takes longer than 10s'
end

```

* All js:true feature specs will make an screenshot to public/error.jpg if failed.
* ActionMailer::Base.deliveries.clear will be called before each run
* rspec ``be_valid`` matcher, which shows errors on invalid
* Poltergeist as default JS Driver
* all Feature specs have new methods:

```ruby
  screenshot  # fullscreen screenshot to public/screenshot.jpg
  screenshot '1'          #screenshot to public/1.jpg

  skip_confirm(page) # will overwrite JS confirm method, so delete confirmations will work
```
