defmodule SnippetWeb.Presence do
  use Phoenix.Presence,
    otp_app: :snippet,
    pubsub_server: Snippet.PubSub
end
