module BxBlockAdmin
  class OnboardingStatus
    def initialize
      @brand_setting = BxBlockStoreProfile::BrandSetting.first
      @catalogue = BxBlockCatalogue::Catalogue.first
      @variant = BxBlockCatalogue::Variant.first
      @category = BxBlockCategoriesSubCategories::Category.first
      @onboarding = BxBlockAdmin::Onboarding.first
    end

    def call
      data = {onboarding_steps: [{title: 'Branding',steps: branding},{title: 'Products',steps: products},
          {title: 'Business settings',steps: business_settings}],
        percent_completion: percent_completion
      }
      data
    end


    def branding
      {
        theme: {title: 'Theme', description: 'Select a colour theme and homepage template',completion_status: (@brand_setting&.color_palet.present? && @brand_setting&.template_selection.present?)},
        header: {title: 'Header', description: 'Add your logo and a few other basics', completion_status: (@brand_setting&.heading.present? && @brand_setting&.logo.present?)},
        footer: {title: 'Footer', description: 'Add a customer care phone number and social links', completion_status: @brand_setting&.phone_number.present?},
        banners: {title: 'Banners', description: 'Upload desktop and mobile banner assets to your homepage', completion_status: false}
      }
    end

    def products
      {
        products: {
          title: 'Products',
          description: 'Add your products, variants and categories',
          completion_status: (@product.present? && @category.present? && @variant.present?)
        }
      }
    end

    def business_settings
      {
        lorem1: {
          title: 'Lorem1',
          description: 'Lorem 1',
          completion_status: false
        },
        lorem2: {
          title: 'Lorem2',
          description: 'Lorem 2',
          completion_status: false

        }
      }
    end

    def percent_completion
      total_steps, steps_completed = @onboarding.task_info
      begin
        (steps_completed.to_f/total_steps.to_f)*100
      rescue
        100
      end
    end

  end
end