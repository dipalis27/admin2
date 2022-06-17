module BxBlockAdmin
  class OrderReport

    def initialize
      @orders = BxBlockOrderManagement::Order.not_in_cart.includes(:order_items)
      @report_orders = @orders.where('extract(month from order_date) = ?',Date.today.month)
      @today_orders = @report_orders.one_day_orders(Date.today)
    end

    def call
      dates = @report_orders.pluck(:order_date).compact
      response = {today_sales: today_sales, today_orders: @today_orders.size, total_sales: total_sales, total_orders: @orders.size, monthly_report: monthly_report(dates) }
      response
    end

    def today_sales
      '%.2f' % @today_orders.map(&:total).sum.round(2)
    end

    def total_sales
      '%.2f' % @orders.map(&:total).compact.sum
    end

    def monthly_report(dates)
      data = []
      dates.compact.map{|a|a.to_date}.uniq.sort_by{|d| d.to_date }.reverse!.each do |date|
        one_day_orders = @report_orders.one_day_orders(date)
        invoiced_orders = one_day_orders.select{|order| order.total if order.status == 'delivered'}
        refunded_orders = one_day_orders.select{|order| order.total if order.status == 'refunded'}
        cancelled_orders = one_day_orders.select{|order| order.total if order.status == 'cancelled'}
        day_data = {
          period: date,
          report_orders: one_day_orders.size,
          sale_items: one_day_orders.map{|order| order.order_items.pluck(:quantity).sum}.sum,
          sales_total: '%.2f' % one_day_orders.map(&:total).sum.round(2),
          invoiced: '%.2f' % invoiced_orders.compact.sum.round(2),
          refunded: '%.2f' % refunded_orders.compact.sum.round(2),
          sales_tax: '%.2f' % one_day_orders.map(&:total_tax).compact.sum.round(2),
          sales_shipping: '%.2f' % one_day_orders.map(&:shipping_total).compact.sum.round(2),
          sales_discount: '%.2f' % one_day_orders.map(&:applied_discount).compact.sum.round(2),
          cancelled: '%.2f' % cancelled_orders.compact.sum.round(2)
        }
        data << day_data
      end
      data
    end
  end
end
