Rails.application.routes.draw do

  resources :movies

	root 'movies#index'

  post '/movies/search_tmdb', to: 'movies#search_tmdb'

end
