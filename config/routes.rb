Rails.application.routes.draw do
  scope '/api' do
    post 'user_token'   => 'user_token#create'
    post 'sign_up'      => 'user#sign_up'
    post 'users/update' => 'user#update', defaults: { format: 'json' }
    get  'users/me'     => 'user#me', defaults: { format: 'json' }, as: 'user'
  end
end
