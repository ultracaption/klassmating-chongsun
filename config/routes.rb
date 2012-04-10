KlassmatingChongsun::Application.routes.draw do
  root :to => 'main#turnout'
  match ':slug', :to => 'main#slug'
  match ':controller(/:action(/:id))(.:format)'
end
