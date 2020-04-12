defmodule SnippetWeb.SnippetLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content

  def mount(%{"id" => slug}, _session, socket) do
    # {:ok, assign(socket, value: nil, slug: slug)}
    case Content.get_snippet_by_slug(slug) do
      nil ->
        {:ok, socket
        |> put_flash(:error, "That snippet couldn't be found")
        |> redirect(to: Routes.page_path(socket, :show, slug))
      }

      snippet ->
        {:ok, assign(socket, snippet: snippet)}
    end
  end

  def handle_event("field-blur", %{"value" => value}, socket) do
    # This returns the value of the input after it has been unfocused (blur)
    IO.puts(value)
    {:noreply, socket}
  end
end
