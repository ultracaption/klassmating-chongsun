KlassmatingChongsun::Application.routes.draw do
  root :to => 'main#turnout'
  match 'id', :to => "main#input_district"
  match 'ip', :to => "main#input_party"
  match ':slug', :to => 'main#slug'
  match ':controller(/:action(/:id))(.:format)'
end
