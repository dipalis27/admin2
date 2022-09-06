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
          sales_total: '%.2f' % one_day_orders.map(&:total).compact.sum.round(2),
          invoiced: '%.2f' % invoiced_orders.map(&:total).compact.sum.round(2),
          refunded: '%.2f' % refunded_orders.map(&:total).compact.sum.round(2),
          sales_tax: '%.2f' % one_day_orders.map(&:total_tax).compact.sum.round(2),
          sales_shipping: '%.2f' % one_day_orders.map(&:shipping_total).compact.sum.round(2),
          sales_discount: '%.2f' % one_day_orders.map(&:applied_discount).compact.sum.round(2),
          cancelled: '%.2f' % cancelled_orders.map(&:total).compact.sum.round(2)
        }
        data << day_data
      end
      data
    end

    def get_sales(filters)
      if [3,6,9,12].include?(filters[:duration].to_i)
        range = time_range(filters)
        monthly_order(filters,range)
      elsif filters[:duration].to_s.downcase == 'lifetime'
        start_date = BxBlockStoreProfile::BrandSetting.first.created_at.to_date
        end_date = Date.today.end_of_day
        range = start_date..end_date
        monthly_order(filters,range)
      elsif filters[:duration].to_s.downcase == 'today'
        range = (0..23).to_a.map{|h| h < 10 ? "0#{h}" : h.to_s}
        hourly_sales = {}
        range.map{|hour| hourly_sales[hour.to_s.to_sym] = [0] }
        orders = @orders.where(order_date: Date.today.beginning_of_day..Date.today.end_of_day)
        accounts_count = AccountBlock::Account.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day).count
        orders.each do |order|
          hour = order.order_date.strftime("%H")
          hourly_sales[hour.to_sym].present? ? (hourly_sales[hour.to_sym] << order.total ) : (hourly_sales[hour.to_sym] = ([] << order.total))
        end
        total_sales = {}
        hourly_sales.keys.each do |key|
          total_sales[key] = hourly_sales[key].sum.to_f
        end
        response_formatter(filters, total_sales, hourly_sales.keys.map(&:to_s), orders.size, accounts_count)
      elsif filters[:duration].to_i == 1
        range = Date.today.beginning_of_month..Date.today.end_of_month
        daily_sales = {}
        range.to_a.map{|day| daily_sales[day.strftime("%d").to_s.to_sym] = [0] }
        orders = @orders.where(order_date: range)
        accounts_count = AccountBlock::Account.where(created_at: range).count
        orders.each do |order|
          day = order.order_date.strftime("%d")
          daily_sales[day.to_s.to_sym].present? ? (daily_sales[day.to_s.to_sym] << order.total ) : (daily_sales[day.to_s.to_sym] = ([] << order.total))
        end
        total_sales = {}
        daily_sales.keys.each do |key|
          total_sales[key] = daily_sales[key].sum.to_f
        end
        response_formatter(filters, total_sales, daily_sales.keys.map(&:to_s), orders.size, accounts_count)
      end
    end

    def time_range(filters)
      duration = filters[:duration]
      if [3,6,9,12].include?(filters[:duration].to_i)
        ((Date.today - (duration.to_i - 1).months))..(Date.today.end_of_day)
      end
    end

    def month_year(day)
      "#{day.strftime("%b")}-#{day.strftime("%y")}"
    end

    def monthly_order(filters,range)
      months = []
      total_sales = {}
      range.to_a.map{|day| months << month_year(day) if !(months.include?(month_year(day)))}
      months.map{|month| total_sales[month.to_sym]= 0}
      orders = @orders.where(order_date: range).group_by{|order| order.order_date.beginning_of_month}
      accounts_count = AccountBlock::Account.where(created_at: range).count
      orders_count = 0
      orders.keys.each do |month|
        month_orders = orders[month]
        orders_count = orders_count + month_orders.size
        month_total = month_orders.map{|order| order.total}.sum.to_f
        total_sales[month_year(month).to_sym] = month_total
      end
      response_formatter(filters, total_sales, months, orders_count, accounts_count)
    end

    def response_formatter(filters, total_sales, range, orders_count, accounts_count)
      total_sales_values = total_sales.values.sum.to_f
      avg_order_value = '%.2f' % (total_sales_values / (orders_count > 0 ? orders_count : 1)) rescue 0.0
      total_sales_values = '%.2f' % total_sales_values
      {
        filters: {duration: filters[:duration]}, 
        totals: total_sales,
        avg_order_value: avg_order_value,
        total_sales: total_sales_values,
        accounts_count: accounts_count,
        orders_count: orders_count,
        range: range
      }
    end
  end
end
