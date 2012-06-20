TDF::Application.routes.draw do

  resources :stages, :only => [:index, :show, :edit, :update]
  resources :players do
    member do
      get :pick
    end
  end
  resources :riders do
    member do
      put :toggle
    end
  end
  resources :score

  root :to => 'summary#index'

end
