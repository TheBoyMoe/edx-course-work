require 'rails_helper'

# TESTS ONLY PASSING IF THERE IS A search_tmdb template and a Movie.find_in_tmdb method
describe MoviesController do

	describe 'searching TMDb' do

		before(:each){
			# array of fake 'movies'
			@fake_results = [double('movie1'), double('movie2')]
		}

		# each block test one behaviour - tests that '.find_in_tmdb' is called
		it "calls the model method that performs TMDb search" do
			# @movies = Movie.find_in_tmdb(params[:search_terms]) # method you would like to have

			# expect {
			# 	Movie.stub(:find_in_tmdb, @fake_results).with('hardware')
			# }

			# we expect the Movie class to receive the a call to '.find_in_tmdb', with param 'hardware' and return an array of movie objects
			# this fails in the first instance since movie#search_tmdb hasn't called Movie.find_in_tmbd
			expect(Movie).to receive(:find_in_tmdb).with('hardware').and_return(@fake_results)
			# calls the rspec 'post' method, passing the action and the params hash as args
			post :search_tmdb, {search_terms: 'hardware'}
		end

		describe "after valid search" do # assumption tested by the 1st spec

			before(:each) {
				allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
				post :search_tmdb, {search_terms: 'hardware'}
			}

			# tests that the correct view is rendered
			it "selects the Search Results template for rendering" do
				expect(response).to render_template('search_tmdb')
			end

			# tests that the controller action assigns a value to @movies
			it "makes the TMDb search results available to that template" do
				expect(assigns(:movies)).to eq(@fake_results)
			end

		end

	end

end
