Rails.application.routes.draw do
  root 'homes#index'

  devise_for :users,
             controllers: {
               confirmations: 'account/confirmations',
               emails: 'welcome/registrations',
               passwords: 'account/passwords',
               sessions: 'account/sessions',
             },
             path: 'account',
             skip: [:registration]

  authenticate(:user, ->(user) { user.is_admin? }) do
    mount GoodJob::Engine => 'good_job'
  end

  get '/account', to: redirect('/account/reminders')
  namespace :account do
    resources :reminders, path_names: { edit: '' }
    devise_scope :user do
      resource :settings, only: [:edit, :update], path_names: { edit: '' }
    end
    resource :upgrade, only: [:show, :update]
  end

  namespace :welcome do
    resource :feed, only: [:new, :create], path: '', path_names: { new: '' }
    resource :name, only: [:edit, :update], path_names: { edit: '' }
    resource :account, only: [:edit, :update], path_names: { edit: '' }
    resource :confirm, only: :show
    resource :done, only: :show
  end

  resources :reminders, except: %i[index], param: :id_token do
    scope module: :reminders do
      resource :confirmation, only: %i[show]
    end
  end

  resource :mailgun_webhook, only: %i[create]
  resource :mandrill_webhook, only: %i[show create]

  unless Rails.env.production?
    resources :screenshots
  end

  get '/blog(/*blog_title)', to: redirect('/')
  get '/signup', to: redirect('/')
  get '/stats', to: redirect('/')
end
