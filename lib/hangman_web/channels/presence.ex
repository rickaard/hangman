defmodule HangmanWeb.Presence do
  use Phoenix.Presence,
    otp_app: :hangman,
    pubsub_server: Hangman.PubSub

end
