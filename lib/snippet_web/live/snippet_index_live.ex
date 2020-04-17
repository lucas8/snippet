defmodule SnippetWeb.SnippetIndexLive do
  use Phoenix.LiveView, layout: {SnippetWeb.LayoutView, "live.html"}

  alias SnippetWeb.Router.Helpers, as: Routes
  alias Snippet.Content
  alias Snippet.Accounts

  def render(assigns) do
    ~L"""
    <div class="flex h-full">
      <div class="m-auto text-center">
        <h1 class="text-4xl font-bold text-white mb-2">Create A Snippet</h1>

        <div class="flex lg:mt-0 lg:ml-4 flex-col sm:flex-row">
          <div class="inline-flex rounded-md shadow">
            <a href="https://github.com/lucas8/snippet" class="btn-secondary w-full sm:w-auto">
              <svg class="mr-2 opacity-50 fill-current h-5 w-5 text-white" fill="currentColor" viewBox="0 0 24 24" class="w-8 h-8"><path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></path></svg>
              lucas8/snippet
            </a>
          </div>
          <div class="ml-0 sm:ml-3 inline-flex rounded-md shadow lm-2 mt-3 sm:mt-0">
            <button type="button" phx-click="create-snippet" class="btn-primary w-full sm:w-auto">
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
    user = Accounts.get_user!(user_id)
    {:ok, socket |> assign(user: user, signed_in?: true)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(user: nil, signed_in?: false)}
  end

  def handle_event("create-snippet", _params, %{assigns: %{user: user, signed_in?: true}} = socket) do
    slug = create_slug_of_length()
    content_params = %{name: "New Code Snippet", author: user.username, slug: slug}

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

  def handle_event("create-snippet", _params, socket) do
    slug = create_slug_of_length()
    content_params = %{name: "New Code Snippet", author: "Anonymous", slug: slug}

    case Content.create_snippet_no_user(content_params) do
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
