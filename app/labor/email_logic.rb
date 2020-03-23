class EmailLogic
  # attr_readers for attributes in intialize
  attr_reader :open_percentage, :last_email_sent_at, :days_until_next_email, :articles_to_send

  # EmailLogic initializes with a user
  def initialize(user)
    @user = user
    # the next 4 lines are initialized as nil so you can assign some other value to them later
    @open_percentage = nil
    @ready_to_receive_email = nil
    @last_email_sent_at = nil
    @days_until_next_email = nil
    # articles_to_send initializes as an empty array
    @articles_to_send = []
  end

  def analyze
    # this method is broken out into helper methods which are assigned to instance variables (which were initially defined in initialize) below
    @last_email_sent_at = get_last_digest_email_user_received
    @open_percentage = get_open_rate
    @days_until_next_email = get_days_until_next_email
    @ready_to_receive_email = get_user_readiness
    @articles_to_send = get_articles_to_send if @ready_to_receive_email
    self
  end

  # why would you write this when the instance variable gets called in analyze?
  def should_receive_email?
    # returns true or false based on the status of @ready_to_receive_email

    @ready_to_receive_email
  end

  private

  def get_articles_to_send
    # returns a date for us to work with
    fresh_date = get_fresh_date

    # sets up conditional for what is assigned to articles
    # if a user has followings
    articles = if user_has_followings?
                 # sets different experience levels
                 experience_level_rating = (@user.experience_level || 5)
                 experience_level_rating_min = experience_level_rating - 3.6
                 experience_level_rating_max = experience_level_rating + 3.6

                 # calls followed_articles on a user
                 @user.followed_articles.
                   # where published date is more recent than fresh date
                   where("published_at > ?", fresh_date).
                   # where article is both published and eligible for the email digest
                   where(published: true, email_digest_eligible: true).
                   # where the article was written by someone other than @user
                   where.not(user_id: @user.id).
                   # where the article's score is greater than 12
                   where("score > ?", 12).
                   # where experience_level rating is greater than experience_level_rating_min and less thank experience_level_rating_max
                   where("experience_level_rating > ? AND experience_level_rating < ?",
                         experience_level_rating_min, experience_level_rating_max).
                   # order articles by descending score
                   order("score DESC").
                   # skim 8 articles off the top
                   limit(8)
               else
                 # if user does not have followings return articles
                 Article.published.
                   # where published date is more recent than fresh date
                   where("published_at > ?", fresh_date).
                   # where article is both featured and eligible for the email digest
                   where(featured: true, email_digest_eligible: true).
                   # where the article was written by someone other than @user
                   where.not(user_id: @user.id).
                   # where the article's score is greater than 25
                   where("score > ?", 25).
                   # order articles by descending score
                   order("score DESC").
                   # skim 8 articles off the top
                   limit(8)
               end

    # ready_to_receive_email will return true if the number of articles returned is greater than 3
    @ready_to_receive_email = false if articles.length < 3

    # return the result of the conditional stored in articles
    articles
  end

  def get_days_until_next_email
    # Relies on hyperbolic tangent function to model the frequency of the digest email
    # max is 0
    max_day = SiteConfig.periodic_email_digest_max
    # min is 2
    min_day = SiteConfig.periodic_email_digest_min
    # Math is a ruby module. apparently tanh is a reference to some hyperbolic tangent trigonometric function. Never thought I'd actually be using trig in my day to day life but here we are. I'd need a trig refresher to actually understand what's happening here.
    result = max_day * (1 - Math.tanh(2 * @open_percentage))
    # and we're rounding the result
    result = result.round
    # if result is greater than min_day (2), return min_day, otherwise return result
    result < min_day ? min_day : result
  end

  # helper method assigned to @open_percentage
  def get_open_rate
    # finds 10 most recent emails opened by a user
    past_sent_emails = @user.email_messages.where(mailer: "DigestMailer#digest_email").limit(10)

    # counts the number of emails sent to a user
    past_sent_emails_count = past_sent_emails.count

    # Will return with 50% open rate if @user has fewer than 10 emails in digest history
    return 0.5 if past_sent_emails_count < 10

    # Count the number of past emails where opened_at is not nil
    past_opened_emails_count = past_sent_emails.where("opened_at IS NOT NULL").count

    # divide number of opened emails by the number of emails sent to a user
    past_opened_emails_count / past_sent_emails_count
  end

  # helper method assigned to ready_to_receive_email
  def get_user_readiness
    # user is ready to receive email unless it can find the last date an email was received (get_last_digest_email_user_received)
    return true unless @last_email_sent_at

    # Has it been at least x days since @user received an email?
    Time.current - @last_email_sent_at >= @days_until_next_email.days.to_i
  end

  def get_last_digest_email_user_received
    # finds the date of the last email sent and the time it was sent at
    @user.email_messages.where(mailer: "DigestMailer#digest_email").last&.sent_at
  end

  def get_fresh_date
    # calculates 4 days ago from current date
    a_few_days_ago = 4.days.ago.utc

    # returns a_few_days_ago unless date and time are returned
    return a_few_days_ago unless @last_email_sent_at

    # if a_few_days_ago is greater than the date and time the last email was sent at, return a_few_days_ago, else, return last_email_sent_at

    # whatever today's date is, is considered greater
    a_few_days_ago > @last_email_sent_at ? a_few_days_ago : @last_email_sent_at
  end

  def user_has_followings?
    # grabs first 150 followable ids from a user
    following_users = @user.cached_following_users_ids
    # # plucks tag names and followable ids where followable type is "ActsAsTaggableOn::Tag"
    following_tags = @user.cached_followed_tag_names
    # user has followings if following_users or following tags are not nil or empty
    following_users.any? || following_tags.any?
  end
end
