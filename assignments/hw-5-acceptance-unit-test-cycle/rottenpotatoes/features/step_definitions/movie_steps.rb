Given(/^the following movies exist:$/) do |table|
	table.hashes.each do |movie|
		Movie.create(movie)
	end
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
	movie = Movie.find_by(title: arg1)
	movie.director == arg2
end
