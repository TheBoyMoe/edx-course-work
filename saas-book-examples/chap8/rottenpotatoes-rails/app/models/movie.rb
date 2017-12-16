class Movie < ActiveRecord::Base

  # define our own exception
  class Movie::InvalidKeyError < StandardError; end

  def self.get_ratings
    Movie.all.map {|movie| movie.rating}.uniq
  end

  def self.find_in_tmdb(search_term)
    # call the api - requires logic to raise an exception should an invalid api key be supplied
    begin
      Tmdb::Movie.find(search_term)
    rescue Tmdb::InvalidApiKeyError
       raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end

  def name_with_rating
    "#{title} (#{rating})"
  end

end
