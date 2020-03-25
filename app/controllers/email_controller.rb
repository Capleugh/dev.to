class EmailController < ApplicationController
  def index
    article = EmailDigest.send_daily_digest_email
    DailyDigestMailer.daily_digest_email(current_user, article).deliver_now
  end
end
