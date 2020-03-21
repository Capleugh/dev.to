require "rails_helper"

# factory bot stubbs delegation.
class FakeDelegator < ActionMailer::MessageDelivery
  # TODO: we should replace all usage of .deliver to .deliver_now

  # stubbed email delivery
  def deliver(*args)
    # inherits from actionmailer
    super
  end
end

RSpec.describe EmailDigest, type: :labor do
  # fakes user who has opted in to have an emaiol digest sent to them
  let(:user) { create(:user, email_digest_periodic: true) }
  # fake user who has posted an article

  let(:author) { create(:user) }

  # instance double allows us to mock an instance of the fake delegator class
  let(:mock_delegator) { instance_double("FakeDelegator") }

  before do
    # digest email is an instance of digest mailer that we are mocking out
    allow(DigestMailer).to receive(:digest_email) { mock_delegator }
    # mock delegator stubs delivery of email digest
    allow(mock_delegator).to receive(:deliver).and_return(true)
    # and return user
    user
  end

  describe "::send_digest_email" do
    context "when there's article to be sent" do
      # acts_as_follower allows us to call .follow on user
      before { user.follow(author) }

      it "send digest email when there's atleast 3 hot articles" do
        # creates a list of three articles
        create_list(:article, 3, user_id: author.id, positive_reactions_count: 20, score: 20)
        # described class is the EmailDigest class and we'll call send_periodic digest_email which determines whether a user is eligible to receive digest and what articles to send
        described_class.send_periodic_digest_email

        # we expect that the DigestMailer class will receive the and instance of digest_email which takes two arguments, one being a user and the other being an array of three articles
        expect(DigestMailer).to have_received(:digest_email).with(
          user, [instance_of(Article), instance_of(Article), instance_of(Article)]
        )
      end
    end
  end
end
