require 'rails_helper'

describe Movie do


	xdescribe "fictures and factories examples" do

			# when you're testing methods of your model class, it makes since to use the
		# real object in your tests and not use doubles or mocks there's no other classes
		# in this case that need to be mocked out to isolate your tests

		# it "movie attributes" do
		# 	fake_movie = double('Movie')
		# 	allow(fake_movie).to receive(:title).and_return('Casablanca')
		# 	allow(fake_movie).to receive(:rating).and_return('PG')
		# 	expect(fake_movie.name_with_rating).to eq('Casablanca (PG)')
		# end

		fixtures :movies #=> /spec/fixtures/movies.yml
		# when it comes to setting up a movie object - use a fixture
		# however tests now depend on the fixtures state, if a change is made to the
		# fixtures file, e.g number of objects created, tests will fail if they depending
		# upon that value - e.g. tests are no longer independent
		# factories can be used to create obj when needed, so the test does not depend
		# upon any initial state the database may be in
		it "includes rating and year in full name" do
			movie = movies(:milk_movie) # refer to the movie via it's symbolic name
			expect(movie.name_with_rating).to eq 'Milk (R)'
		end

		# another option is to use a factory - creates fully featured obj at testing time
		# using factories maintains test independence, both factories and fixtures
		# create real objects not mocks - when you need a real object use a factory or fixture
		# requires the gem 'factory_girl_rails'
		# 'spec/factories/movie.rb'
		it "includes a rating and a year in full name" do
			# 'build' acts like 'build' in rails - does not save object
			movie = FactoryGirl.build(:movie, title: 'Milk', rating: 'R')
			expect(movie.name_with_rating). to eq 'Milk (R)'
		end

	end

	describe "searching Tmdb by keyword" do

		# happy path
		context 'with a valid API key' do
			it 'calls Tmdb with title keywords' do
				# when we call '.find_in_tmdb' we expect it to call Tmdb::Movie.find with query
				# the 'receive' call intercepts the call, so the real method is not called
				expect(Tmdb::Movie).to receive(:find).with('Inception')
				Movie.find_in_tmdb('Inception')
			end
		end

		# sad path - raise an exception if an invalid or no API key is provided
		# this spec will call the Tmdb service each time it is called - NOT ideal.
		# We can fix this be introducing a seam that isolates the caller from the callee
		context 'with an invalid key' do
			it 'raises an InvalidKeyError' do
				# we know that the call to '.find_in_tmdb' will raise an exception, so
				# encapsulate it within a block otherwise the test will halt.
				# Instead RSpec will catch the exception, an match it to our own
				allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
				expect {Movie.find_in_tmdb('Inception')}.to raise_error(Movie::InvalidKeyError)
			end
		end

	end
end