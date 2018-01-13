## TDD and RSpec

A good test should be FIRST:
	- Fast
	- Independent
	- Repeatable (should not depend upon external factors that can change, e.g. dates)
	- Self-checking (each test should determine on it's own whether it's passed/failed)
	- Timely (tests should be created/updated at the same time the code changes)
	
To keep tests fast and independent use 'mocks/doubles' and 'stubs' (all examples of 'seams')  to isolate the behaviour of the code being tested from other classes or methods.

Validation - tests that you built the right thing (BDD)
Verification - tests that the th ing works, i.e. it's built correctly (TDD)

RSpec is a domain specific language(DSL) focused on the job of testing Ruby code. Although it can be used for both Unit and Integration tests, we'll use it for unit testing (We'll use cucumber for integration tests). We use RSpec to write tests about how our code is expected to behave - tests are written that test the 'code we wish we had'. This forces you to think about how the code will be used by it's 'callers', rather than what it does.

The essence of TDD is to write a list of the desired behaviours, the spec, and use that to drive the creation of the methods and templates.

