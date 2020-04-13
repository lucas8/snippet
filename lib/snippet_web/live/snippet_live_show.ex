defmodule SnippetWeb.SnippetShowLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => slug}, _uri, socket) do
    case Content.get_snippet_by_slug(slug) do
      nil ->
        {:noreply, socket
        |> put_flash(:error, "That snippet couldn't be found")
        |> redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}

      snippet ->
        {:noreply, assign(socket, snippet: snippet)}
    end
  end
end
