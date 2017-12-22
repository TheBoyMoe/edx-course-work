class Movie < ActiveRecord::Base

  # class Movie::DirectorNotFound < StandardError; end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_similar_movies(id)
    Movie.where(director: find(id).director)
  end

end
