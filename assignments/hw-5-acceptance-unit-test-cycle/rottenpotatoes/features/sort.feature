Feature: display list of movies sorted by different criteria

  As an avid moviegoer
  So that I can quickly browse movies based on my preferences
  I want to see movies sorted by title or release date

  Background: movies in database

    Given the following movies exist:
      | title        | rating | director     | release_date |
      | Star Wars    | PG     | George Lucas |   1977-05-25 |
      | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
      | Alien        | R      |              |   1979-05-25 |
      | THX-1138     | R      | George Lucas |   1971-03-11 |


  Scenario: sort movies alphabetically
    Given I am on the home page
    When I follow "Movie Title"
    Then I should see "Alien" before "Blade Runner"
    And I should see "Star Wars" before "THX-1138"

  Scenario: sort movies in increasing order of release date
    Given I am on the home page
    When I follow "Release Date"
    Then I should see "THX-1138" before "Star Wars"
    And I should see "Alien" before "Blade Runner"

