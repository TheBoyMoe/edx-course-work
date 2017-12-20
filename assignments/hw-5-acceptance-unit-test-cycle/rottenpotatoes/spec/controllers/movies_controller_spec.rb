require 'rails_helper'

describe MoviesController do

	describe "calls the model method that finds similar movies" do
		before(:each) {
			# double('movie1', id: 1, title: 'Blade Runner', director: 'Ridley Scott'),
			# double('movie1', id: 2, title: 'Alien', director: 'Ridley Scott')
			Movie.create(title: 'Blade Runner', director: 'Ridley Scott')
			Movie.create(title: 'Alien', director: 'Ridley Scott')
			@movies = Movie.all.to_a
		}


		context "movie has a defined director" do
			before(:each){
				expect(Movie).to receive(:find_similar_movies).with("1").and_return(@movies)
				get :similar_movies, {id: 1}
			}

			it "selects the similar movies template" do
				expect(response).to render_template('similar_movies')
			end

			it "returns an array of similar movies" do
				expect(assigns(:movies)).to eq(@movies)
			end
		end

		context "movie does not have a director" do
			before(:each){
				@movie = Movie.create(title: 'Prometheus')
				expect(Movie).to receive(:find_similar_movies).with("3").and_return(nil)
				get :similar_movies, {id: @movie.id}
			}

			xit "redirect the user to the home page" do
				expect(response).to render_template('movies/index')
			end

			it "fails to return a match" do
				expect(assigns(:movies)).to eq(nil)
			end

		end

	end

	describe "#create" do
		it "creates a new movie" do
			expect{
				post :create, { movie: {title: 'Alien', director: 'Ridley Scott'}}
			}.to change(Movie, :count).by(1)
		end
	end

	describe "#destroy" do
		it "destroys a movie in the database" do
			movie = Movie.create({title: 'Alien', director: 'Ridley Scott'})
			expect{
				post :destroy, {id: movie.id}
			}.to change(Movie, :count).by(-1)
		end
	end

end
