class Movie < ActiveRecord::Base

  def self.get_ratings
    Movie.all.map {|movie| movie.rating}.uniq
  end

  def self.find_in_tmdb(search_term)
    # call the api
  end

  def name_with_rating
    "#{title} (#{rating})"
  end

end
