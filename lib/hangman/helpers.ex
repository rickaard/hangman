defmodule Hangman.Helpers do
  def random_word() do
    words = [
      "foo",
      "bar",
      "pizza",
      "dog",
      "cat",
      "beer",
      "soccer",
      "weightlifting",
      "ipa",
      "lager",
      "newspaper",
      "elixir",
      "pheonix",
      "react",
      "javascript"
    ]

    Enum.random(words)
  end

  def is_correct_word?(correct_guesses_list, word) do
    # "drackir" |> String.downcase |> String.graphemes |> Enum.uniq |> Enum.sort
    correct_guesses_list = Enum.uniq(correct_guesses_list) |> Enum.sort()
    correct_word = word |> String.downcase() |> String.graphemes() |> Enum.uniq() |> Enum.sort()

    case correct_guesses_list == correct_word do
      true -> true
      false -> false
    end
  end

end
