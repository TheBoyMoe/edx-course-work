# When done, submit this entire file to the autograder.

# Part 1

#Define a method sum(array) that takes an array of
#integers as an argument and returns the sum of its
#elements. For an empty array it should return zero.
#Run associated tests via: $ rspec spec/part1_spec.rb:5
def sum arr
  arr.inject(0,:+)
end
# Define a method max_2_sum(array) which takes an array of
#integers as an argument and returns the sum of its two
#largest elements. For an empty array it should return zero.
#For an array with just one element, it should return that
#element. Run associated tests via: $ rspec spec/part1_spec.rb:23
def max_2_sum arr
  # YOUR CODE HERE
  return 0 if arr.empty?
  return arr[0] if arr.count == 1
  arr.sort!.reverse!
  (arr[0] + arr[1])
end
# Define a method sum_to_n?(array, n) that takes an array
#of integers and an additional integer, n, as arguments and
#returns true if any two elements in the array of integers
#sum to n. sum_to_n?([], n) should return false for any
#value of n, by definition. Run associated tests
#via: $ rspec spec/part1_spec.rb:42
def sum_to_n? arr, n
  return false if arr.empty? || arr.count == 1
  new = arr.combination(2).map { |a,b| a + b }
  new.include?(n)
end

# Part 2

def hello(name)
  # YOUR CODE HERE
  "Hello, #{name}"
end

def starts_with_consonant? s
  # YOUR CODE HERE
  s =~ /^[^aeiouAEIOU\W]/
end

def binary_multiple_of_4? s
  # YOUR CODE HERE
  return false if /[^01]+/.match(s) || s.empty?
  s.to_i(2) % 4 == 0
end

# Part 3

class BookInStock

  def initialize(isbn, price)
    @isbn = valid_isbn(isbn)
    @price = valid_price(price)

  end

  def isbn=(val)
    @isbn = valid_isbn(val)
  end

  def isbn
    @isbn
  end

  def price=(val)
    @price = valid_price(val)
  end

  def price
    @price
  end

  def price_as_string
    "$#{sprintf('%.2f', @price)}"
  end

  private

  def valid_isbn(val)
    if val ==''
      raise ArgumentError, 'No ISBN Number'
    else
      return val
    end
  end

  def valid_price(val)
    if val < 1
      raise ArgumentError, 'Invalid price'
    else
      return val
    end
    # return val unless val < 1 raise ArgumentError, 'Invalid price'
  end

end
