defmodule SnippetWeb.SnippetEditLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content

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
        SnippetWeb.Endpoint.subscribe("snippet:#{snippet.id}")
        {:noreply, assign(socket, snippet: snippet)}
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

  def handle_event("delete-button-click", _params, socket) do
    {:noreply, assign(socket, show_modal: true)}
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

  # TOOD: Add delete
end
