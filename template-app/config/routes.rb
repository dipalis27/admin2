Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  root to: redirect('/admin')
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
  get '500', to: 'application#server_error'
  get '422', to: 'application#server_error'
  get '404', to: 'application#page_not_found'
  get '/onboarding/dismiss', to: 'bx_block_admin/onboarding#dismiss'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :bx_block_admin, path: 'admin' do
    namespace :v1 do
      # write routes for the admin panel here and controllers inside controllers/bx_block_admin/v1
      resource :login, only: [:create]
      resources :onboarding, only: [:index]
      resources :order_reports, only: [:index]
      resource :forgot_password, only: [:create] do
        collection do
          post :otp_validate
          put :reset_password
        end
      end
      resources :catalogues, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
