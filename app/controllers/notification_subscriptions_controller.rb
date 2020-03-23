class NotificationSubscriptionsController < ApplicationController
  # this controller is responsible for updating a user's notifications/emails they receive from Dev.to
  def show
    # checks to see what subscriptions the user is subscribed to and those they are not subscribed to
    result = if current_user
               NotificationSubscription.where(user_id: current_user.id, notifiable_id: params[:notifiable_id], notifiable_type: params[:notifiable_type]).
                 first&.to_json(only: %i[config]) || { config: "not_subscribed" }
             end
    # respond_to references the response sent to the view
    respond_to do |format|
      # will format the result variable from above into json for the view to render
      format.json { render json: result }
    end
  end

  # if we decide to put the email subscription checkbox under notifications
  # this will be the method we need to use to update the user's subscription
  def upsert
    # 404 unless logged in as current user
    not_found unless current_user

    # initialize in this query will call NotificationSubscription.new if it cannot be found
    @notification_subscription = NotificationSubscription.find_or_initialize_by(user_id: current_user.id,
                                                                                notifiable_id: params[:notifiable_id],
                                                                                notifiable_type: params[:notifiable_type].capitalize)
    # if the user decides to subscribe this will insert or update the notification record in the database
    if params[:config] == "not_subscribed"
      # this delete the NotificationSubscription object
      @notification_subscription.delete
      # NotificationSubscription object is updated on the database
      # User will not receive updates on this subscription if they are the creator of the subscription
      @notification_subscription.notifiable.update(receive_notifications: false) if current_user_is_author?
    else
      @notification_subscription.config = params[:config] || "all_comments"
      # user will receive notifications on all comments made in response to the ones they authored
      receive_notifications = (params[:config] == "all_comments" && current_user_is_author?)
      # updates the receive notifications to true if the method above is true
      @notification_subscription.notifiable.update(receive_notifications: true) if receive_notifications
      # saves the notification subscription to the database
      @notification_subscription.save
    end
    # if the object save correctly in the database
    result = @notification_subscription.persisted?
    # then it will render the result as json
    respond_to do |format|
      format.json { render json: result }
      # redirects back to the path of referer and returns string containing this path
      format.html { redirect_to request.referer }
    end
  end

  private

  # helper method to prevent user from receiving notification about comments, etc. they make themselves
  def current_user_is_author?
    # TODO: think of a better solution for handling mute notifications in dashboard / manage
    current_user.id == @notification_subscription.notifiable.user_id
  end
end
