defmodule Snippet.Repo do
  use Ecto.Repo,
    otp_app: :snippet,
    adapter: Ecto.Adapters.Postgres
end
