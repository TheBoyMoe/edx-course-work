class Movie < ActiveRecord::Base

  class Movie::DirectorNotFound < StandardError; end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_similar_movies(id)

    movie = Movie.find_by(id: id)
    if !movie.director || movie.director.empty?
      raise Movie::DirectorNotFound
    end

    @movies = Movie.where(director: movie.director)

    # [Movie.create(title: 'THX-1138', director: 'George Lucas')]
  end

end
