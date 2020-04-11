defmodule SnippetWeb.PageController do
  use SnippetWeb, :controller

  def index(conn, _params) do
    conn
    |> put_flash(:info, "Hello World!")
    |> put_flash(:error, "Hello World!")
    |> render("index.html")
  end
end
