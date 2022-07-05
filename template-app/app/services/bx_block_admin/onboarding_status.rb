module BxBlockAdmin
  class OnboardingStatus
    def initialize
      @brand_setting = BxBlockStoreProfile::BrandSetting.first
      @catalogue = BxBlockCatalogue::Catalogue.first
      @variant = BxBlockCatalogue::Variant.first
      @category = BxBlockCategoriesSubCategories::Category.first
      @onboarding = BxBlockAdmin::Onboarding.first
      @api_configuration_payment = BxBlockApiConfiguration::ApiConfiguration.where(configuration_type: ['stripe', 'razorpay']).first
      @api_configuration_shipping = BxBlockApiConfiguration::ApiConfiguration.where(configuration_type: ['shiprocket', '525k']).first
      @tax = BxBlockOrderManagement::Tax.first 
    end

    def call
      data = {onboarding_steps: [{title: 'Branding', steps_completed: branding.select{|hash| hash if hash[:completion_status] }.size, total_steps: branding.size, steps: branding },{title: 'Products',steps_completed: products.select{|hash| hash if hash[:completion_status] }.size, total_steps: products.size, steps: products},
          {title: 'Business settings', steps_completed: business_settings.select{|hash| hash if hash[:completion_status] }.size, total_steps: business_settings.size, steps: business_settings}],
        percent_completion: percent_completion
      }
      data
    end


    def branding
      [
       {title: 'Theme', description: 'Select a colour theme and homepage template',completion_status: (@brand_setting&.color_palet.present? && @brand_setting&.template_selection.present?)},
       {title: 'Header', description: 'Add your logo and a few other basics', completion_status: (@brand_setting&.heading.present? && @brand_setting&.logo.present?)},
       {title: 'Footer', description: 'Add a customer care phone number and social links', completion_status: @brand_setting&.phone_number.present?},
       {title: 'Banners', description: 'Upload desktop and mobile banner assets to your homepage', completion_status: false}
      ]
    end

    def products
      [
       {
          title: 'Products',
          description: 'Add your products, variants and categories',
          completion_status: (@product.present? && @category.present? && @variant.present?)
        }
      ]
    end

    def business_settings
      [
        {
          title: 'Store details',
          description: 'Define the main details of your store (e.g. phone, address)',
          completion_status: @brand_setting.phone_number.present? && @brand_setting.address.present?
        },
        {
          title: 'Taxes',
          description: 'Define the different taxes that will apply to your products',
          completion_status: @tax.present?
        },
        {
          title: 'Shipping',
          description: 'Customise the shipping charges of your products',
          completion_status: @api_configuration_shipping.present?
        },
        {
          title: 'Payment',
          description: 'Define the payment mechanisim for your sales',
          completion_status: @api_configuration_payment.present?
        }
      ]
    end

    def percent_completion
      begin
        total_steps, steps_completed = @onboarding&.task_info
        (steps_completed.to_f/total_steps.to_f)*100
      rescue
        100
      end
    end

  end
end