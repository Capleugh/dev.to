class EmailLogic
  attr_reader :open_percentage, :last_email_sent_at, :days_until_next_email, :articles_to_send

  # initializes this EmailLogic object with the following attributes
  # only open_percentage, last_email_sent_at, days_until_next_email, and articles_to_send are readable externally
  def initialize(user)
    @user = user
    @open_percentage = nil
    @ready_to_receive_email = nil
    @last_email_sent_at = nil
    @days_until_next_email = nil
    @articles_to_send = []
  end

  # this method is made up of several helper methods
  def analyze
    @last_email_sent_at = get_last_digest_email_user_received
    @open_percentage = get_open_rate
    @days_until_next_email = get_days_until_next_email
    @ready_to_receive_email = get_user_readiness
    @articles_to_send = get_articles_to_send if @ready_to_receive_email
    self
  end

  # will return false or true to determine if user should receive email
  def should_receive_email?
    @ready_to_receive_email
  end

  private

  def get_articles_to_send
    # gets a date to use to filter through articles
    fresh_date = get_fresh_date

    # runs the activerecord query if user has any followings
    articles = if user_has_followings?
                 # sets a minimum and maximum for experience level based off user's experience level
                 # experience level is something saved on the user table
                 experience_level_rating = (@user.experience_level || 5)
                 experience_level_rating_min = experience_level_rating - 3.6
                 experience_level_rating_max = experience_level_rating + 3.6

                 # from these followed articles, filter through and grab the one that
                 @user.followed_articles.
                   # have a more recent (greater) date than the date returned from fresh_date
                   where("published_at > ?", fresh_date).
                   # that are published and eligible for the email digest
                   where(published: true, email_digest_eligible: true).
                   # that are not written by the user themselves
                   where.not(user_id: @user.id).
                   # with a score greater than 12
                   where("score > ?", 12).
                   # with experience levels between the minimum and maximum experience level amounts set above
                   where("experience_level_rating > ? AND experience_level_rating < ?",
                         experience_level_rating_min, experience_level_rating_max).
                   # organizes the articles by score in descending order
                   order("score DESC").
                   # only returns 8 articles
                   limit(8)
               # if no followed articles are returned for the user
               else
                 # run this ActiveRecord query
                 Article.published.
                   # have a more recent (greater) date than the date returned from fresh_date
                   where("published_at > ?", fresh_date).
                   # that are published and eligible for the email digest
                   where(featured: true, email_digest_eligible: true).
                   # that are not written by the user themselves
                   where.not(user_id: @user.id).
                   # with a score greater than 25
                   where("score > ?", 25).
                   # organizes the articles by score in descending order
                   order("score DESC").
                   # only returns 8 articles
                   limit(8)
               end
    # if there are less than 3 articles, ready_to_receive_email will return false
    @ready_to_receive_email = false if articles.length < 3

    # returns the articles from the appropriate ActiveRecord query
    articles
  end

  def get_days_until_next_email
    # Relies on hyperbolic tangent function to model the frequency of the digest email
    # maximum is 0 days
    max_day = SiteConfig.periodic_email_digest_max
    # minimum is 2 days
    min_day = SiteConfig.periodic_email_digest_min
    # this is the hyperbolic tangent function
    result = max_day * (1 - Math.tanh(2 * @open_percentage))
    result = result.round
    # if the rounded result of the hyperbolic tangent function is less than the minimum amount of days
    # then return the minimum amount of days
    # otherwise return the rounded result of the tangent function
    result < min_day ? min_day : result
  end

  def get_open_rate
    # requests 10 emails sent to the user with ActiveRecord query
    past_sent_emails = @user.email_messages.where(mailer: "DigestMailer#digest_email").limit(10)
    # counts the actual number of emails returned from this query
    past_sent_emails_count = past_sent_emails.count

    # Will stick with 50% open rate if @user has no/not-enough email digest history
    return 0.5 if past_sent_emails_count < 10

    # counts how many of those emails were actually opened if the email count is not less than 10
    past_opened_emails_count = past_sent_emails.where("opened_at IS NOT NULL").count
    # divides the number of opened emails by the number sent to get the open rate percentage
    past_opened_emails_count / past_sent_emails_count
  end

  def get_user_readiness
    # will return true unless a date is returned from the last_email_sent_at method
    return true unless @last_email_sent_at

    # Has it been at least x days since @user received an email?
    Time.current - @last_email_sent_at >= @days_until_next_email.days.to_i
  end

  def get_last_digest_email_user_received
    # returns the date/time of the last digest email sent to the user
    @user.email_messages.where(mailer: "DigestMailer#digest_email").last&.sent_at
  end

  def get_fresh_date
    # a few days ago is 4 days prior to when this is run
    a_few_days_ago = 4.days.ago.utc
    # will return time date/time 4 days ago unless last_email_sent_at returns a date/time
    return a_few_days_ago unless @last_email_sent_at

    # if the value of few_days_ago is more current (greater) than the date of the last digest email sent
    # then return few_days_ago; otherwise, return the date of the last email digest sent
    a_few_days_ago > @last_email_sent_at ? a_few_days_ago : @last_email_sent_at
  end

  def user_has_followings?
    # checks if user is following any users or any tags
    following_users = @user.cached_following_users_ids
    following_tags = @user.cached_followed_tag_names
    following_users.any? || following_tags.any?
  end
end
