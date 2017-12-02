class MoviesController < ApplicationController
  helper_method :sort_direction, :sort_column

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @filter_items = %w[G PG PG-13 R]
    @movies = Movie.all
    @all_ratings = Movie.get_ratings

    # filter movie list
    if params[:ratings]
      @filter_items = params[:ratings].keys
      @movies = Movie.where('rating IN (?)', @filter_items)
    end

    # order 'title' & 'release_date' columns
    if params[:sort] == 'title'
      @movies = Movie.order('title ASC')
      @highlight = 'title'
    elsif params[:sort] == 'release_date'
      @movies = Movie.order('release_date ASC')
      @highlight = 'release_date'
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
