require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    session[:letters] = generate_letters(10)
    @letters = session[:letters]
  end

  def score
    @word = params[:word]
    @letters = session[:letters]
    @score_count = 0

    if letters_included?(@word, @letters)
      if english_word?(@word)
        @score_count += @word.length
        @error = 'est un mot valide !'
      else
        @error = "n'est pas un mot valide."
      end
    else
      @error = ' | Les lettres utilisées ne sont pas incluses dans les lettres disponibles.'
    end
  end

  private

  def generate_letters(num_letters)
    ('A'..'Z').to_a.sample(num_letters)
  end

  def letters_included?(word, letters)
    return false if word.nil? || letters.nil?

    word.upcase.chars.all? { |letter| letters.include?(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
