# require 'sinatra_api'

Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  # root 'posts#home'
  # mount Sinatra_api::Sina => "/sina" #sinatra api comment out to use it
  root  'api#home'
  post '/api/users'          => 'api#user_create'
  get  '/api/users/:id'      => 'api#user_id'
  get  '/api/userup/:id'     => 'api#user_up_id'
  post '/api/userup'         => 'api#user_up'
  get  '/api/follow/:id'     => 'api#follow_id'
  post '/api/follow'         => 'api#follow_create'
  post '/api/session'        => 'api#signin'
  get  '/api/posts'          => 'api#post_index'
  post '/api/posts'          => 'api#post_create'
  get  '/api/posts/:id'      => 'api#post_id'
  get  '/api/discoverposts'  => 'api#post_discover'
  get  '/api/hiddenposts'    => 'api#hiddenposts'
  get  '/api/blog'           => 'api#blog_index'
  post '/api/comments'       => 'api#comment_create'
  get  '/uptoken'            => 'api#qiniu_token'
  get  '/test'               => 'api#test'
  #changeion
  post '/api/photos'         => 'api#photo_create'
  get  '/api/photos'         => 'api#photo_index'
  get  '/api/partners/:id'   => 'api#partner_id'
  get  '/api/strangers/:id'  => 'api#stranger_id'
  post '/api/asker'          => 'api#asker_create'
  post '/api/agree'          => 'api#agree_create'
  post '/api/unagree'        => 'api#unagree_create'
  ##cafe
  post '/api/cafes'          => 'api#cafe_create'
  get  '/api/cafes'          => 'api#cafe_index'
  get  '/api/cafes/:id'      => 'api#cafe_id'
 ##zv
  post '/api/products'       => 'api#product_create'
  get  '/api/products'       => 'api#product_index'
  get  '/api/products/:id'   => 'api#product_id'
  
  # match '/api/users' ,      => 'api#user_create',     via: 'post'
  # post '/api/users' ,      to: 'api#user_create'
  # scope :po do
  #   resources :users
  # end
  # resources :articles, module: 'admin'
  # scope '/admin' do
  #   resources :articles, :comments
  # end
  # resources :articles, path: '/admin/articles'
  # namespace :api do
  # #  resources :users, :posts, :comments, :session, :follow
  #   resources :tweet
  # end



  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
