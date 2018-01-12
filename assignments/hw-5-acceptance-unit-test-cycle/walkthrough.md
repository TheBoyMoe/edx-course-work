Let's clone our repo:

```
git clone https://github.com/saasbook/hw-acceptance-unit-test-cycle
```
and get into the directory

```
cd hw-acceptance-unit-test-cycle
```

We install the gems:

```
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ bundle
Fetching gem metadata from https://rubygems.org/..........
Fetching version metadata from https://rubygems.org/..
Fetching dependency metadata from https://rubygems.org/.
Using rake 11.2.2
Using ZenTest 4.11.0
Using i18n 0.7.0
Using json 1.8.3
Using minitest 5.9.0
Using thread_safe 0.3.5
Using builder 3.2.2
....
Installing rspec-rails 3.3.2
Using rails 4.2.6
Fetching sass-rails 5.0.5
Installing sass-rails 5.0.5
Using cucumber-rails-training-wheels 1.0.0
Bundle complete! 16 Gemfile dependencies, 69 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
````

then run the migrations:

```
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ rake db:migrate RAILS_ENV=test
[DEPRECATION] `last_comment` is deprecated.  Please use `last_description` instead.
== 20111119180638 CreateMovies: migrating =====================================
-- create_table(:movies)
DEPRECATION WARNING: `#timestamps` was called without specifying an option for `null`. In Rails 5, this behavior will change to `null: false`. You should manually specify `null: true` to prevent the behavior of your existing migrations from changing. (called from block in up at /home/ubuntu/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes/db/migrate/20111119180638_create_movies.rb:10)
   -> 0.0010s
== 20111119180638 CreateMovies: migrated (0.0011s) ============================
```

then run the cuke and rspec related things:

```
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ rails generate cucumber:install capybara

   identical  config/cucumber.yml
   identical  script/cucumber
       chmod  script/cucumber
      create  features/step_definitions
      create  features/step_definitions/.gitkeep
      create  features/support
      create  features/support/env.rb
       exist  lib/tasks
      create  lib/tasks/cucumber.rake
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ rails generate cucumber_rails_training_wheels:install
       exist  features/step_definitions
      create  features/step_definitions/web_steps.rb
       exist  features/support
      create  features/support/paths.rb
      create  features/support/selectors.rb
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ rails generate rspec:install      
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb
```

add the appropriate code to `features/support/rspec.rb`

```
require 'rspec/core'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
```

then rspec and cucumber should run as follows:

```
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ rspec
No examples found.


Finished in 0.0004 seconds (files took 0.14815 seconds to load)
0 examples, 0 failures

c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ cucumber
Using the default profile...
0 scenarios
0 steps
0m0.000s
```

Part 1

```sh
$ rails g migration add_director_to_movies director:string
      invoke  active_record
      create    db/migrate/20171127154440_add_director_to_movies.rb
```

this gives us a migration file:

```rb
class AddDirectorToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :director, :string
  end
end
```

which we can apply to the test database:

```sh
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (walkthrough) $ rake db:migrate RAILS_ENV=test[DEPRECATION] `last_comment` is deprecated.  Please use `last_description` instead.
== 20171127154440 AddDirectorToMovies: migrating ==============================
-- add_column(:movies, :director, :string)
   -> 0.0011s
