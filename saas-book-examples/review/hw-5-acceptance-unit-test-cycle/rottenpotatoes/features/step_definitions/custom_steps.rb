Given(/^the following movies exist:$/) do |table|
	# pass in a table of movie hashes and populate the database table
	table.hashes.each do |movie_hash|
		Movie.create(movie_hash)
	end
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |title, director|
	movie = Movie.find_by(title: title)
	expect(movie.director).to eq director
end
