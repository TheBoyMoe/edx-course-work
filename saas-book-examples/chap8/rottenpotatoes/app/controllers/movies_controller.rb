class MoviesController < ApplicationController
  helper_method :sort_direction, :sort_column

  def search_tmdb
    # implementation from chp 7
    # flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
    # redirect_to movies_path

    # calls a model method which performs the search
    @movies = Movie.find_in_tmdb(params[:search_terms])
  end

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
    session[:sort] = params[:sort] unless !params[:sort]
    session[:ratings] = params[:ratings] unless !params[:ratings]

    # filter and sort column
    if session[:sort] && session[:ratings]
      filter_and_sort_column(session[:ratings], session[:sort])
    elsif  session[:ratings]
      filter_items(session[:ratings])
    elsif session[:sort]
      sort_column(session[:sort])
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

  private
    def sort_column(column)
      if column == 'title'
        @movies = Movie.order('title ASC')
        @highlight = 'title'
      elsif column == 'release_date'
        @movies = Movie.order('release_date ASC')
        @highlight = 'release_date'
      end
    end

    def filter_items(ratings)
      @filter_items = ratings.keys
      @movies = Movie.where('rating IN (?)', @filter_items)
    end

    def filter_and_sort_column(ratings, column)
      @filter_items = ratings.keys
      if column == 'title'
        @movies = Movie.where('rating IN (?)', @filter_items).order('title ASC')
        @highlight = 'title'
      elsif column == 'release_date'
        @movies = Movie.where('rating IN (?)', @filter_items).order('release_date ASC')
        @highlight = 'release_date'
      end
    end

end
