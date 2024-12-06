# config/routes.rb
Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users
  resources :posts do
    member do
      patch :approve
      patch :reject
      patch :publish
      patch :request_revision
    end
  end
  # get 'unpublished_posts', to: 'posts#unpublished_posts'
  patch 'posts/:id/submit_for_approval', to: 'posts#submit_for_approval', as: 'submit_for_approval_post'
  get 'manage_posts', to: 'posts#manage', as: 'manage_posts'
end