== 20171127154440 AddDirectorToMovies: migrated (0.0012s) =====================
```

The deprecation warning can be ignored, and we add the director attribute to the whitelist of params in movies_controller.rb

```rb
class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
```

---> pastebin

Then we can run the cucumber tests:

```sh
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (walkthrough) $ cucumber
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and serach on director information in movies I enter

  Background: movies in database      # features/search_for_movie_by_director.feature:7
    Given the following movies exist: # features/search_for_movie_by_director.feature:9
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |
      Undefined step: "the following movies exist:" (Cucumber::Undefined)
      features/search_for_movie_by_director.feature:9:in `Given the following movies exist:'

  Scenario: add director to existing movie                # features/search_for_movie_by_director.feature:16
    When I go to the edit page for "Alien"                # features/step_definitions/web_steps.rb:48
    And I fill in "Director" with "Ridley Scott"          # features/step_definitions/web_steps.rb:60
    And I press "Update Movie Info"                       # features/step_definitions/web_steps.rb:52
    Then the director of "Alien" should be "Ridley Scott" # features/search_for_movie_by_director.feature:20
      Undefined step: "the director of "Alien" should be "Ridley Scott"" (Cucumber::Undefined)
      features/search_for_movie_by_director.feature:20:in `Then the director of "Alien" should be "Ridley Scott"'

  Scenario: find movie with same director                       # features/search_for_movie_by_director.feature:22
    Given I am on the details page for "Star Wars"              # features/step_definitions/web_steps.rb:44
    When I follow "Find Movies With Same Director"              # features/step_definitions/web_steps.rb:56
    Then I should be on the Similar Movies page for "Star Wars" # features/step_definitions/web_steps.rb:230
    And I should see "THX-1138"                                 # features/step_definitions/web_steps.rb:105
    But I should not see "Blade Runner"                         # features/step_definitions/web_steps.rb:123

  Scenario: can't find similar movies if we don't know director (sad path) # features/search_for_movie_by_director.feature:29
    Given I am on the details page for "Alien"                             # features/step_definitions/web_steps.rb:44
    Then I should not see "Ridley Scott"                                   # features/step_definitions/web_steps.rb:123
    When I follow "Find Movies With Same Director"                         # features/step_definitions/web_steps.rb:56
    Then I should be on the home page                                      # features/step_definitions/web_steps.rb:230
    And I should see "'Alien' has no director info"                        # features/step_definitions/web_steps.rb:105

3 scenarios (3 undefined)
17 steps (13 skipped, 4 undefined)
0m0.019s

You can implement step definitions for undefined steps with these snippets:

Given(/^the following movies exist:$/) do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end
```

We'll need step defs like so:

```rb
Given(/^the following movies exist:$/) do |table|
  table.hashes.each do |movie|
    Movie.create movie
  end
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |movie_title, director|
  movie = Movie.find_by title: movie_title
  expect(movie.director).to eq director
end
```

Then we see errors relating to not having the necessary paths set up

```
c9testaduror:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (walkthrough) $ cucumberUsing the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and serach on director information in movies I enter

  Background: movies in database      # features/search_for_movie_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: add director to existing movie                # features/search_for_movie_by_director.feature:16
    When I go to the edit page for "Alien"                # features/step_definitions/web_steps.rb:48
      Can't find mapping from "the edit page for "Alien"" to a path.
      Now, go and add a mapping in /home/ubuntu/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes/features/support/paths.rb (RuntimeError)
      ./features/support/paths.rb:31:in `rescue in path_to'
      ./features/support/paths.rb:26:in `path_to'
      ./features/step_definitions/web_steps.rb:49:in `/^(?:|I )go to (.+)$/'
      features/search_for_movie_by_director.feature:17:in `When I go to the edit page for "Alien"'
    And I fill in "Director" with "Ridley Scott"          # features/step_definitions/web_steps.rb:60
    And I press "Update Movie Info"                       # features/step_definitions/web_steps.rb:52
    Then the director of "Alien" should be "Ridley Scott" # features/step_definitions/movie_steps.rb:7

  Scenario: find movie with same director                       # features/search_for_movie_by_director.feature:22
    Given I am on the details page for "Star Wars"              # features/step_definitions/web_steps.rb:44
      Can't find mapping from "the details page for "Star Wars"" to a path.
      Now, go and add a mapping in /home/ubuntu/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes/features/support/paths.rb (RuntimeError)
      ./features/support/paths.rb:31:in `rescue in path_to'
      ./features/support/paths.rb:26:in `path_to'
      ./features/step_definitions/web_steps.rb:45:in `/^(?:|I )am on (.+)$/'
      features/search_for_movie_by_director.feature:23:in `Given I am on the details page for "Star Wars"'
    When I follow "Find Movies With Same Director"              # features/step_definitions/web_steps.rb:56
    Then I should be on the Similar Movies page for "Star Wars" # features/step_definitions/web_steps.rb:230
    And I should see "THX-1138"                                 # features/step_definitions/web_steps.rb:105
    But I should not see "Blade Runner"                         # features/step_definitions/web_steps.rb:123

  Scenario: can't find similar movies if we don't know director (sad path) # features/search_for_movie_by_director.feature:29
    Given I am on the details page for "Alien"                             # features/step_definitions/web_steps.rb:44
      Can't find mapping from "the details page for "Alien"" to a path.
      Now, go and add a mapping in /home/ubuntu/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes/features/support/paths.rb (RuntimeError)
      ./features/support/paths.rb:31:in `rescue in path_to'
      ./features/support/paths.rb:26:in `path_to'
      ./features/step_definitions/web_steps.rb:45:in `/^(?:|I )am on (.+)$/'
      features/search_for_movie_by_director.feature:30:in `Given I am on the details page for "Alien"'
    Then I should not see "Ridley Scott"                                   # features/step_definitions/web_steps.rb:123
    When I follow "Find Movies With Same Director"                         # features/step_definitions/web_steps.rb:56
    Then I should be on the home page                                      # features/step_definitions/web_steps.rb:230
    And I should see "'Alien' has no director info"                        # features/step_definitions/web_steps.rb:105

