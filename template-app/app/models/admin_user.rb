class AdminUser < ApplicationRecord
  include AdminPermissions
  include UrlUtilities
  #include SessionInfo

  attr_accessor :skip_password_validation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :admin_profile, class_name: "BxBlockRoleAndPermission::AdminProfile"
  devise :database_authenticatable, :recoverable, :rememberable,
    :trackable, :validatable
  enum role: %i[super_admin store_admin sub_admin]

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
  before_create :track_event, :create_admin_profile

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
        content = content.gsub!("%{#{key}}", "<div><img height='150px' src='#{url_for(default_email_setting.logo)}'/></div>" ) || content
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

  def remove_empty_permissions
    permissions.reject!(&:empty?)
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

  private

  def validate_permissions
    if permissions.any?{|p| !(PERMISSIONS).include?(p)}
      errors.add(:permissions, "are invalid")
    end
  end
end

