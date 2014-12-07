LocalDeals::Application.routes.draw do

  get "jobs/index"
  get '/profile/:id', to: 'my_deals#my_profile'
  root :to => "my_deals#index"
  match '/simple_captcha/:id', :to => 'simple_captcha#show', :as => :simple_captcha

  match ':controller(/:action(/:id(.:format)))'
  match ':controller(/:action(/:id))'
  match ':controller(/:action(/:id(/:arg2)))'
  match ':controller(/:action(/:id(/:arg2(/:arg3))))'
  match ':controller(/:action(/:id(/:arg2(/:arg3(/:arg4)))))'

  match 'au(/:uid)' => 'my_deals#activation'
  match 'fpass(/:pass(/:uid))' => 'my_deals#change_pass'
  match 'change_fbpass(/:pass(/:uid))' => 'my_deals#change_fbpass'
  match 'profile(/:email)' => 'my_deals#my_profile'
  match 'profile(/:pass(.:uid))' => 'my_deals#my_profile'
end
