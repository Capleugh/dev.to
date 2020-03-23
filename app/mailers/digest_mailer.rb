class DigestMailer < ApplicationMailer
  # email configuration from rails
  # Sets the from line in the email
  default from: -> { "DEV Digest <#{SiteConfig.default_site_email}>" }

  # user is who we want to send the email to
  # articles will be an array of articles to send
  def digest_email(user, articles)
    @user = user
    @articles = articles.first(6)
    @unsubscribe = generate_unsubscribe_token(@user.id, :email_digest_periodic)
    subject = generate_title
    mail(to: @user.email, subject: subject)
  end

  private

  # creates a title by concatenating the first article's title with the number of articles minus one, email end phrase, and randomly selected emojis
  def generate_title
    "#{adjusted_title(@articles.first)} + #{@articles.size - 1} #{email_end_phrase} #{random_emoji}"
  end

  # takes the article title and removes any trailing or leading whitespace
  def adjusted_title(article)
    title = article.title.strip
    # ensures the title will have quotes around it unless it already starts with a quote
    "\"#{title}\"" unless title.start_with? '"'
  end

  # shuffles this array of emojis, takes the first 3, and joins them into a string.
  def random_emoji
    ["🤓", "🎉", "🙈", "🔥", "💬", "👋", "👏", "🐶", "🦁", "🐙", "🦄", "❤️", "😇"].shuffle.take(3).join
  end

  # Selects one string from this array randomly
  def email_end_phrase
    # "more trending DEV posts" won the previous split test
    # Included more often as per explore-exploit algorithm
    [
      "more trending DEV posts",
      "more trending DEV posts",
      "more trending DEV posts",
      "more trending DEV posts",
      "more trending DEV posts",
      "more trending DEV posts",
      "more trending DEV posts",
      "more trending DEV posts",
      "more trending DEV posts",
      "other posts you might like",
      "other DEV posts you might like",
      "other trending DEV posts",
      "other top DEV posts",
      "more top DEV posts",
      "more top reads from the community",
      "more top DEV posts based on your interests",
      "more trending DEV posts picked for you",
    ].sample
  end
end
