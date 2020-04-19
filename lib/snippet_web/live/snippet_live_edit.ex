defmodule SnippetWeb.SnippetEditLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content
  alias Snippet.Accounts
  alias SnippetWeb.Presence
  alias Snippet.Repo

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Accounts.get_user!(user_id)

    {:ok, socket |> assign(user: user, signed_in?: true, show_delete_modal: false, show_publish_modal: false, users: [], query: nil, matches: [])}
  end

  def mount(_params, _session, socket) do
    {:ok, socket
    |> redirect(to: Routes.session_path(socket, :request, "github"))}
  end

  def handle_params(%{"id" => slug}, _uri, %{assigns: %{user: user}} = socket) do
    case Content.get_snippet_by_slug(slug) do
      nil ->
        {:noreply, socket
        |> put_flash(:error, "That snippet couldn't be found")
        |> redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}

      snippet ->
        invites = Content.get_invites(snippet.id)
        user_id_list = Enum.map(invites, fn inv -> inv.user.id end)

        if(Enum.member?(user_id_list, user.id) || snippet.user_id == user.id) do
          # TODO: Mark pending as "Accepted" -> do the same in view
          # TODO: Allow "public" rooms
          SnippetWeb.Endpoint.subscribe("snippet:#{snippet.id}")

          Presence.track(
            self(),
            "snippet:#{snippet.id}",
            user.id,
            user
          )

          {:noreply, assign(socket, snippet: snippet, users: [], invites: invites)}
        else
          {:noreply, socket
          |> put_flash(:error, "You don't have permission to access that snippet.")
          |> redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}
        end
    end
  end

  def handle_event("add-user", %{"q" => q}, %{assigns: %{snippet: snippet, invites: invites}} = socket) do
    user_to_invite = Accounts.get_user_by_username!(q)

    case Content.create_invite(snippet, user_to_invite, "Pending") do
      {:ok, invite} ->
        invite = Repo.preload(invite, :user)
        new_invite = %{status: invite.status, user: %{username: invite.user.username}}

        {:noreply, assign(socket, invites: [new_invite | invites])}

      {:error, _reason} ->
          {:noreply, socket
            |> put_flash(:error, "An error occured trying to invite that user")
            |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetShowLive, snippet.slug))}

    end
  end

  def handle_event("suggest", %{"q" => q}, socket) when byte_size(q) <= 100 do
    results = Accounts.find_like_user(q)
    {:noreply, socket |> assign(matches: results)}
  end

  def handle_event("change_value", value, %{assigns: %{snippet: snippet}} = socket) do
    case Content.update_snippet(snippet, %{body: value}) do
      {:ok, snippet} ->
        SnippetWeb.Endpoint.broadcast!(
          "snippet:#{socket.assigns.snippet.id}",
          "updated_snippet",
          %{socket.assigns.snippet | body: value}
        )
        {:noreply, socket
        |> assign(snippet: snippet)}

      {:error, _} ->
        {:noreply, socket}
    end
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
    {:noreply, assign(socket, show_delete_modal: true)}
  end

  def handle_event("create-snippet", _params, socket) do
    {:noreply, socket
      |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}
  end

  def handle_event("publish-button", _params, socket) do
    {:noreply, socket |> assign(show_publish_modal: true)}
  end

  def handle_event("publish-cancel", _parmas, socket) do
    {:noreply, assign(socket, show_publish_modal: false)}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{snippet: snippet}}) do
    users = Presence.list("snippet:#{snippet.id}")
    |> Enum.map(fn {_user_map, data} ->
      data[:metas]
      |> List.first()
    end)

    {:noreply, assign(socket, users: users)}
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
    {:noreply, assign(socket, show_delete_modal: false)}
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
