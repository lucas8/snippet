defmodule SnippetWeb.PageController do
  use SnippetWeb, :controller

  alias Snippet.Content

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def edit(conn, %{"id" => slug}) do
    case Content.get_snippet_by_slug(slug) do
      nil ->
        conn
        |> put_flash(:error, "That snippet couldn't be found")
        |> redirect(to: Routes.page_path(conn, :index))

      snippet ->
        render(conn, "edit.html", snippet: snippet)
    end
  end

  def show(conn, %{"id" => slug}) do
    case Content.get_snippet_by_slug(slug) do
      nil ->
        conn
        |> put_flash(:error, "That snippet couldn't be found")
        |> redirect(to: Routes.page_path(conn, :index))

      snippet ->
        render(conn, "show.html", snippet: snippet)
    end
  end

  def new(conn, _params) do
    slug = create_slug_of_length()
    content_params = %{name: "New Code Snippet", author: "Anonymous", slug: slug}

    case Content.create_snippet(content_params) do
      {:ok, snippet} ->
        conn
        |> redirect(to: Routes.page_path(conn, :edit, snippet.slug))

      {:error, reason} ->
        inspect reason
        conn
        |> put_flash(:error, "An error has occured while creating a snippet.")
        |> redirect(to: Routes.page_path(conn, :show, 1))
    end
  end

  defp create_slug_of_length(length \\ 20) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
