# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hangman,
  ecto_repos: [Hangman.Repo]

# Configures the endpoint
config :hangman, HangmanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SUtbtMxk905Yh2V8ZcRf8VIq7XQoRn4Z23cokmghfrSi0YSoMVH5gOOIFVbQN673",
  render_errors: [view: HangmanWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hangman.PubSub,
  live_view: [signing_salt: "kn8qf/cR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
