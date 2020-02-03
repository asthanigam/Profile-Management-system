Rails.application.routes.draw do
   resources :users  
   #resources :admin, only: [:update]
   get 'login', to: 'sessions#new'
   post 'login', to: 'sessions#create'
   get 'welcome', to: 'sessions#welcome'
   root 'sessions#welcome'
   get 'authorized', to: 'sessions#page_requires_login'
   get 'users1/got_profile', to: 'users#got_profile' 
   delete 'sessions/destroy', to: 'sessions#destroy'
   get 'admin', to: 'admin#login'
   post 'admin', to: 'admin#create'
   get 'admin/show', to: 'admin#show' 
   get 'admin/reports', to: 'admin#reports'
   get 'admin/searching', to: 'admin#searching'
   post 'admin/searching', to: 'admin#searching'
   get 'admin/edituser', to: 'admin#edituser'
   patch 'admin/edituser', to: 'admin#update'
   put 'admin/edituser', to: 'admin#update'
   get 'admin/showprofile', to: 'admin#showprofile'
   require 'sidekiq/web'
   mount Sidekiq::Web => '/sidekiq'
   require 'sidekiq/cron/web'
end