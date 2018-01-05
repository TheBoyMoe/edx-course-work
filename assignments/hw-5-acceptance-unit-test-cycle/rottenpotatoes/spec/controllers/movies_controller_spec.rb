require 'rails_helper'

describe MoviesController do

	describe "calls the model method that finds similar movies" do
		before(:each) {
			@movies = [Movie.create(title: 'Blade Runner', director: 'Ridley Scott'),
			Movie.create(title: 'Alien', director: 'Ridley Scott')]
			@movie = @movies[0]
		}


		context "movie has a defined director" do
			before(:each){
				expect(Movie).to receive(:find_similar_movies).with(@movie.id).and_return(@movies)
				get :similar_movies, {id: @movie.id}
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
				expect(Movie).to receive(:find_similar_movies).with(@movie.id)
				get :similar_movies, {id: @movie.id}
			}

			it "redirect user to the movies page" do
				expect(response).to redirect_to movies_path
			end

			it "displays a message to the user: 'Prometheus has no director info'" do
				expect(flash[:notice]).to eq("'#{@movie.title}' has no director info")
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
