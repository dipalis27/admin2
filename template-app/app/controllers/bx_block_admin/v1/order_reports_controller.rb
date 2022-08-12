module BxBlockAdmin
  module V1
    class OrderReportsController < ApplicationController
      def index
        order_reports = BxBlockAdmin::OrderReport.new.call
        if order_reports
          render json: order_reports, status: :ok
        else
          render json: {errors: [{order_reports: "Order Report Not Found"},
          ]}, status: :unprocessable_entity
        end
      end

      def get_sales_chart_data
        response = BxBlockAdmin::OrderReport.new.get_sales(params)
        if response
          render json: {data: response}, status: :ok
        else
          render json: {errors: ["Order Report Not Found"]}, status: :unprocessable_entity
        end
      end
    end
  end
end
