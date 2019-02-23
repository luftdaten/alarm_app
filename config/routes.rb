Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  devise_for :admins, ActiveAdmin::Devise.config

  resources :sensors
  resources :notifications
  resources :home do
    get :impressum, :on=>:collection
    get :datenschutz, :on=>:collection
  end

  scope '/v1' do
    resources :api do
      get :sensors_notification_enabled, :on=>:collection
      get :sensors
    end
  end

  resources :community

  mount Thredded::Engine => '/forum'

  # below code to fix the active admin issue when table not exists in database as activeadmin tries to load every model.
  # for reference https://github.com/activeadmin/activeadmin/issues/783
  begin
    ActiveAdmin.routes(self)
  rescue Exception => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end
  root :to => 'sensors#index'

end
