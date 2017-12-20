Given(/^the following movies exist:$/) do |table|
	table.hashes.each do |hash|
		Movie.create(hash)
	end
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
	movie = Movie.find_by(title: arg1)
	movie.director == arg2
end

Then /I should see "(.*)" before "(.*)"/ do |arg1, arg2|
	regex = /#{arg1}.*#{arg2}.*/m
	expect(regex.match(page.body)).not_to eq nil
end