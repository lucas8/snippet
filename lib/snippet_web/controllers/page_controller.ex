defmodule SnippetWeb.PageController do
  use SnippetWeb, :controller

  alias Snippet.Content

  def index(conn, _params) do
    slug = create_slug_of_length()
    content_params = %{name: "New Code Snippet", author: "Anonymous", slug: slug}


    case Content.create_snippet(content_params) do
      {:ok, snippet} ->
        conn
        |> redirect(to: Routes.page_path(conn, :show, snippet.slug))

      {:error, reason} ->
        inspect reason
        conn
        |> put_flash(:error, "An error has occured while creating a snippet.")
        |> redirect(to: Routes.page_path(conn, :show, 1))
    end
  end

  def show(conn, %{"id" => id}) do
    IO.puts(id)
    render(conn, "index.html")
  end

  def create(conn, _params) do
    conn
    |> redirect(to: Routes.page_path(conn, :show, 1))
  end

  defp create_slug_of_length(length \\ 20) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
