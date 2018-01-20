FactoryGirl.define do

	factory :movie do
		title 'The Empire Strikes Back'
		rating 'PG'
		release_date {20.years.ago}
	end

end