Failing Scenarios:
cucumber features/search_for_movie_by_director.feature:16 # Scenario: add director to existing movie
cucumber features/search_for_movie_by_director.feature:22 # Scenario: find movie with same director
cucumber features/search_for_movie_by_director.feature:29 # Scenario: can't find similar movies if we don't know director (sad path)

3 scenarios (3 failed)
17 steps (3 failed, 11 skipped, 3 passed)
0m0.065s
```

Focusing on the first failing test we see we need to add a mapping to `features/support/paths.rb`:

```
    when /^the edit page for "(.*)"$/i # I go to the edit page for "Alien"
        edit_movie_path(Movie.find_by_title($1))

```

and the error changes to the following:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec cucumber features/search_by_director.feature:16
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and search on director information in movies I ente

  Background: movies in database      # features/search_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: add director to existing movie                # features/search_by_director.feature:16
    When I go to the edit page for "Alien"                # features/step_definitions/web_steps.rb:48
    And I fill in "Director" with "Ridley Scott"          # features/step_definitions/web_steps.rb:60
      Unable to find field "Director" (Capybara::ElementNotFound)
      ./features/step_definitions/web_steps.rb:61:in `/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/'
      features/search_by_director.feature:18:in `And I fill in "Director" with "Ridley Scott"'
    And I press "Update Movie Info"                       # features/step_definitions/web_steps.rb:52
    Then the director of "Alien" should be "Ridley Scott" # features/step_definitions/movie_steps.rb:7

Failing Scenarios:
cucumber features/search_by_director.feature:16 # Scenario: add director to existing movie

1 scenario (1 failed)
5 steps (1 failed, 2 skipped, 2 passed)
0m0.282s
```

Which indicates we should edit `app/views/movies/edit.html.haml` to add a director field to the movie form

```
  = label :movie, :director, 'Director'
  = text_field :movie, 'director'
``` 

And then the first test should pass:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec cucumber features/search_by_director.feature:16
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and search on director information in movies I ente

  Background: movies in database      # features/search_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: add director to existing movie                # features/search_by_director.feature:16
    When I go to the edit page for "Alien"                # features/step_definitions/web_steps.rb:48
    And I fill in "Director" with "Ridley Scott"          # features/step_definitions/web_steps.rb:60
    And I press "Update Movie Info"                       # features/step_definitions/web_steps.rb:52
    Then the director of "Alien" should be "Ridley Scott" # features/step_definitions/movie_steps.rb:7

