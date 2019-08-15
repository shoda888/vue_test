Rails.application.routes.draw do
  root to: 'page#home'
  post '/callback' => 'linebot#callback'
  get '/call' => 'linebot#call'
  get '/push' => 'linebot#push'
  get '/push_family' => 'linebot#push_family'
  resources :books

  namespace :api do
    resources :books
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
