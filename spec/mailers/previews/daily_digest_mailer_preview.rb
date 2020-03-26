# Preview all emails at http://localhost:3000/rails/mailers/
class DailyDigestMailerPreview < ActionMailer::Preview
  def daily_digest_email
    DailyDigestMailer.daily_digest_email(User.last, Article.all)
  end
end
