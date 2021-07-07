Rails.application.routes.draw do

  root to: 'homes#top'
  get 'mypage' => 'users#mypage'
  resources :users, only: [:edit, :update, :destroy] do
    member do
      get :following, :follower
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :photographers do
    member do
      post :public_status_switching
    end
  end
  resources :photos do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end


  #===== deviseルーティング設定 ======
  devise_for :users,
    path: '',
    path_names: {
      sign_up:  '',
      sign_in:  'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      registrations: "users/registrations",
      passwords: "users/passwords",
      sessions: "users/sessions"
    }

end
