defmodule SnippetWeb.SnippetShowLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content
  alias Snippet.Accounts

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)
    {:ok, socket |> assign(user: user, signed_in?: true)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(user: nil, signed_in?: false)}
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
