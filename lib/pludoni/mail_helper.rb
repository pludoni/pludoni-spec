
# include into mail-sending scenarios
module MailHelper
  extend ActiveSupport::Concern
  included do
    after(:each) do
      ActionMailer::Base.deliveries.each do |mail|
        if mail.body.to_s[/translation missing: (.*)"/]
          fail "There are missing translations: #{$1}"
        end
        if (mail.body.parts.first.to_s[/translation missing: (.*)"/] rescue false)
          fail "There are missing translations: #{$1}"
        end
      end
    end

    def mail
      ActionMailer::Base.deliveries.last
    end
    def mails
      ActionMailer::Base.deliveries
    end
    let(:multi_part_body) { mail.body.parts.first.to_s }
  end

end
