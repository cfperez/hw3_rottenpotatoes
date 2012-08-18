Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  post '/movies/search_tmdb'
  root :to => redirect('/movies')
end
