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
    @filter_items = []
    if params[:ratings]
      @filter_items = params[:ratings].keys
      @movies = Movie.where('rating IN (?)', @filter_items).order("#{sort_column} #{sort_direction}")
    else 
      @movies = Movie.order("#{sort_column} #{sort_direction}")
    end
    @column = params[:column]
    @all_ratings = Movie.get_ratings
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
    def sortable_columns
      # define sortable columns
      ['title', 'release_date']
    end

    def sort_column
      # sort the selected column, default 'title' where column not specified
      sortable_columns.include?(params[:column])? params[:column] : 'title'
    end

    def sort_direction
      # sort either asc/desc, asc by default
      %w[asc desc].include?(params[:direction])? params[:direction] : 'asc'
    end

end
