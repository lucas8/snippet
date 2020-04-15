defmodule SnippetWeb.LiveComponent.SidebarLive do
  use Phoenix.LiveComponent

  alias SnippetWeb.Router.Helpers, as: Routes

  @defaults %{
    signed_in?: false,
    user: nil,
    dropdown_active?: false
  }

  def render(assigns) do
    ~L"""
    <navbar id="sidebar-<%= @id %>">
      <div class="navbar w-20 h-full p-4 flex flex-col">
        <button phx-click="create-snippet" class="inline-flex items-center p-2 rounded-lg bg-indigo-500 hover:bg-indigo-500 focus:outline-none active:bg-indigo-700 transition duration-150 ease-in-out">
          <svg class="fill-current h-8 w-8 text-white" fill="currentColor" viewBox="0 0 20 20" class="w-8 h-8"><path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z"></path></svg>
        </button>
        <%= live_patch to: Routes.live_path(@socket, SnippetWeb.SnippetIndexLive), class: "navbar-item" do %>
          <svg class="fill-current h-8 w-8 text-white" fill="currentColor" viewBox="0 0 20 20" class="w-8 h-8"><path fill-rule="evenodd" d="M12.316 3.051a1 1 0 01.633 1.265l-4 12a1 1 0 11-1.898-.632l4-12a1 1 0 011.265-.633zM5.707 6.293a1 1 0 010 1.414L3.414 10l2.293 2.293a1 1 0 11-1.414 1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0zm8.586 0a1 1 0 011.414 0l3 3a1 1 0 010 1.414l-3 3a1 1 0 11-1.414-1.414L16.586 10l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
        <% end %>
        <a href="#" class="navbar-item">
          <svg class="fill-current h-8 w-8 text-white" fill="currentColor" viewBox="0 0 20 20" class="w-8 h-8"><path d="M7 3a1 1 0 000 2h6a1 1 0 100-2H7zM4 7a1 1 0 011-1h10a1 1 0 110 2H5a1 1 0 01-1-1zM2 11a2 2 0 012-2h12a2 2 0 012 2v4a2 2 0 01-2 2H4a2 2 0 01-2-2v-4z"></path></svg>
        </a>
        <a href="#" class="navbar-item">
          <svg class="fill-current h-8 w-8 text-white" fill="currentColor" viewBox="0 0 20 20" class="w-8 h-8"><path fill-rule="evenodd" d="M18 3a1 1 0 00-1.447-.894L8.763 6H5a3 3 0 000 6h.28l1.771 5.316A1 1 0 008 18h1a1 1 0 001-1v-4.382l6.553 3.276A1 1 0 0018 15V3z" clip-rule="evenodd"></path></svg>
        </a>
        <%= if @signed_in? do %>
          <button phx-click="profile-toggle" phx-target="#sidebar-<%= @id %>" class="navbar-item focus:outine-none" style="margin-top: auto !important;">
            <img class="rounded-full" src="<%= @user.profile_url %>" />
          </button>
        <% else %>
          <a href="/auth/github" class="navbar-item" style="margin-top: auto !important;">
            <svg class="fill-current h-8 w-8 text-white" fill="currentColor" viewBox="0 0 20 20" class="w-8 h-8"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.986 5.986 0 0010 16a5.986 5.986 0 004.546-2.084A5 5 0 0010 11z" clip-rule="evenodd"></path></svg>
          </a>
        <% end %>
      </div>

      <%= if @dropdown_active? do %>
        <div phx-click="profile-toggle-off" phx-target="#sidebar-<%= @id %>" class="absolute w-full h-full top-0 left-0 z-20 right-0 bottom-0" style="background: rgba(0,0,0,0.50)"></div>
        <div class="origin-top-left absolute left-5 ml-16 mb-6 z-20 bottom-0 w-56 rounded-md shadow-2xl">
          <div class="rounded-md shadow-xs" style="background: #1B1C20">
            <div class="py-1">
              <a href="#" class="dropdown-item">Support</a>
              <a href="/auth/signout" class="dropdown-item">Sign out</a>
            </div>
          </div>
        </div>
      <% end %>
    </navbar>
    """
  end

  def module(socket) do
    {:ok, socket}
  end

  def update(%{id: _id} = assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  def handle_event("profile-toggle", _params, socket) do
    {:noreply, socket |> assign(dropdown_active?: true)}
  end

  def handle_event("profile-toggle-off", _params, socket) do
    {:noreply, socket |> assign(dropdown_active?: false)}
  end
end
