module BxBlockAdmin
  module V1
    class OnboardingController < ApplicationController
      def index
        onboarding_status = BxBlockAdmin::OnboardingStatus.new.call
        if onboarding_status
          render json: onboarding_status, status: :ok
        else
          render json: {errors: [
            {onboarding: "Onboarding not found."},
          ]}, status: :unprocessable_entity
        end
      end
    end
  end
end
