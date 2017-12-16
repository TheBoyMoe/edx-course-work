require 'rails_helper'

describe Movie do

	describe "test movie model using fixtures" do
		fixtures :movies

		it "includes rating and year in full name" do
			movie = movies(:milk_movie)
			expect(movie.name_with_rating).to eq('Milk (R)')
		end
	end

end