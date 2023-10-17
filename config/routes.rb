Rails.application.routes.draw do
  root 'homepage#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/ask', to: 'questions#ask'
  end
end
