class Movie < ActiveRecord::Base

  def self.get_ratings
    Movie.all.map {|movie| movie.rating}.uniq
  end
end
