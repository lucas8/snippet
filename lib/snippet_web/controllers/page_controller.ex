defmodule SnippetWeb.PageController do
  use SnippetWeb, :controller

  alias Snippet.Content

  def new(conn, _params) do
    slug = create_slug_of_length()
    content_params = %{name: "New Code Snippet", author: "Anonymous", slug: slug}

    case Content.create_snippet(content_params) do
      {:ok, snippet} ->
        conn
        |> redirect(to: Routes.live_path(conn, SnippetWeb.SnippetEditLive, snippet.slug))

      {:error, reason} ->
        inspect reason
        conn
        |> put_flash(:error, "An error has occured while creating a snippet.")
        |> redirect(to: Routes.live_path(conn, SnippetWeb.SnippetIndexLive))
    end
  end

  defp create_slug_of_length(length \\ 20) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
