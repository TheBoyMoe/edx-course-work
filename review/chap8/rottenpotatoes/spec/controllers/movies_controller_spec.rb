require 'rails_helper'

# TESTS ONLY PASSING IF THERE IS A search_tmdb template and a Movie.find_in_tmdb method
describe MoviesController do

	describe 'searching TMDb' do

		before(:each){
			# array of fake 'movies' - do not respond to any of the movie methods
			@fake_results = [double('movie1'), double('movie2')]
		}


		# we expect our controller action, '#search_tmdb' to call the model's class method '.find_in_tmdb' to perform the search
		it "calls the model method that performs TMDb search" do
			# checks that the method '.find_in_tmdb' is called with an argument and returns a value we specify
			# use 'expect' because we're checking that the method 'find_in_tmdb' is called
			# we need to have the expect call before the post, otherwise the real 'find)in_tmdb' will be called
 			expect(Movie).to receive(:find_in_tmdb).with('Alien').and_return(@fake_results)
			post :search_tmdb, {search_terms: 'Alien'}
		end

		describe "after valid search" do # assumption tested by the 1st spec
			before(:each){
				# stub out the call to '.find_in_tmdb' so as to isolate the behaviour we're testing from other classes
				allow(Movie).to receive(:find_in_tmdb).with('Alien').and_return(@fake_results)
				# use rspec's 'post' method, 1st arg is the action, 2nd is a hash, becomes params hash
				post :search_tmdb, {search_terms: 'Alien'}
			}

			# verify that the controller renders the view
			it "selects the Search Results template for rendering" do
				# we can expect the response returned by the controller action to to have rendered the view
				# 'allow' establishes that 'find_in_tmdb' may be called, but doesn't
				# establish the expectation that it will be called - we're just checking that the view is rendered
				# each example should test a single behaviour
				expect(response).to render_template('search_tmdb')
			end

			it "makes the TMDb search results available to that template" do
				# verify that the controller action correctly sets up the instance
				# variable made available to the view
				# 'assigns' RSpec method keeps track of what instance variables
				# are assigned in a controller action
				# checks that value returned by 'find_in_tmdb' is assigned to 'movies' instance variable
				# that value can be anything, the value is not checked - we can assign any value to @fake_results
				expect(assigns(:movies)).to eq(@fake_results)
			end

		end

	end

end
