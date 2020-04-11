defmodule SnippetWeb.PageController do
  use SnippetWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
