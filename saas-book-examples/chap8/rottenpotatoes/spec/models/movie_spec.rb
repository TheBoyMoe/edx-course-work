require 'rails_helper'

describe Movie do

	describe "test movie model using fixtures" do
		fixtures :movies

		it "includes rating and title in full name" do
			movie = movies(:milk_movie)
			expect(movie.name_with_rating).to eq('Milk (R)')
		end
	end

	describe "test movie model using factory_girl" do
		it "includes rating and title in full name" do
			movie = FactoryGirl.build(:movie, title: 'Milk', rating: 'R')
			expect(movie.name_with_rating).to eq('Milk (R)')
		end
	end

	describe "searching Tmdb  by keyword" do

		context "with a valid API key" do
			it "calls Tmdb with title keywords" do
				expect(Tmdb::Movie).to receive(:find).with('Inception')
				Movie.find_in_tmdb('Inception')
			end
		end

		context "with invalid API key" do

			before(:each){
				# stubbing out the call using receive prevents the 'real' Tmdb::Movie.find method being called
				allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
			}

			it "raises an InvalidKeyError" do
				# place the call to find_in_tmdb in {} to prevent the exception raised from stopping the test
				expect {Movie.find_in_tmdb('Inception')}
						.to raise_error(Movie::InvalidKeyError)
			end
		end


	end

end