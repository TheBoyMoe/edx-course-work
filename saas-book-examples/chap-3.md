## Chapter 3 Code Snippets


* Time regex examples (location 2342)

```ruby
  time_regex = /^\d\d?:\d\d\s*[ap]m$/i
```

* Use parentheses to capture the matched string/sub-string

```ruby
  x = "8:25 PM"
  x =~  /(\d\d?):(\d\d)\s*([ap])m$/i
```

If a match is found the `=~` operator returns the following 'global operators'; `$1 = "8"`, `$2 = "25"`, and `$3 = "P"`. If the match fails, `=~` returns `nil`.

* Every operation is a method call

Even basic operations like '+' and '-' are method calls, the operator is a method call on the receiver.

```ruby
  10 % 3 => 10.modulo(3) => 10.send(:modulo, 3)
  5 + 3  => 5.+(3) => 5.send(:+, 3)
  x == y => x.==(y) => x.send(:==, y)
  x[3] => x.[](3) => x.send(:[], 3)
  x[3] = 'a' => x.[](3, 'a') => x.send(:[]=, 3, 'a')
```

Unlike Java where type casting occurs when adding a float and an integer. In Ruby '+' can be defined differently by each class - it's behaviour depends on the receiver's implementation of the method.
