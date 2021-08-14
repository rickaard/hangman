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
end
