Rails.application.routes.draw do
  get 'currencies/index'
  get 'currencies/history'
  get 'currencies/capture'
  root 'currencies#index'
end
