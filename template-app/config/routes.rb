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
      resources :brand_settings, only: [:create, :update, :show, :index] do 
        put '/update_store_detail', to: "brand_settings#update_store_detail"
      end
      get '/get_country_by_currency', to:  "brand_settings#get_country_by_currency"
      post '/add_banner', to: "brand_settings#add_banner"
      put '/update_banner', to: "brand_settings#update_banner"
      delete '/destroy_banner', to: "brand_settings#destroy_banner"
      resources :catalogues, only: [:index, :create, :show, :update, :destroy]
      resources :categories, only: [:index, :create, :show, :destroy] do
        collection do
          get :validate_category
          get :validate_sub_category
        end
      end
      resources :help_centers, only: [:create, :update, :show, :index, :destroy]
      resources :interactive_faqs, only: [:create, :update, :show, :index, :destroy] do
        collection do
          put :bulk_update
          post :bulk_create
        end
      end
      resources :customers, except: [:edit, :new]
      resources :orders, only: [:index, :show, :update] do
        get :download_csv_report, on: :collection
        put 'update_delivery_address/:id', to: 'orders#update_delivery_address'
      end
      resources :customer_feedbacks, only: [:index, :create, :update, :show]
      resources :email_settings, only: [:index, :create, :edit, :update, :show, :destroy]
      resource :admin_user, only: [:show, :update] do
        collection do
          get :sub_admin_users
          get :permissions
        end
        member do
          post :create_sub_admin
          get :show_sub_admin
          put :update_sub_admin
          delete :destroy_sub_admin
        end
      end
      resources :variants, only: [:index, :create, :update, :show, :destroy] do
        collection do
          post :bulk_data  
        end
      end
      resources :brands, only: [:index, :create, :update, :show, :destroy]
      resources :payments, only: [:index, :create, :update, :show]
    end
  end

  namespace :bx_block_course do
    resources :courses
  end
  namespace :bx_block_course do
    resources :modulees , only: [:index, :new, :create, :update, :show, :destroy]
   post 'duplicate', to: 'modulees#duplicate'
    # resources :duplicate,to: 'modulees#duplicate', only: [:create] 
  end
end
