require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
   @letters = generate_grid(10)
  end

  def score
    @guess = params['guess']
    @english = english_word?(@guess)
    @letters = params[:letters].split
    @ingrid = word_in_grid?(@guess, @letters)
  end

  def generate_grid(grid_size)
    grid = []
    counter = 0
    while counter < grid_size.to_i
      grid << ('A'..'Z').to_a.sample
      counter += 1
    end
    grid
  end

  def english_word?(attempt)
    attempt = attempt.gsub("\"", "")
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    url_serialized = open(url).read
    word_lookup = JSON.parse(url_serialized)
    word_lookup['found'] == true
  end

  def word_in_grid?(attempt, grid)
    check_array = []
    grid_dummy = grid.map { |letter| letter }
    attempt_arr = attempt.split('')
    attempt_arr.each do |letter|
      if grid_dummy.include?(letter.upcase)
        grid_dummy.delete_at(grid_dummy.index(letter.upcase))
        check_array << letter
      end
    end
    check_array == attempt_arr
  end


end
