class AddEmailDailyDigestNotificationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_daily_digest_notifications, :boolean, default: false
  end
end
