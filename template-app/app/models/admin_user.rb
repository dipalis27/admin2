class AdminUser < ApplicationRecord
    #include SessionInfo
    attr_accessor :skip_password_validation
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    has_one :admin_profile, class_name: "BxBlockRoleAndPermission::AdminProfile"
    devise :database_authenticatable,
           :recoverable, :rememberable, :trackable, :validatable
    enum role: %i[super_admin store_admin sub_admin]

    before_create :track_event

    PERMISSION_KEYWORDS = [
        ['product','BxBlockCatalogue::Catalogue'],
        ['category','BxBlockCategoriesSubCategories::Category'],
        ['order', 'BxBlockOrderManagement::Order'],
        ['brand', 'BxBlockCatalogue::Brand'],
        ['coupon', 'BxBlockCouponCodeGenerator::CouponCode'],
        ['tag', 'BxBlockCatalogue::Tag'],
        ['user', 'AccountBlock::Account'],
        ['brand setting', 'BxBlockStoreProfile::BrandSetting'],
        ['tax', 'BxBlockOrderManagement::Tax'],
        ['variant', 'BxBlockCatalogue::Variant'],
        ['email setting', 'BxBlockSettings::EmailSetting']
    ]
    # Add routes inside this as per permissions to give access to sub admin
    PERMISSION_ROUTES = HashWithIndifferentAccess.new({
        'bx_block_admin/v1/catalogues': 'BxBlockCatalogue::Catalogue',
        'bx_block_admin/v1/categories': 'BxBlockCategoriesSubCategories::Category', #valid route needed
        'bx_block_admin/v1/order_reports': 'BxBlockOrderManagement::Order',
        'bx_block_admin/v1/orders': 'BxBlockOrderManagement::Order',
        'bx_block_admin/v1/brand': 'BxBlockCatalogue::Brand', #valid route needed
        'bx_block_admin/v1/coupon': 'BxBlockCouponCodeGenerator::CouponCode', #valid route needed
        'bx_block_admin/v1/tag': 'BxBlockCatalogue::Tag', #valid route needed
        'bx_block_admin/v1/customers': 'AccountBlock::Account',
        'bx_block_admin/v1/brand_settings': 'BxBlockStoreProfile::BrandSetting',
        'bx_block_admin/v1/taxes': 'BxBlockOrderManagement::Tax',
        'bx_block_admin/v1/variants': 'BxBlockCatalogue::Variant',
        'bx_block_admin/v1/email_settings': 'BxBlockSettings::EmailSetting'

    })
    PERMISSION_CONVERSIONS = HashWithIndifferentAccess.new({
        'BxBlockCatalogue::Catalogue': 'catalogue',
        'BxBlockCategoriesSubCategories::Category': 'category',
        'BxBlockOrderManagement::Order': 'order',
        'BxBlockCatalogue::Brand': 'brand',
        'BxBlockCouponCodeGenerator::CouponCode': 'coupon',
        'BxBlockCatalogue::Tag': 'tag',
        'AccountBlock::Account': 'user',
        'BxBlockStoreProfile::BrandSetting': 'brand setting',
        'BxBlockOrderManagement::Tax': 'tax',
        'BxBlockCatalogue::Variant': 'variant',
        'BxBlockSettings::EmailSetting': 'email setting'
    })
    PERMISSIONS = [
        'BxBlockCatalogue::Catalogue', 'BxBlockCategoriesSubCategories::Category',
        'BxBlockOrderManagement::Order', 'BxBlockCatalogue::Brand',
        'BxBlockCouponCodeGenerator::CouponCode', 'BxBlockCatalogue::Tag',
        'AccountBlock::Account', 'BxBlockStoreProfile::BrandSetting', 'BxBlockOrderManagement::Tax', 'BxBlockCatalogue::Variant', 'BxBlockSettings::EmailSetting'
    ]

    #################
    ## Association
    #################

    #################
    ## Validations
    #################
    validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates_presence_of :name, if: -> { role == 'sub_admin' }
    # validates :phone_number, :numericality => true, :length => { :minimum => 10, :maximum => 15 }, presence: true, if: -> { role == 'sub_admin' }
    validate :validate_permissions

    #################
    ## Callbacks
    #################
    #after_update :send_account_activated_email, if: :saved_change_to_activated?
    before_validation :remove_empty_permissions
    before_create :create_admin_profile

    # def active_for_authentication?
    #   super && (activated? || is_super_admin_mode)
    # end

    def track_event
      Analytics.track(user_id: ENV["HOST_URL"].split("-")[1],event: 'New Sub Admins Created')
    end

    def inactive_message
        if !activated?
            :not_activated
        else
            super # Use whatever other message
        end
    end

    def send_account_activated_email
      Api::V1::StoreMailer.with(host: $hostname).store_account_activated(self).deliver_later(wait: 5.seconds) if activated? && sign_in_count < 1 && encrypted_password.blank?
    end

    def change_email_keywords(content, customer: nil, product: nil, variant: nil)
        default_email_setting = BxBlockSettings::DefaultEmailSetting.first
        contact_us =  BxBlockContactUs::Contact.where(account_id: customer&.id).last
        BxBlockSettings::EmailSetting::EMAIL_KEYWORDS.each do |key|
            case  key
            when 'admin'
                content = content.gsub!("%{#{key}}", self&.email&.to_s&.downcase ) || content
            when 'customer_name'
                content = content.gsub!("%{#{key}}", customer&.email.to_s ) || content
            when 'brand_name'
                content = content.gsub!("%{#{key}}", default_email_setting&.brand_name.to_s ) || content
            when 'brand_logo'
                if default_email_setting
                    content = content.gsub!("%{#{key}}", "<div><img height='150px' src='#{$hostname + Rails.application.routes.url_helpers.rails_blob_path(default_email_setting&.logo, only_path: true)}'/></div>" ) || content
                end
            when 'recipient_email'
                content = content.gsub!("%{#{key}}", default_email_setting&.contact_us_email_copy_to.to_s ) || content
            when 'contact_name'
                content = content.gsub!("%{#{key}}", contact_us&.name.to_s ) || content
            when 'contact_email'
                content = content.gsub!("%{#{key}}", contact_us&.email.to_s ) || content
            when 'contact_phone'
                content = content.gsub!("%{#{key}}", contact_us&.phone_number.to_s ) || content
            when 'query'
                content = content.gsub!("%{#{key}}", contact_us&.description.to_s ) || content
            when 'product_name'
                content = content.gsub!("%{#{key}}", product&.name.to_s ) || content
            when 'product_qty'
                qty = variant.present? ? variant.stock_qty.to_s : product&.stock_qty.to_s
                content = content.gsub!("%{#{key}}", qty ) || content
            else
                content
            end
        end
        content
    end

    def create_admin_profile
        self.admin_profile = BxBlockRoleAndPermission::AdminProfile.create(name: self&.name, phone: self&.phone_number, email: self&.email) if self.admin_profile.nil?
        self.admin_profile
    end

    def valid_otp?(otp)
        (self.otp_code == otp && Time.current <= self.otp_valid_until) rescue false
    end

    def admin_permissions
        return ['all'] if super_admin?
        permissions.map{|p| PERMISSION_CONVERSIONS[p]}
    end

    def validate_permissions
        if permissions.any?{|p| !(PERMISSIONS).include?(p)}
            errors.add(:permissions, "are invalid")
        end
    end

    def remove_empty_permissions
        permissions.reject!(&:empty?)
    end

    protected

    def password_required?
        return false if skip_password_validation
        super
    end
end

