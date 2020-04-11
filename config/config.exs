# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :snippet,
  ecto_repos: [Snippet.Repo]

# Configures the endpoint
config :snippet, SnippetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tH0Ii1aFgeFXyN5tfnF4Ac7rsLgBDNS8pXkDxyxZaeGokEIRigtRBPgNx95BytVT",
  render_errors: [view: SnippetWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Snippet.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "5DdVSkRF"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
