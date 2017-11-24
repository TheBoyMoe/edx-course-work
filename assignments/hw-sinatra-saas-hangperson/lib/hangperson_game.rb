class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses

  # HangpersonGame encapsulates the game logic - the 'M' in 'MVC'

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  # map RESTful actions
  # GET /show => show game state, allow player to enter guess => display correct & wrong guesses so far, may redirect to Win or Lose
  # GET /new => display a form that includes a 'Start' new game button => generate POST /create
  # POST /create => create new game => redirect to '/show'
  # POST /guess => update game state with new guessed letter(provide a form) => redirect to '/show'
  # GET /win => Show 'you win' page with button to start new game
  # GET /lose => Show 'you lose' page with button to start new game


  # A 'GET' can be accomplished by just typing a URL into the browser's address bar.
  # A 'POST' can only happen when the user submits an HTML form (or an AJAX request).

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # processes a guess and modifies the instance variables wrong_guesses and guesses
  def guess(letter)
    # valid_letter(letter).downcase!
    # if !@guesses.include?(letter) && !@wrong_guesses.include?(letter)
    #   @word.include?(letter)? @guesses << letter : @wrong_guesses << letter
    #   return true
    # end
    # return false
    valid_letter(letter).downcase!
    if !@guesses.include?(letter) && !@wrong_guesses.include?(letter)
      if @word.include?(letter)
        @guesses << letter
      else
        @wrong_guesses << letter
      end
      return true
    end
    return false
  end

  # returns one of the symbols :win, :lose, or :play depending on the current game state
  def check_win_or_lose
    return :lose if @wrong_guesses.length >= @word.length
    return :win if @guesses.length >= @word.length
    :play
  end

  # substitutes the correct guesses made so far into the word.
  def word_with_guesses
    # return '-' * @word.length unless @guesses.length > 0
    current = ''
    @word.split('').each do |letter|
      if !@guesses.include? letter
        current += '-'
      else
        @guesses.split('').each do |char|
          if char == letter
            current += char
          end
        end
      end
    end
    current
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  #  retrieves a random word from a Web service
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end


  private
    def valid_letter(letter)
      # if !letter || letter.empty? || /[^a-z]/i =~ letter
      #   raise ArgumentError, 'Invalid letter'
      # else
      #   letter
      # end
      raise ArgumentError, 'Invalid letter' if !letter || letter.empty? || /[^\w]/i =~ letter
      return letter
    end

end
