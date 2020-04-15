defmodule SnippetWeb.SnippetIndexLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content
  alias Snippet.Accounts

  def render(assigns) do
    ~L"""
    <div class="flex h-full">
      <div class="m-auto text-center">
        <h1 class="text-4xl font-bold text-white">Create A Snippet</h1>

        <div class="flex flex-shrink-0 mt-4">
          <div class="inline-flex rounded-md shadow">
            <a href="#" class="btn-secondary">
              <svg class="mr-2 opacity-50 fill-current h-5 w-5 text-white" fill="currentColor" viewBox="0 0 20 20" class="w-8 h-8"><path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"></path></svg>
              Search
            </a>
          </div>
          <div class="ml-3 inline-flex rounded-md shadow lm-2">
            <button type="button" phx-click="create-snippet" class="btn-primary">
              <svg class="mr-2 fill-current h-5 w-5 text-white" fill="currentColor" viewBox="0 0 20 20" class="w-8 h-8"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z" clip-rule="evenodd"></path></svg>
              Create a new Snippet
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    IO.puts(user_id)
    {:ok, socket |> assign(user_id: user_id)}
  end

  def handle_event("create-snippet", _params, socket) do
    slug = create_slug_of_length()
    content_params = %{name: "New Code Snippet", author: "Anonymous", slug: slug}
    user = Accounts.get_user!(socket.assigns.user_id)

    case Content.create_snippet(user, content_params) do
      {:ok, snippet} ->
        {:noreply, socket
        |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetEditLive, snippet.slug))}

      {:error, _} ->
        {:noreply, socket
        |> put_flash(:error, "An error has occured while creating a snippet.")
        |> push_redirect(to: Routes.live_path(socket, SnippetWeb.SnippetIndexLive))}
    end
  end

  defp create_slug_of_length(length \\ 20) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
