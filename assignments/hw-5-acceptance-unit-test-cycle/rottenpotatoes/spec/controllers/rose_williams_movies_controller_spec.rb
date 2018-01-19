require 'rails_helper'

describe MoviesController, type: :controller do
	#context 'filtering by director' do
	#  let!(:starwars) {Movie.create title: 'Star Wars', director: 'George Lucas'}
	#  let!(:blade_runner) {Movie.create title: 'Blade Runner', director: 'Ridley Scott'}
	#  it 'excludes movies not by director' do
	#    get :same_director, starwars.id
	#    expect(assigns(:movies)).not_to include 'Blade Runner'
	#  end
	#  it 'includes movies by director' do
	#    get :same_director, @movie1
	#    expect(assigns(:movies)).to include 'Star Wars'
	#  end
	#end
	describe '#same_director' do
		before :each do
			@id1 = '1'
			@id2 = '2'
			@director1 = 'The Unknown Director'
			@director2 = nil
			@movie1 = double('movie1')
			@movie2 = double('movie2', :title => 'Alien')
			@results = [@movie1, @movie2]
		end
		context 'When movie record has a director' do
			describe 'When searching for movie with same director' do
				it 'calls the find method to retrieve the movie' do
					expect(Movie).to receive(:find).with(@id1).and_return(@movie1)
					allow(@movie1).to receive(:director).and_return(@director1)
					allow(@movie1).to receive(:find_with_same_director).and_return(@results)
					get :same_director, :id => @id1
				end
				it 'calls the director getter on the movie' do
					allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
					expect(@movie1).to receive(:director).and_return(@director1)
					allow(@movie1).to receive(:find_with_same_director).and_return(@results)
					get :same_director, :id => @id1
					expect(assigns(:director)).to eq(@director1)
				end
				it 'calls the model method to find similar movies' do
					allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
					allow(@movie1).to receive(:director).and_return(@director1)
					expect(@movie1).to receive(:find_with_same_director).and_return(@results)
					get :same_director, :id => @id1
				end
				it 'selects the Same Director template for rendering' do
					allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
					allow(@movie1).to receive(:director).and_return(@director1)
					allow(@movie1).to receive(:find_with_same_director).and_return(@results)
					get :same_director, :id => @id1
					expect(response).to render_template('same_director')
				end
				it 'makes the results available to the template' do
					allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
					allow(@movie1).to receive(:director).and_return(@director1)
					allow(@movie1).to receive(:find_with_same_director).and_return(@results)
					get :same_director, :id => @id1
					expect(assigns(:movies)).to eq(@results)
				end
			end
		end
		context 'When movie record has no director' do
			describe 'When searching for movie with same director' do
				it 'Checks to see if director has no value' do
					allow_message_expectations_on_nil
					allow(Movie).to receive(:find).with(@id2).and_return(@movie2)
					allow(@movie2).to receive(:director).and_return(@director2)
					expect(@director2).to be_blank
					get :same_director, :id => @id2
					expect(assigns(:director)).to be_nil
				end
				it 'Sets a flash message' do
					allow(Movie).to receive(:find).with(@id2).and_return(@movie2)
					allow(@movie2).to receive(:director).and_return(@director2)
					get :same_director, :id => @id2
					expect(flash[:warning]).to match(/^\'[^']*\' has no director info.$/)
				end
				it 'Redirects to the movies page' do
					allow(Movie).to receive(:find).with(@id2).and_return(@movie2)
					allow(@movie2).to receive(:director).and_return(@director2)
					get :same_director, :id => @id2
					expect(response).to redirect_to(movies_path)
				end
			end
		end
	end
	describe '#show' do
		let(:fid) {'1'}
		let(:movie){ double('movie', :title => 'Alien', :rating => 'R') }
		it 'Calls the .find method to retrieve the movie' do
			expect(Movie).to receive(:find).with(fid).and_return(movie)
			get :show, id: fid
		end
		it 'selects the Show template for rendering' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			get :show, id: fid
			expect(response).to render_template('show')
		end
		it 'makes the movie available to the template' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			get :show, id: fid
			expect(assigns(:movie)).to eq(movie)
		end
	end
	describe '#new' do
		it 'selects the New template for rendering' do
			get :new
			expect(response).to render_template('new')
		end
	end
	describe '#create' do
		let(:params) { {:title => 'Alien'} }
		let(:movie) { double('movie', params) }
		it 'Creates a new movie' do
			expect(Movie).to receive(:create!).with(params).and_return(movie)
			post :create, movie: params
		end
		it 'Sets a flash message' do
			allow(Movie).to receive(:create!).with(params).and_return(movie)
			post :create, movie: params
			expect(flash[:notice]).to match(/^.* was successfully created.$/)
		end
		it 'Redirects to the movies page' do
			allow(Movie).to receive(:create!).with(params).and_return(movie)
			post :create, movie: params
			expect(response).to redirect_to(movies_path)
		end
	end
	describe '#edit' do
		let(:fid) {'1'}
		let(:movie){ double('movie', :title => 'Alien', :rating => 'R') }
		it 'Calls the .find method to retrieve the movie' do
			expect(Movie).to receive(:find).with(fid).and_return(movie)
			get :edit, id: fid
		end
		it 'selects the Edit template for rendering' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			get :edit, id: fid
			expect(response).to render_template('edit')
		end
		it 'makes the movie available to the template' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			get :edit, id: fid
			expect(assigns(:movie)).to eq(movie)
		end
	end
	describe '#update' do
		let(:fid) {'1'}
		let(:params) { {:title => 'Alien'} }
		let(:movie) { double('movie', :title => 'Something Else') }
		let(:updated){ double('movie', :title => 'Alien') }
		it 'Calls the .find method to retrieve the movie' do
			expect(Movie).to receive(:find).with(fid).and_return(movie)
			allow(movie).to receive(:update_attributes!).with(params)
			put :update, id: fid, movie: params
		end
		it 'Updates the movie attributes' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			expect(movie).to receive(:update_attributes!).with(params).and_return(updated)
			put :update, id: fid, movie: params
		end
		it 'Sets a flash message' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			allow(movie).to receive(:update_attributes!).with(params).and_return(updated)
			put :update, id: fid, movie: params
			expect(flash[:notice]).to match(/^.* was successfully updated.$/)
		end
		it 'Redirects to the movies page' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			allow(movie).to receive(:update_attributes!).with(params).and_return(updated)
			put :update, id: fid, movie: params
			expect(response).to redirect_to(movie_path(movie))
		end
	end
	describe '#destroy' do
		let(:fid) {'1'}
		let(:params) { {:title => 'Alien'} }
		let(:movie) { double('movie', :title => 'Alien') }
		it 'Calls the find method to retrieve the movie' do
			expect(Movie).to receive(:find).with(fid).and_return(movie)
			allow(movie).to receive(:destroy)
			get :destroy, :id => fid
		end
		it 'Calls the destroy method to delete the movie' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			expect(movie).to receive(:destroy)
			get :destroy, :id => fid
		end
		it 'Sets the flash message' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			allow(movie).to receive(:destroy)
			get :destroy, :id => fid
			expect(flash[:notice]).to match(/^Movie \'[^']*\' deleted.$/)
		end
		it 'Redirects to the movies page' do
			allow(Movie).to receive(:find).with(fid).and_return(movie)
			allow(movie).to receive(:destroy)
			get :destroy, :id => fid
			expect(response).to redirect_to(movies_path)
		end
	end
end