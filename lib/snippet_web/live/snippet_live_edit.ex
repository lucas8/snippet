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
        {:ok, assign(socket, snippet: snippet, show_modal: false)}
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

  def handle_event("share-button-click", _params, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_info({SnippetWeb.LiveComponent.ModalLive, :button_clicked, %{action: "cancel-password"}}, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  # TOOD: Add delete
end
