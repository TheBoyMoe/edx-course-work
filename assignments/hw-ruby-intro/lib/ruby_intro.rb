# When done, submit this entire file to the autograder.

# Part 1

def sum arr
  return 0 if arr.empty?
  sum = 0
  arr.each {|v| sum += v}
  sum
  # arr.inject(0){|sum, val| sum + val}
end

def max_2_sum arr
  return 0 if arr.empty?
  # return arr[0] if arr.count == 1
  return arr[0] unless arr.count > 1
  # arr.sort.last(2).inject(0){|s,v| s + v }
  arr = arr.sort.last(2)
  arr[0] + arr[1]
end

def sum_to_n? arr, n
  # return false if arr.empty? || arr.count == 1
  return false unless arr.count > 1
  i = 1
  while (i < arr.count)
    return true if ((arr[i] + arr[i - 1]) == n)
    i += 1
  end
  return false
end

# Part 2

def hello(name)
  "Hello, #{name}"
end

def starts_with_consonant? s
  /^[^aeiou\W]/i.match(s) != nil
end

def binary_multiple_of_4? s
  return false unless /^[01]+$/.match(s)
  s.to_i(2) % 4 == 0
end

# Part 3

class BookInStock
  attr_accessor :isbn, :price

  def initialize(isbn, price)
    raise ArgumentError unless /\d+/.match(isbn)
    raise ArgumentError unless price > 0
    @isbn = isbn
    @price = price
  end

  def price_as_string
    # format string to 2 decimal places
    "$#{'%.2f' % price}"
  end
end
