class DailyDigestEmail
  def self.send_daily_digest_email(users = [])
    new(users).send_daily_digest_email
  end

  def initialize(users = [])
    @users = users.empty? ? get_users : users
  end

  def send_daily_digest_email
    @users.find_each do |user|
      article = EmailLogic.new(user).analyze_daily_email

      begin
        DailyDigestMailer.daily_digest_email(user, article).deliver if user.email_daily_digest_notifications == true
      rescue StandardError => e
        Rails.logger.error("Email issue: #{e}")
      end
    end
  end

  private

  def get_users
    User.where(email_daily_digest_notifications: true).where.not(email: "")
  end
end
