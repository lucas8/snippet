defmodule SnippetWeb.SnippetEditLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content

  def mount(%{"id" => slug}, _session, socket) do
    case Content.get_snippet_by_slug(slug) do
      nil ->
        {:ok, socket
        |> put_flash(:error, "That snippet couldn't be found")
        |> redirect(to: Routes.page_path(socket, :index))
      }

      snippet ->
        {:ok, assign(socket, snippet: snippet)}
    end
  end

  def handle_event("name-blur", %{"value" => value}, socket) do
    case Content.update_snippet(socket.assigns.snippet, %{name: value}) do
      {:ok, snippet} ->
        {:noreply, socket
        |> assign(snippet: snippet)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  # TOOD: Add delete
end