1 scenario (1 passed)
5 steps (5 passed)
0m0.342s
```

then lets focus on the second test

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec cucumber features/search_by_director.feature:22
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and search on director information in movies I ente

  Background: movies in database      # features/search_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: find movie with same director                       # features/search_by_director.feature:22
    Given I am on the details page for "Star Wars"              # features/step_definitions/web_steps.rb:44
      Can't find mapping from "the details page for "Star Wars"" to a path.
      Now, go and add a mapping in /home/ubuntu/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes/features/support/paths.rb (RuntimeError)
      ./features/support/paths.rb:37:in `rescue in path_to'
      ./features/support/paths.rb:32:in `path_to'
      ./features/step_definitions/web_steps.rb:45:in `/^(?:|I )am on (.+)$/'
      features/search_by_director.feature:23:in `Given I am on the details page for "Star Wars"'
    When I follow "Find Movies With Same Director"              # features/step_definitions/web_steps.rb:56
    Then I should be on the Similar Movies page for "Star Wars" # features/step_definitions/web_steps.rb:230
    And I should see "THX-1138"                                 # features/step_definitions/web_steps.rb:105
    But I should not see "Blade Runner"                         # features/step_definitions/web_steps.rb:123

Failing Scenarios:
cucumber features/search_by_director.feature:22 # Scenario: find movie with same director

1 scenario (1 failed)
6 steps (1 failed, 4 skipped, 1 passed)
0m0.034s
```

Where we need to make another paths.rb update:

```
    when /^the details page for "(.*)"$/i  # I am on the details page for "Star Wars"
        movie_path(Movie.find_by_title($1))
```

which causes the error to change to:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec cucumber features/search_by_director.feature:22
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and search on director information in movies I ente

  Background: movies in database      # features/search_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: find movie with same director                       # features/search_by_director.feature:22
    Given I am on the details page for "Star Wars"              # features/step_definitions/web_steps.rb:44
    When I follow "Find Movies With Same Director"              # features/step_definitions/web_steps.rb:56
      Unable to find link "Find Movies With Same Director" (Capybara::ElementNotFound)
      ./features/step_definitions/web_steps.rb:57:in `/^(?:|I )follow "([^"]*)"$/'
      features/search_by_director.feature:24:in `When I follow "Find Movies With Same Director"'
    Then I should be on the Similar Movies page for "Star Wars" # features/step_definitions/web_steps.rb:230
    And I should see "THX-1138"                                 # features/step_definitions/web_steps.rb:105
    But I should not see "Blade Runner"                         # features/step_definitions/web_steps.rb:123

Failing Scenarios:
cucumber features/search_by_director.feature:22 # Scenario: find movie with same director

1 scenario (1 failed)
6 steps (1 failed, 3 skipped, 2 passed)
0m0.343s
```

and this can be fixed by adding a new link to the movie show view:

```
= link_to 'Find Movies With Same Director', search_directors_path(@movie)
```

the `search_directors_path` is undefined so running the tests again gives us this error:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec cucumber features/search_by_director.feature:22
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and search on director information in movies I ente

  Background: movies in database      # features/search_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: find movie with same director                       # features/search_by_director.feature:22
    Given I am on the details page for "Star Wars"              # features/step_definitions/web_steps.rb:44
      undefined method `search_directors_path' for #<#<Class:0x000000067dec08>:0x000000067ef580>
      Did you mean?  search_field_tag (ActionView::Template::Error)
      ./app/views/movies/show.html.haml:20:in `_app_views_movies_show_html_haml__3753938638494382733_36839480'
      ./features/step_definitions/web_steps.rb:45:in `/^(?:|I )am on (.+)$/'
      features/search_by_director.feature:23:in `Given I am on the details page for "Star Wars"'
    When I follow "Find Movies With Same Director"              # features/step_definitions/web_steps.rb:56
    Then I should be on the Similar Movies page for "Star Wars" # features/step_definitions/web_steps.rb:230
    And I should see "THX-1138"                                 # features/step_definitions/web_steps.rb:105
    But I should not see "Blade Runner"                         # features/step_definitions/web_steps.rb:123

Failing Scenarios:
cucumber features/search_by_director.feature:22 # Scenario: find movie with same director

1 scenario (1 failed)
6 steps (1 failed, 4 skipped, 1 passed)
0m0.124s
```

If we were writing routing specs we could drop to a unit test of routing here to match the above acceptance test, but they're not suggested, so we can just implement a route in routes.rb:

```rb
  get '/movies/:id/director', to: 'movies#search_directors', as: 'search_directors'
```

Although personally I would prefer that we supported a more RESTful interface where searches used URLs like:

```
/movies?director=George%20Lucas
```

