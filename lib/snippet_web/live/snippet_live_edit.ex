defmodule SnippetWeb.SnippetEditLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content
  alias Snippet.Accounts

  # TODO: Add websocket event for deleting snippets
  # TODO: Debounce update to db after typing is finished

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)
    {:ok, socket |> assign(user: user, signed_in?: true, show_modal: false, cursors: [])}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(user: nil, signed_in?: false, show_modal: false, cursors: [])}
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

  def handle_event("move_cursor", cursor, socket) do
    # TODO: Assign color here
    SnippetWeb.Endpoint.broadcast!(
      "snippet:#{socket.assigns.snippet.id}",
      "update_cursor",
      %{body: [cursor | socket.assigns.cursors]}
    )
    {:noreply, socket}
  end

  def handle_event("change_value", value, socket) do
    SnippetWeb.Endpoint.broadcast!(
      "snippet:#{socket.assigns.snippet.id}",
      "updated_snippet",
      %{socket.assigns.snippet | body: value}
    )
    {:noreply, socket}
  end

  def handle_event("name-blur", %{"value" => value}, socket) do
    case Content.update_snippet(socket.assigns.snippet, %{name: value}) do
      {:ok, snippet} ->
        # Send out event
        SnippetWeb.Endpoint.broadcast!(
          "snippet:#{snippet.id}",
          "update_name",
          %{socket.assigns.snippet | name: snippet.name}
        )
        {:noreply, socket
        |> assign(snippet: snippet)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("delete-button-click", _params, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_event("create-snippet", _params, socket) do
    {:noreply, socket
      |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}
  end

  def handle_info(%{event: "update_cursor", payload: %{body: cursors}}, socket) do
    {:noreply, socket |> assign(cursors: cursors)}
  end

  def handle_info(%{event: "update_name", payload: new_snippet}, socket) do
    {:noreply, socket |> assign(snippet: new_snippet)}
  end

  def handle_info(%{event: "updated_snippet", payload: new_snippet}, socket) do
    {:noreply, socket |> assign(snippet: new_snippet)}
  end

  def handle_info(%{event: "delete_snippet"}, socket) do
    {:noreply, socket
      |> put_flash(:info, "Snippet has been deleted")
      |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}
  end

  def handle_info({SnippetWeb.LiveComponent.ModalLive, :button_clicked, %{action: "cancel-delete"}}, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_info({SnippetWeb.LiveComponent.ModalLive, :button_clicked, %{action: "delete-snippet"}}, socket) do
    {:ok, snippet} = Content.delete_snippet(socket.assigns.snippet)

    # Send out delete event to all peer, to redirect to index
    SnippetWeb.Endpoint.broadcast!(
      "snippet:#{socket.assigns.snippet.id}",
      "delete_snippet",
      snippet
    )

    {:noreply, socket
      |> put_flash(:info, "Successfully deleted")
      |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}
  end
end
