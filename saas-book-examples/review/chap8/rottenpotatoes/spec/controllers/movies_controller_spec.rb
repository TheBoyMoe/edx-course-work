require 'rails_helper'

# TESTS ONLY PASSING IF THERE IS A search_tmdb template and a Movie.find_in_tmdb method
describe MoviesController do

	describe 'searching TMDb' do

		before(:each){
			# array of fake 'movies' - do not respond to any of the movie methods
			@fake_results = [double('movie1'), double('movie2')]
		}

		it "calls the model method that performs TMDb search"

		describe "after valid search" do # assumption tested by the 1st spec

			it "selects the Search Results template for rendering"

			it "makes the TMDb search results available to that template"

		end

	end

end
