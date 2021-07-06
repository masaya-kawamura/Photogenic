Rails.application.routes.draw do

  root to: 'homes#top'
  resources :users, only: [:edit, :update, :destroy]
  get 'mypage' => 'users#mypage'
  resources :photographers do
    member do
      post :public_status_switching
    end
  end
  resources :photos


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
