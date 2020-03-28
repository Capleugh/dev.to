# Usecase would be
# EmailDigest.send_periodic_digest_email
# OR
# EmailDigets.send_periodic_digest_email(Users.first(4))

class EmailDigest
  # self. = this.
  def self.send_periodic_digest_email(users = [])
    # new calls initialize method line 13
    new(users).send_periodic_digest_email
  end

  # initialized with users as an empty array
  def initialize(users = [])
    @users = users.empty? ? get_users : users
    # backend constructor - passing through users
  end

  def send_periodic_digest_email
    # find_each for each user
    @users.find_each do |user|
      user_email_heuristic = EmailLogic.new(user).analyze
      next unless user_email_heuristic.should_receive_email?

      articles = user_email_heuristic.articles_to_send
      begin
        DigestMailer.digest_email(user, articles).deliver if user.email_digest_periodic == true
      rescue StandardError => e
        Rails.logger.error("Email issue: #{e}")
      end
    end
  end

  def send_daily_digest_email
    @users.find_each do |user|
      EmailLogic.new(user).analyze_daily_email
    end
  end

  private

  def get_users
    User.where(email_digest_periodic: true).where.not(email: "")
  end
end
