class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_FROM', 'noreply@ildarsafin.tech')
  layout 'mailer'
end
