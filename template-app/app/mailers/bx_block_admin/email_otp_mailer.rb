module BxBlockAdmin
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      @admin_user = params[:admin_user]
      @otp = @admin_user.otp_code
      mail(to: @admin_user.email, subject: 'Your OTP code')
    end
  end
end
