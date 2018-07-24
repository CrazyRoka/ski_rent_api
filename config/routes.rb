Rails.application.routes.draw do
  scope '/api' do
    post 'user_token' => 'user_token#create'
    post 'sign_up'    => 'user#sign_up'
    get  'users/me'   => 'user#me', :defaults => { :format => 'json' }
  end
end
