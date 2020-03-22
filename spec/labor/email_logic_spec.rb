require "rails_helper"

RSpec.describe EmailLogic, type: :labor do
  # create a user. maybe this is the ruby way to test javascript?
  let(:user) { create(:user) }

  # tests the analyaze method
  describe "#analyze" do
    context "when user is brand new with no-follow" do
      it "returns 0.5 for open_percentage" do
        # create an author
        author = create(:user)
        # user follows an author
        user.follow(author)
        # create 3 articles
        create_list(:article, 3, user_id: author.id, positive_reactions_count: 20, score: 20)
        # email logic class is described class and we expect that when we call the analyze method on it, open_percentage will equal 0.5
        # if the user has been sent less than 10 emails, open rate defaults to 0.5
        h = described_class.new(user).analyze
        expect(h.open_percentage).to eq(0.5)
      end

      # tests value articles_to_send variable
      it "provides top 3 articles" do
        # create 3 articles
        create_list(:article, 3, positive_reactions_count: 40, featured: true, score: 40)

        # we expect the length of articles_to_send to equal 3
        h = described_class.new(user).analyze
        expect(h.articles_to_send.length).to eq(3)
      end

      # tests should_receive_email? method
      it "marks as not ready if there isn't atleast 3 articles" do
        create_list(:article, 2, positive_reactions_count: 40, score: 40)

        # we expect that the should_receive_email method will return false because the article is less than 3
        h = described_class.new(user).analyze
        expect(h.should_receive_email?).to eq(false)
      end

      # accounts for above test case only with email-digest-eligible articles
      it "marks as not ready if there isn't at least 3 email-digest-eligible articles" do
        create_list(:article, 2, positive_reactions_count: 40, score: 40)
        create_list(:article, 2, positive_reactions_count: 40, email_digest_eligible: false)

        # confirms that if email_digest_eligible is false, should_receive_email? will return false
        h = described_class.new(user).analyze
        expect(h.should_receive_email?).to eq(false)
      end
    end

    context "when a user's open_percentage is low " do
      before do
        author = create(:user)
        user.follow(author)
        create_list(:article, 3, user_id: author.id, positive_reactions_count: 20, score: 20)
        # sends 10 emails to user to get open_percentage out of the 0.5 range
        10.times do
          Ahoy::Message.create(mailer: "DigestMailer#digest_email",
                               user_id: user.id, sent_at: Time.current.utc)
        end
      end

      it "will not send email when user shouldn't receive any" do
        # because the time at which the emails were sent (last_email_sent_at) is the current time, should_receive_email? will return false
        h = described_class.new(user).analyze
        expect(h.should_receive_email?).to eq(false)
      end
    end

    context "when a user's open_percentage is high" do
      before do
        10.times do
          Ahoy::Message.create(mailer: "DigestMailer#digest_email", user_id: user.id,
                               sent_at: Time.current.utc, opened_at: Time.current.utc)
          author = create(:user)
          user.follow(author)
          create_list(:article, 3, user_id: author.id, positive_reactions_count: 40, score: 40)
        end
      end

      it "evaluates that user is ready to receive an email" do
        Timecop.freeze(3.days.from_now) do
          # the minimum amount of time that can elapse before another email is sent is 2 days, so at the 3 day mark, an email can be sent
          h = described_class.new(user).analyze
          expect(h.should_receive_email?).to eq(true)
        end
      end
    end
  end

  describe "#should_receive_email?" do
    it "reflects @ready_to_receive_email" do
      author = create(:user)
      user.follow(author)
      create_list(:article, 3, user_id: author.id, positive_reactions_count: 20, score: 20)

      # because all of the article attributes satisfy the where clauses in followed_articles this expectation returns true
      h = described_class.new(user).analyze
      expect(h.should_receive_email?).to eq(true)
    end
  end
end
