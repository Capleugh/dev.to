class DigestMailer < ApplicationMailer
  # denotes where email is being sent from
  default from: -> { "DEV Digest <#{SiteConfig.default_site_email}>" }

  # takes a user and an array of articles as parameters
  def digest_email(user, articles)
    # denotes a user you want to send email to
    @user = user
    # take first 6 articles from array
    @articles = articles.first(6)
    # to unsubscribe generate_unsubscribe_token takes a the id of the user who wants to unsubscribe and the email type
    @unsubscribe = generate_unsubscribe_token(@user.id, :email_digest_periodic)
    # the private generate title method is assigned to subject
    subject = generate_title
    # send email to user with their email and a subject
    mail(to: @user.email, subject: subject)
  end

  private

  # takes title of the first article in the array of 6, concatenates it with the new number of articles, selects a random email end phrase, and generates three random emojis
  def generate_title
    "#{adjusted_title(@articles.first)} + #{@articles.size - 1} #{email_end_phrase} #{random_emoji}"
  end

  def adjusted_title(article)
    # strips leading or trailing whitespace from the title
    title = article.title.strip
    # Adds quotations to the title if none exist already
    "\"#{title}\"" unless title.start_with? '"'
  end

  def random_emoji
    # shuffles array of emojis, takes 3 from the beginning of the array, and then converts those first three into a string
    ["🤓", "🎉", "🙈", "🔥", "💬", "👋", "👏", "🐶", "🦁", "🐙", "🦄", "❤️", "😇"].shuffle.take(3).join
  end

  def email_end_phrase
    # "more trending DEV posts" won the previous split test
    # Included more often as per explore-exploit algorithm

    # randomly takes a phrase from the following array to tack onto the end of an email
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
