class SubdomainConstraint

  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www'
  end
end
Rails.application.routes.draw do

  resources :users
  constraints SubdomainConstraint do
    resources :organizations
  end

  get 'organizations/new' => "organizations#new"
  post 'organizations/new' => "organizations#create"
  get '/organizations/:id' => "organizations#show"
  get '/organizations' => "organizations#index"
  get '/users' => "users#index"
  get '/users/new' => "users#new"
  get '/users/:id' => "users#show"
  post '/users/new' => "users#create"
  root 'organizations#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  post '/updatePhone' => "users#updatePhone"
  post '/moveOrg' => "users#moveOrg"
end