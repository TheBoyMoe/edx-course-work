require 'rails_helper'

describe Movie do

	describe "find movies by the same director" do

		before(:each){
			Movie.create(title: 'Blade Runner', director: 'Ridley Scott')
			Movie.create(title: 'Alien', director: 'Ridley Scott')
		}

		context "when a director is provided" do

			it "returns similar movies when others are found"

		end

		context "when no director is provided" do

			it "raises an error" do

			end

		end
	end

end