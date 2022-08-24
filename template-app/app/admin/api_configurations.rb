module ApiConfigurations
end

ActiveAdmin.register BxBlockApiConfiguration::ApiConfiguration, as: 'Api Configuration' do
  menu false
  permit_params :api_key, :api_secret_key, :configuration_type, :ship_rocket_base_url, :ship_rocket_user_email, :ship_rocket_user_password, :application_id, :application_token, :oauth_site_url, :base_url, :client_id, :client_secret, :logistic_api_key
  form do |f|
    render partial: "admin/email_settings/description.html.erb",locals: { title: 'Set up your business - Third-party intergrations', subtitle: 'Add credentials to integrate third-party services (eg Payments, Logistics, SMS).' }

    f.inputs do
      if f.object.new_record?
        f.input :configuration_type, as: :select, collection: BxBlockApiConfiguration::ApiConfiguration.select_configuration_type, include_blank: true, allow_blank: false, :prompt => "Select Type", input_html: {class: 'configuration_type'}
      else
        f.input :configuration_type, as: :select, collection: BxBlockApiConfiguration::ApiConfiguration.select_configuration_type, include_blank: true, allow_blank: false, :prompt => "Select Type", input_html: {class: 'configuration_type', disabled: true}
      end

      f.input :api_key, label: 'Api Key', input_html: { class: 'api_key hide' },
              :hint => content_tag(:a, "Where to find?", href: "https://docs.google.com/document/d/1IXKNBx5xWoS00oy019gW_cPLSfrl7F0JkYsqMU-Mw1k/edit?usp=sharing", target: :blank)
      f.input :api_secret_key, label: 'Secret Api key', input_html: { class: 'api_key hide' },
              :hint => content_tag(:a, "Where to find?", href: "https://docs.google.com/document/d/1IXKNBx5xWoS00oy019gW_cPLSfrl7F0JkYsqMU-Mw1k/edit?usp=sharing", target: :blank)

      f.input :ship_rocket_user_email, label: 'Ship rocket user email', input_html: {class: 'shiprocket_fields hide'}
      f.input :ship_rocket_user_password, label: 'Ship rocket user password', input_html: {class: 'shiprocket_fields hide'}
      f.input :application_id, label: 'bulkgate application id', input_html: {class: 'bulkgate_fields hide'}
      f.input :application_token, label: 'bulkgate application id token', input_html: {class: 'bulkgate_fields hide'}
      f.input :oauth_site_url, input_html: {class: 'logistic_keys hide'}
      f.input :base_url, input_html: {class: 'logistic_keys hide'}
      f.input :client_id, input_html: {class: 'logistic_keys hide'}
      f.input :client_secret, input_html: {class: 'logistic_keys hide'}
      f.input :logistic_api_key, input_html: {class: 'logistic_keys hide'}
    end
    f.actions
  end

  controller do
    def create
      super do
        if resource.valid?
          flash[:notice] = t('messages.success.created', resource: 'Product')
          redirect_to admin_api_configurations_url and return
        else
          flash.now[:error] = resource.errors.full_messages.to_sentence
          render action: 'new' and return
        end
      end
    end
  end

end