and we overloaded the index method to support searching, rather than URLs like `/movies/director/:id` and `/movies/:id/director` that look like they are asking to return the director of a particular movie rather than search for movies by the same director, but the instructions do indicate that we should create a new route.  Anyhow, with this route in place we get the following error message:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec cucumber features/search_by_director.feature:22
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and search on director information in movies I ente

  Background: movies in database      # features/search_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: find movie with same director                       # features/search_by_director.feature:22
    Given I am on the details page for "Star Wars"              # features/step_definitions/web_steps.rb:44
    When I follow "Find Movies With Same Director"              # features/step_definitions/web_steps.rb:56
      The action 'search_directors' could not be found for MoviesController (AbstractController::ActionNotFound)
      ./features/step_definitions/web_steps.rb:57:in `/^(?:|I )follow "([^"]*)"$/'
      features/search_by_director.feature:24:in `When I follow "Find Movies With Same Director"'
    Then I should be on the Similar Movies page for "Star Wars" # features/step_definitions/web_steps.rb:230
    And I should see "THX-1138"                                 # features/step_definitions/web_steps.rb:105
    But I should not see "Blade Runner"                         # features/step_definitions/web_steps.rb:123

Failing Scenarios:
cucumber features/search_by_director.feature:22 # Scenario: find movie with same director

1 scenario (1 failed)
6 steps (1 failed, 3 skipped, 2 passed)
0m0.390s
```

Indicating that we don't have the relevant controller method.  It's very tempting here to just add the controller method, but one can stop here and start writing controller tests if one wants to drop from the acceptance level to the integration or unit test level.

If we wanted a really pure unit test that described precisely what we wanted next from the controller we could write one like this:

```rb
require 'rails_helper'

describe MoviesController, type: 'controller' do
  context '#search_directors' do
    describe 'movie has a director' do
      subject { MoviesController.new }
      it { is_expected.to respond_to :search_directors }
      end
    end 
  end    
end
```

which would fail like so:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec rspec spec/controllers/movies_controller_spec.rb 
F

Failures:

  1) MoviesController#search_directors movie has a director should respond to #search_directors
     Failure/Error: it { is_expected.to respond_to :search_directors }
       expected #<MoviesController:0x0000000312fc70 @_action_has_layout=true, @_routes=nil, @_headers={"Content-Type"=>"text/html"}, @_status=200, @_request=nil, @_response=nil> to respond to :search_directors
     # ./spec/controllers/movies_controller_spec.rb:10:in `block (4 levels) in <top (required)>'

