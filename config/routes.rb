Rails.application.routes.draw do

  root to: 'pages#new'

  get '/overview', :to => "static#overview"
end
