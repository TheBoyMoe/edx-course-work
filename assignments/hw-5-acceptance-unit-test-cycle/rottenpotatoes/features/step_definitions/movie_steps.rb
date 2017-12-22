Given(/^the following movies exist:$/) do |table|
	table.hashes.each do |hash|
		Movie.create(hash)
	end
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |movie, director|
	expect(page).to have_content(director)
end

Then /I should see "(.*)" before "(.*)"/ do |arg1, arg2|
	regex = /#{arg1}.*#{arg2}.*/m
	expect(regex.match(page.body)).not_to eq nil
end