class Movie < ActiveRecord::Base

  # define our own exception
  class Movie::InvalidKeyError < StandardError; end

  def self.get_ratings
    Movie.all.map {|movie| movie.rating}.uniq
  end


  def name_with_rating
    "#{title} (#{rating})"
  end

end
