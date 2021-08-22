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
    correct_guesses_list = Enum.uniq(correct_guesses_list) |> Enum.sort()
    correct_word = word |> String.downcase() |> String.graphemes() |> Enum.uniq() |> Enum.sort()

    case correct_guesses_list == correct_word do
      true -> true
      false -> false
    end
  end

  def get_alphabet() do
    ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
  end

  def generate_random_code(code_length) do
    charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    |> String.split("", trim: true)

    1..code_length
    |> Enum.map(fn _item -> Enum.random(charset) end)
    |> Enum.join
  end

end
