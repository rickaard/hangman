defmodule Hangman.HelpersTest do
  use HangmanWeb.ConnCase

  alias Hangman.Helpers

  test "that it returns true if list of correct letters contains all the letters as word variable" do
    assert Helpers.is_correct_word?(["f", "o", "o"], "foo") == true
    assert Helpers.is_correct_word?(["e", "l", "i", "x", "i", "r"], "elixirrrr") == true
  end

  test "that one of the same letter is enough" do
    assert Helpers.is_correct_word?(["f", "o"], "foo") == true
    assert Helpers.is_correct_word?(["p", "i", "z", "a"], "pizza") == true
  end

  test "that it does not matter if letter of word is capitalized" do
    assert Helpers.is_correct_word?(["p", "i", "z", "a"], "Pizza")
    assert Helpers.is_correct_word?(["b", "a", "l"], "baLL")
  end

  test "that order does not matter" do
    assert Helpers.is_correct_word?(["p", "z", "i", "a"], "pizza") == true
  end

  test "that it returns false if list does not contain all the required letters" do
    assert Helpers.is_correct_word?(["f"], "foo") == false
    assert Helpers.is_correct_word?(["p", "z", "a"], "pizza") == false
  end
end
