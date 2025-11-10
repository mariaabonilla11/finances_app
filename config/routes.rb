Rails.application.routes.draw do
  resources :transactions, only: [:create, :update]

  post '/auth/login', to: 'authentication#login'
  post '/auth/register', to: 'authentication#register'
  post '/auth/logout', to: 'authentication#logout'
  post '/auth/refresh', to: 'authentication#refresh'
  get '/auth/me', to: 'authentication#me'
end

