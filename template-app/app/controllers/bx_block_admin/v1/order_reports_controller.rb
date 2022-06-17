module BxBlockAdmin
  module V1
    class OrderReportsController < ApplicationController
      def index
        order_reports = BxBlockAdmin::OrderReport.new.call
        if order_reports
          render json: order_reports, status: :ok
        else
          render json: {errors: [{order_reports: "Order Report Found"},
          ]}, status: :unprocessable_entity
        end
      end
    end
  end
end
