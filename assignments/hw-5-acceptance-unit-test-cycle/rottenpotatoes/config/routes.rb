Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')

	get '/movies/:id/director/', to: 'movies#search_movies', as: 'search_movies'
end