Finished in 0.08538 seconds (files took 3.34 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/controllers/movies_controller_spec.rb:10 # MoviesController#search_directors movie has a director should respond to #search_directors
```

but do we really need to unit test to this level of precision?  Another form that is sometimes called a controller spec is the following:

```
require 'rails_helper'

describe MoviesController, type: 'controller' do
  context '#search_directors' do
    describe 'movie has a director' do     
      # integration test (route spec)
      it 'responds to the search_directors route' do
        get :search_directors  
      end
    end 
  end    
end
```

which fails like so:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec rspec spec/controllers/movies_controller_spec.rb 
F

Failures:

  1) MoviesController#search_directors movie has a director responds to the search_directors route
     Failure/Error: get :search_directors
     ActionController::UrlGenerationError:
       No route matches {:action=>"search_directors", :controller=>"movies"}
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_dispatch/journey/formatter.rb:46:in `generate'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_dispatch/routing/route_set.rb:721:in `generate'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_dispatch/routing/route_set.rb:752:in `generate'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_dispatch/routing/route_set.rb:747:in `generate_extras'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_dispatch/routing/route_set.rb:742:in `extra_keys'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_controller/test_case.rb:210:in `assign_parameters'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_controller/test_case.rb:626:in `process'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_controller/test_case.rb:67:in `process'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_controller/test_case.rb:514:in `get'
     # ./spec/controllers/movies_controller_spec.rb:13:in `block (4 levels) in <top (required)>'

Finished in 0.01094 seconds (files took 2.93 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/controllers/movies_controller_spec.rb:12 # MoviesController#search_directors movie has a director responds to the search_directors route
```
but note that this is not a pure unit test of the controller; it's failing because the route does not exist, and so it's clearly exercising the routing code (and hence parts of the rails architecture) before it gets to the controller.  

In order to move forward we need to adjust the test slightly:

```
describe MoviesController, type: 'controller' do
  context '#search_directors' do
    describe 'movie has a director' do     
      # integration test (route spec)
      it 'responds to the search_directors route' do
        get :search_directors, { id: 1 }
      end
    end 
  end    
end
```
which gives us this failure:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec rspec spec/controllers/movies_controller_spec.rb 
F

Failures:

  1) MoviesController#search_directors movie has a director render the index template
     Failure/Error: get :search_directors, { id: 1}
     AbstractController::ActionNotFound:
       The action 'search_directors' could not be found for MoviesController
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/abstract_controller/base.rb:132:in `process'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionview-4.2.6/lib/action_view/rendering.rb:30:in `process'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_controller/test_case.rb:639:in `process'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_controller/test_case.rb:67:in `process'
     # /usr/local/rvm/gems/ruby-2.3.0/gems/actionpack-4.2.6/lib/action_controller/test_case.rb:514:in `get'
     # ./spec/controllers/movies_controller_spec.rb:44:in `block (4 levels) in <top (required)>'

Finished in 0.02394 seconds (files took 3.67 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/controllers/movies_controller_spec.rb:42 # MoviesController#search_directors movie has a director render the index template
```

So let's add the method to the controller

```rb
  def search_directors
  end
```

Now we get a different error:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec rspec spec/controllers/movies_controller_spec.rb 
.F

Failures:

  1) MoviesController#search_directors movie has a director responds to the search_directors route
     Failure/Error: get :search_directors, {id:1}
     ActionView::MissingTemplate:
       Missing template movies/search_directors, application/search_directors with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :haml]}. Searched in:
         * "#<RSpec::Rails::ViewRendering::EmptyTemplatePathSetDecorator:0x00000003af0e30>"
              # ./spec/controllers/movies_controller_spec.rb:14:in `block (4 levels) in <top (required)>'

Finished in 0.05196 seconds (files took 3.23 seconds to load)
2 examples, 1 failure

Failed examples:

rspec ./spec/controllers/movies_controller_spec.rb:12 # MoviesController#search_directors movie has a director responds to the search_directors route

```         

and we'll see the same error if we re-run the acceptance test:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $(prompt_rvm) $ bundle exec cucumber features/search_by_director.feature:22 
Using the default profile...
Feature: search for movies by director
  As a movie buff
  So that I can find movies with my favorite director
  I want to include and search on director information in movies I ente

  Background: movies in database      # features/search_by_director.feature:7
    Given the following movies exist: # features/step_definitions/movie_steps.rb:1
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas | 1977-05-25   |
      | Blade Runner | PG     | Ridley Scott | 1982-06-25   |
      | Alien        | R      |              | 1979-05-25   |
      | THX-1138     | R      | George Lucas | 1971-03-11   |

  Scenario: find movie with same director                       # features/search_by_director.feature:22
    Given I am on the details page for "Star Wars"              # features/step_definitions/web_steps.rb:44
    When I follow "Find Movies With Same Director"              # features/step_definitions/web_steps.rb:56
      Missing template movies/search_directors, application/search_directors with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :haml]}. Searched in:
        * "/home/ubuntu/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes/app/views"
       (ActionView::MissingTemplate)
      ./features/step_definitions/web_steps.rb:57:in `/^(?:|I )follow "([^"]*)"$/'
      features/search_by_director.feature:24:in `When I follow "Find Movies With Same Director"'
    Then I should be on the Similar Movies page for "Star Wars" # features/step_definitions/web_steps.rb:230
    And I should see "THX-1138"                                 # features/step_definitions/web_steps.rb:105
    But I should not see "Blade Runner"                         # features/step_definitions/web_steps.rb:123

Failing Scenarios:
cucumber features/search_by_director.feature:22 # Scenario: find movie with same director

1 scenario (1 failed)
6 steps (1 failed, 3 skipped, 2 passed)
0m0.315s
```

so now we could fix this by just adding a template of the appropriate name, but arguably we should re-use the movies index template and just render that.  We can write a low level test for that:

```
   it 'render the index template' do
     get :search_directors, { id: 1}
     expect(response).to render_template :index
   end
```
