Rails.application.routes.draw do
  scope '/api' do
    post 'user_token'   => 'user_token#create'

    post 'sign_up'      => 'user#sign_up'
    patch 'users' => 'user#update', defaults: { format: 'json' }
    get  'users/me'     => 'user#me', defaults: { format: 'json' }, as: 'user'

    # post 'item/update'  => 'item#update', defaults: { format: 'json' }
    # post 'item/destroy' => 'item#destroy', defaults: { format: 'json' }
    # post 'item/create'  => 'item#create', defaults: { format: 'json' }
    # get  'item'         => 'item#item', defaults: { format: 'json' }, as: 'item'
    # get  'items'        => 'item#items', defaults: { format: 'json' }, as: 'items'
    resources :items do
      collection { post :import }
    end
  end
end
