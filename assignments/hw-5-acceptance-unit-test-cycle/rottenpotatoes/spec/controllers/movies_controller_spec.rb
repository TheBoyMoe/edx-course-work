require 'rails_helper'

describe MoviesController do

	describe "calls the model method that finds similar movies" do
		before(:each) {
			# double('movie1', id: 1, title: 'Blade Runner', director: 'Ridley Scott'),
			# double('movie1', id: 2, title: 'Alien', director: 'Ridley Scott')
			Movie.create(title: 'Blade Runner', director: 'Ridley Scott')
			Movie.create(title: 'Alien', director: 'Ridley Scott')
			@movies = Movie.all
		}


		context "movie has a defined director" do
			before(:each){
				movie = double('movie3', id: 3, director: 'Ridley Scott')
				allow(Movie).to receive(:find_similar_movies).with(movie.id)
				get :similar_movies_path, {id: movie.id}
			}

			it "it returns an array of similar movies" do
				expect(assigns(:movies)).to eq(@movies)
			end
		end

		context "movie does not have a director" do
			before(:each){
				movie = double('movie3', id: 3, title: 'Prometheus')
				allow(Movie).to receive(:find_similar_movies).with(movie.id)
				get :similar_movies_path, {id: movie.id}
			}

			it "redirect the user to the home page" do
				expect(response).to render_template('index')
			end

			xit "returns a flash message to the user 'no director info'" do
				expect(response.text).to eq("#{movie.title} has no director info")
			end
		end

	end

	xdescribe "#index" do

	end

	xdescribe "#create" do

	end

	xdescribe "#update" do

	end

	xdescribe "#destroy" do

	end

end
