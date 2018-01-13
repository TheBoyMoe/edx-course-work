Rails.application.routes.draw do
  resources :movies

  root to: redirect('/movies')

  post '/movies/search_tmdb', to: 'movies#search_tmdb'

end
