Undersky::Application.routes.draw do
  get "tags/recent"

  root to: "media#popular", as: :index

  get "about" => "about#index", as: :about

  controller :authorize do
    get "authorize",    as: :authorize
    get "access_token", as: :access_token
    get "logout",       as: :logout
  end

  get "search(/:name)" => "search#search", as: :search

  get "users/feed(/max_id/:max_id)"            => "users#feed",   as: :feed
  get "users/liked(/max_like_id/:max_like_id)" => "users#liked",  as: :liked
  get "users/self"                             => "users#self",   as: :profile
  get "users/:id(/max_id/:max_id)"             => "users#recent", as: :recent

  get "users/:id/follows"     => "relationships#follows",     as: :follows
  get "users/:id/followed_by" => "relationships#followed_by", as: :followed_by

  post   "users/:id/follow" => "relationships#follow",   as: :follow
  delete "users/:id/follow" => "relationships#unfollow", as: :unfollow

  get    "media/:id/likes" => "likes#likes",  as: :likes
  post   "media/:id/likes" => "likes#like",   as: :like
  delete "media/:id/likes" => "likes#unlike", as: :unlike

  get    "media/:id/comments"             => "comments#comments",       as: :comments
  post   "media/:id/comments"             => "comments#create_comment", as: :create_comment
  delete "media/:id/comments/:comment_id" => "comments#delete_comment", as: :delete_comment

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
