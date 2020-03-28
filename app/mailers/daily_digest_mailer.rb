class DailyDigestMailer < ApplicationMailer
  default from: -> { "DEV Digest <#{SiteConfig.default_site_email}>" }

  def daily_digest_email(user, article)
    @user = user
    @article = article
    subject = "Daily Dev Email"
    mail(to: @user.email, subject: subject)
  end
end
