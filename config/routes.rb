Rails.application.routes.draw do
  root to: 'page#home'
  post '/callback' => 'linebot#callback'
  resources :books

  namespace :api do
    resources :books
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
