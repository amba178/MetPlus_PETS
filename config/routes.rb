Rails.application.routes.draw do

  devise_for :users, :path_names => {:sign_up => "new", :sign_out => 'logout',
                                     :sign_in => 'login' },
                     :controllers => { :invitations => 'people_invitations' }

  devise_scope :user do
    match  '/login'   => 'devise/sessions#new',        via: 'get'
    match  '/logout'  => 'devise/sessions#destroy',    via: 'delete'
  end

  resources :agencies, path: '/admin/agencies', only: [:edit, :update] do
    resources :branches,      only: [:create, :new]
    resources :agency_people, only: [:create, :new]
  end

  resources :companies

  resources :branches, path: '/admin/branches',
                       only: [:show, :edit, :update, :destroy]

  resources :agency_people, path: '/admin/agency_people',
                       only: [:show, :edit, :update, :destroy]

  # ----------------------- Company Registration ------------------------------

  # Only agency admin can edit, destroy and approve/deny company registration
  resources :company_registrations, path: 'admin/company_registrations',
                                only: [:edit, :update, :destroy, :show] do
    patch 'approve', on: :member, as: :approve
    patch 'deny',    on: :member, as: :deny
  end
  # Any PETS user can create a company registration request
  resources :company_registrations, only: [:new, :create]

  # ----------------------- Company Registration ------------------------------

  # ----------------------- Company -------------------------------------------

  # Company admin (and agency admin) can edit a company
  resources :companies, path: 'company_admin/companies',
                                only: [:edit, :update, :show]

  # Only the agency admin can delete a company
  resources :companies, path: 'admin/companies',
                                only: [:destroy, :list]
  # ----------------------- Company -------------------------------------------

  resources :company_people, only: [:create, :new]

  root 'main#index'

  get 'agency_admin/home', path: '/admin/agency_admin/home'

  get 'agency/home', path: '/agency/:id'

  resources :job_seekers

   # The priority is based upon order of creation: first created -> highest priority.

  # ----------------------- end of customizations ------------------------------
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

=begin
  resources :main
  resources :user do
    collection do
      post 'login'
      get 'login'
      get 'recover'
    end
    member do
      get 'activate' => 'user#activate', as: :activate
    end
    #member do
    #  get 'new'
    #  post 'create'
    #  get 'edit'
    #  get 'show'
    #end
  end
  resources :jobseeker, controller: 'user'
=end
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
