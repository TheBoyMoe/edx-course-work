Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
	# root 'movies#index'

	get '/movies/:id/director/', to: 'movies#similar_movies', as: 'similar_movies'
end
