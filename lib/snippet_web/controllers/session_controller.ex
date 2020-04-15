defmodule SnippetWeb.SessionController do
  use SnippetWeb, :controller
  plug Ueberauth

  def create(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect(auth)

    conn
  end
end
