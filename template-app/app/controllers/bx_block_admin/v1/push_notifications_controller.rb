module BxBlockAdmin

  module V1

    class PushNotificationsController < ApplicationController
      before_action :set_notification, only:[:show, :update, :send_notification, :destroy]

      def index
        per_page = params[:per_page].present? ? params[:per_page].to_i : 10
        current_page = params[:page].present? ? params[:page].to_i : 1
        notifications = BxBlockNotification::PushNotification.order(created_at: :desc).page(current_page).per(per_page)

        if notifications.present?
          render json: PushNotificationSerializer.new(notifications, pagination_data(notifications, per_page)).serializable_hash, status: :ok
        else
          render json: {message: "No notifications found"}, status: :not_found
        end
      end

      def create
        @notification = BxBlockNotification::PushNotification.create(notification_params)

        if @notification.save
          render json: PushNotificationSerializer.new(@notification).serializable_hash, status: :ok
        else
          render json: {"errors": @notification.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def show
        render json: PushNotificationSerializer.new(@notification).serializable_hash, status: :ok
      end

      def update
        if @notification.update(notification_params)
          render json: PushNotificationSerializer.new(@notification).serializable_hash, status: :ok
        else
          render json: {"errors": @notification.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy
        if @notification.destroy
          render json: {"message": "Notifcation destroyed successfully"}, status: :ok
        else
          render json: {"errors": @notification.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def send_notification
        @notification.update(updated_at: Time.now)
        BxBlockNotification::PushNotificationJob.perform_later(@notification)
        render json: {"message": "Notification sent successfully"}, status: :ok
      end

      private

      def notification_params
        params.permit(:id, :title, :message)
      end

      def set_notification
        begin
          @notification = BxBlockNotification::PushNotification.find(notification_params[:id])
        rescue 
          render json: {"errors": ["No notification found"] }, status: 404
        end
      end
    end
  end
end
