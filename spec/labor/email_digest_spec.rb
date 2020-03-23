require "rails_helper"

class FakeDelegator < ActionMailer::MessageDelivery
  # TODO: we should replace all usage of .deliver to .deliver_now
  def deliver(*args)
    # The use of super means the method will inherit code from a method with the same name from ActionMailer
    super
  end
end

RSpec.describe EmailDigest, type: :labor do
  # setup for users and delegator with factorybot and mocks
  let(:user) { create(:user, email_digest_periodic: true) }
  let(:author) { create(:user) }
  let(:mock_delegator) { instance_double("FakeDelegator") }

  before do
    # similar to the syntax we have used in the past to allow a user to be used as current_user
    # mocks the process of having an email sent through
    allow(DigestMailer).to receive(:digest_email) { mock_delegator }
    allow(mock_delegator).to receive(:deliver).and_return(true)
    user
  end

  describe "::send_digest_email" do
    context "when there's article to be sent" do
      # uses act_as_follower gem to set up follow/following relationship
      before { user.follow(author) }

      it "send digest email when there's at least 3 hot articles" do
        # these 3 articles will be instantiated and sent in the digest
        create_list(:article, 3, user_id: author.id, positive_reactions_count: 20, score: 20)
        described_class.send_periodic_digest_email
        # the digest mailer should contain the user as well as 3 instances of the Article object
        expect(DigestMailer).to have_received(:digest_email).with(
          user, [instance_of(Article), instance_of(Article), instance_of(Article)]
        )
      end
    end
  end
end
