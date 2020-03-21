# Usecase would be
# EmailDigest.send_periodic_digest_email
# OR
# EmailDigets.send_periodic_digest_email(Users.first(4))

class EmailDigest
  # instantiates a new instance of itself and calling this method on an array of users
  def self.send_periodic_digest_email(users = [])
    new(users).send_periodic_digest_email
  end

  # initialized with an empty array called users
  def initialize(users = [])
    # if the users array is empty, get users, otherwise return users array
    @users = users.empty? ? get_users : users
  end

  def send_periodic_digest_email
    # find_each records are loaded into memory in batches of the given batch size
    @users.find_each do |user|
      # heuristic generally refers to algorithms, machine learning, or any other faster way to generate data when classic methods will take too long

      # for each user in batch create a new instance of the email logic class which gets initialized with a user, then call the analyze method on it
      user_email_heuristic = EmailLogic.new(user).analyze

      # keep looking through batch unless should_receive_email method returns true
      next unless user_email_heuristic.should_receive_email?

      # pulls articles to send and stores them in the articles variable
      articles = user_email_heuristic.articles_to_send

      # starts process of sending off email to users who are eligible to receive email
      begin
        DigestMailer.digest_email(user, articles).deliver if user.email_digest_periodic == true
        # e will return a return a standard error
      rescue StandardError => e
        # this will log that error for developer
        Rails.logger.error("Email issue: #{e}")
      end
    end
  end

  private

  # reaches into db and grabs the user where email_digest_periodic == true and where email is not an empty string
  def get_users
    User.where(email_digest_periodic: true).where.not(email: "")
  end
end
