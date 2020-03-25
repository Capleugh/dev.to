class DailyDigestMailer < ApplicationMailer
  default from: -> { "DEV Digest <#{SiteConfig.default_site_email}>" }

  def daily_digest_email(user, article)
    @user = user
    @article = article.first
    subject = "Daily Dev"
    mail(to: @user.email, subject: subject)
  end
end
