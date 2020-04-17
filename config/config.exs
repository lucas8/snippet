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
  live_view: [signing_salt: "1gTVA9Wtl647/F87AfbvkwBt4yZVwxHE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
