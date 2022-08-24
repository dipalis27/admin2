Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  root to: redirect('/admin')
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
  get '500', to: 'application#server_error'
  get '422', to: 'application#server_error'
  get '404', to: 'application#page_not_found'
  get '/onboarding/dismiss', to: 'bx_block_admin/onboarding#dismiss'
  put '/catalogues/toggle_status', to: 'bx_block_admin/catalogues#toggle_status'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :bx_block_admin, path: 'admin' do
    namespace :v1 do
      # write routes for the admin panel here and controllers inside controllers/bx_block_admin/v1
      resource :login, only: [:create]
      resources :onboarding, only: [:index]
      resources :order_reports, only: [:index] do
        get :get_sales_chart_data, on: :collection
      end
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
      resources :catalogues, except: [:new, :edit] do
        collection do
          get :download_sample_csv
          post :upload_csv
        end
      end
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
      resources :bulk_uploads, only: [:index, :create, :destroy, :show]
      resources :orders, only: [:index, :show, :update] do
        get :download_csv_report, on: :collection
        put 'update_delivery_address/:id', to: 'orders#update_delivery_address'
        post :send_to_shiprocket
      end
      resources :customer_feedbacks, only: [:index, :create, :update, :show]
      resources :email_settings, only: [:index, :create, :edit, :update, :show, :destroy]
      resource :admin_user, only: [:show, :update] do
        collection do
          get :sub_admin_users
          get :sub_admin_count
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
      resources :taxes, only: [:index, :create, :edit, :update, :show, :destroy]
      resources :shipping_charges, except: [:new, :edit, :patch]
      resources :zipcodes, except: [:new, :edit, :patch]
      resources :shipping_integrations, except: [:new, :edit, :patch]
      resources :payments, only: [:index, :create, :update, :show] do
        collection do
          get :get_status
        end
      end
      resources :variants, only: [:index, :create, :update, :show, :destroy]
      resources :student_profiles, only: [:index, :create, :show, :update, :destroy]
      resources :subjects, only: [:index, :create, :show, :update, :destroy]
      resources :instructors, only: [:index, :create, :show, :update, :destroy]
      resources :levels, only: [:index, :create, :show, :update, :destroy]
      resources :coupon_codes, except: [:edit, :new]
      resources :locations, only: [] do
        collection do
          get :countries
          get 'countries/:country_id/states', to: 'locations#states'
          get 'states/:state_id/cities', to: 'locations#cities'
        end
      end
      resources :default_email_settings, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :push_notifications, only: [:index, :create, :show, :update, :destroy] do
        member do
          get :send_notification
        end
      end
      resources :app_submission_requirements, only: [:index] do
        collection do
          put :update
        end
      end
      resources :qr_codes, except: [:edit, :new]
      resources :packages
      post :batch_requests, to: 'batch#process_request'
    end
  end
  
  resources :ship_rocket_callbacks, only: [:create]

  namespace :bx_block_course do
    resources :courses
    post 'add_course_students', to: 'courses#add_course_students'
    get 'search_course', to: 'courses#search_course'
  end

  namespace :bx_block_course do
    resources :modulees 
    post 'duplicate', to: 'modulees#duplicate'
    get 'get_quiz_assignment/:id' , to: 'modulees#get_quiz_assignment'
  end

  namespace :bx_block_course do
    resources :lessons
    post 'duplicate_lesson', to: 'lessons#duplicate_lesson'
  end
  
  namespace :bx_block_course do
    resources :assignments
    post 'duplicate_assignment', to: 'assignments#duplicate_assignment'
  end
  
  namespace :bx_block_course do
    resources :quizzes
    post 'duplicate_quiz', to: 'quizzes#duplicate_quiz'
  end
end
