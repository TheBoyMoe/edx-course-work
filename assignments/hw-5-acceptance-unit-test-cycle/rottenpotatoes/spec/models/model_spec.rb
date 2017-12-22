require 'rails_helper'

describe Movie do

	describe "find movies by the same director" do

		before(:each){
			@movie1 = Movie.create(title: 'Blade Runner', director: 'Ridley Scott')
			@movie2 = Movie.create(title: 'Alien', director: 'Ridley Scott')
			@movie3 = Movie.create(title: 'ET', director: "Steven Speilberg")
			@movies = Movie.find_similar_movies(@movie1.id)
		}

		it "returns similar movies by the same director" do
			expect(@movies.any?{|m| m.director == "Ridley Scott"}).to be true
		end

		it "does not return movies by other directors" do
			expect(@movies.any?{|m| m.director == "Steven Speilberg"}).to be false
		end


	end

end