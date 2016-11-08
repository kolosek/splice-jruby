Rails.application.routes.draw do
  root :to => "static#index"

  resources :benchmarks do
    collection do
      get :method_create
      get :method_update
      get :method_where
      get :method_limit
    end
  end
end
