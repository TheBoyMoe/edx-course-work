## Agile Development & Behaviour Driven Design(BDD)

An agile lifecycle starts with BDD - the goal of which is to 'build the right thing'(validation - rather than verification - 'build the thing right).
 - requirements are written as features, each feature is written as a 'user story'
 - the user story describes how the app/feature is expected behaviour (intended use) - 'Acceptance testing'
 - BDD is closely tied to Test Driven Development(TDD) - tests the actual implementation - 'Unit testing'
 - each user story describes the feature in non-technical terms, should be small enough to implement in one iteration and have business value. 
 
 ```text
	Feature: search for movies by director
  
    As a movie buff
    So that I can find movies with my favorite director
    I want to include and search on director information in movies I enter
``` 

The story should identify the stakeholder(customer, developer, manager), the goal to be achieved and task to be performed:

```text
	Feature name
		As a [kind of stakeholder],
		So that [I can achieve some goal],
		I want to [do some task]
```

Note:
	- each user story is rated in advance, 1pt for straight forward, 2pt for medium, and 3pt for complex. The average number of points a team completes in an iteration is the 'velocity'. Since this is based on self-evaluation, use velocity to determine the number of iterations to delever the project.
	- 'backlog' the stories not yet completed in this iteration, in priority order
	- 'current' stories currently working on
	- 'icebox' unprioritised stories 'on ice'
	- 'spike' short investigation into a technique/problem to determine the approach to follow when building the feature - this code should be thrown away.
	- 'epic' collection of user stories 
	
A user story should follow the SMART acronym
	- Specific - e.g. search for a movie title, instead of a movie
	- Measurable - known, expected result
	- Achievable - can be implemented in one agile iteration
	- Relevant - have business value to one or more stakeholders
	- Timeboxed - stop developing the story once the alloted time has passed
	

Part of the BDD process is to propose sketches of the UI to match the user stories, e.g. sketch of the different screens a user would see in adding a movie to create a 'story board'. This is a quick and easy way to capture the interaction between the different pages depending on what the user does.


### Cucumber

Use Cucumber (together with Capybara and RSpec) testing frameworks to turn user stories into:
 'acceptance tests' - ensure customer gets what they want, and
 'integration tests' - ensure different modules of the app communicate/work together.
They also provide a series of 'regression' tests - helping to maintain the code as it evolves. 

BDD and cucumber are used to test behaviour and correspond to acceptance & integration tests. Use TDD to test implementation. 
 
Capybara simulates the user interacting with the page, Rspec provides the tests and matchers.
 
In cucumber each user story refers to a single feature, with one or more 'scenarios' - each scenario describing how the feature can be used - 'happy' and 'sad' paths. Scenarios test the entire path through the app. Each scenario is in turn composed of between 3 to 8 steps. Each step stating with a keyword, 'Given', 'Then', 'When', 'And' and 'But'.
	- Given - sets up some precondition, sets the current state, e.g. user is on a particular page
	- When - a particular event/action occurs, e.g. user clicks on a link/button
	- Then - the expected result, check if some condition is true, e.g a articular page is displayed
	- And and But - allows more complicated scenarios to be described
	
Use the 'Background' keyword to indicate steps that should be run before any scenario is executed 	

	
```text
Feature: User can add movie by searching for it in The Movie Database (TMDb)

  As a movie fan
  So that I can add new movies without manual tedium
  I want to add movies by looking up their details in TMDb

	Background: Start from the Search form on the home page

		Given I am on the RottenPotatoes home page
		Then I should see "Search TMDb for a movie"
  
	Scenario: Try to add nonexistent movie (sad path)

		When I fill in "Search Terms" with "Movie That Does Not Exist"
		And I press "Search TMDb"
		Then I should be on the RottenPotatoes home page
		And I should see "'Movie That Does Not Exist' was not found in TMDb."
```


These steps are each tested by 'step definition' files - cucumber uses regex to match the text of a step to the matching test in the step definition file. The steps in the scenario are akin to method calls, and the steps in the step definition files are like the method definition.

Falling tests are red, all tests after a failing test sre blue - indicating that they've not been run. Green indicates passing tests, yellow are tests that have not yet been implemented.


#### Defining a feature

1. define the feature

Feature: Describe the purpose of the feature

  In order ....
  As a .....
  I want ....

2. define one or more cucumber scenarios

Define some specific behaviour to define our feature - through creating one or more scenarios. There are 3 parts to each scenario - GIVEN, THEN and WHEN.
GIVEN - sets up some precondition
WHEN - typically involve simulating the user interacting with the app, e/g, clicking a button, filling in a field.
THEN - usually checks to see if a condition is true
AND - used to extend any WHEN or THEN step to create more complex scenarios

3. run 'cucumber' from the command line

4. define your steps in the steps_definitions file to get them all passing
    - define you steps using regex - allows cucumber to parse your scenarios and call the matching step 

e.g.

Feature: Manage Articles

  In order to make a blog
  As an author
  I want to create and manage articles

  Scenario: Articles List
    Given I have articles titled 'Pizza and Breadsticks'
    When I go to the list of articles
    Then I should see 'Pizza'
    And I should see 'Breadsticks'
 
 
