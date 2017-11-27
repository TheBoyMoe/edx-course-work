class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError unless letter =~ /[a-z]/i
    letter.downcase!
    if @word.include? letter
      if !@guesses.include? letter
      @guesses << letter
      else
        false
      end
    else
      if !@wrong_guesses.include? letter
      @wrong_guesses << letter
      else
        false
      end
    end
  end

  def word_with_guesses
    matches = @word.chars.map do |l|
      if @guesses.include? l
        l
      else
        '-'
      end
    end
    matches.join
  end

  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
