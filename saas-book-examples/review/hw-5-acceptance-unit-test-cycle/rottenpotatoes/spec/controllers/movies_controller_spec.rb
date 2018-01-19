require 'rails_helper'

describe MoviesController, type: 'controller' do

	context '#search_directors' do
		describe 'movie has a director' do
			# integration test
			it 'responds to the search_directors route' do
				get :search_directors, {id: 1}
				expect(response).to render_template :index
			end
		end
	end

end