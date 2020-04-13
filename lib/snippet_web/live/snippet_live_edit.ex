defmodule SnippetWeb.SnippetEditLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content

  # TODO: Add websocket event for deleting snippets
  # TODO: Debounce update to db after typing is finished

  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_modal: false)}
  end

  def handle_params(%{"id" => slug}, _uri, socket) do
    case Content.get_snippet_by_slug(slug) do
      nil ->
        {:noreply, socket
        |> put_flash(:error, "That snippet couldn't be found")
        |> redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))
      }

      snippet ->
        # Subscribe to snippet:id pubsub
        SnippetWeb.Endpoint.subscribe("snippet:#{snippet.id}")
        {:noreply, assign(socket, snippet: snippet)}
    end
  end

  # On keyup for the main textarea
  def handle_event("update_snippet", %{"value" => updated_snippet}, socket) do
    # Broadcast to all but the sending socket aka self()
    SnippetWeb.Endpoint.broadcast!(
      "snippet:#{socket.assigns.snippet.id}",
      "updated_snippet",
      %{socket.assigns.snippet | body: updated_snippet}
    )
    {:noreply, socket}
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

  def handle_event("delete-button-click", _params, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_info(%{event: "updated_snippet", payload: new_snippet}, socket) do
    {:noreply, socket |> assign(snippet: new_snippet)}
  end

  def handle_info({SnippetWeb.LiveComponent.ModalLive, :button_clicked, %{action: "cancel-delete"}}, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_info({SnippetWeb.LiveComponent.ModalLive, :button_clicked, %{action: "delete-snippet"}}, socket) do
    {:ok, _snippet} = Content.delete_snippet(socket.assigns.snippet)
    {:noreply, socket
      |> put_flash(:info, "Successfully deleted")
      |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}
  end
end
