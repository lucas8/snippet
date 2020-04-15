defmodule SnippetWeb.SessionController do
  use SnippetWeb, :controller
  plug Ueberauth

  alias Snippet.Accounts
  alias Snippet.Accounts.User

  def create(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: provider,
      username: auth.info.nickname,
      profile_url: auth.info.image
    }

    changeset = User.changeset(%User{}, user_params)

    case Accounts.insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.live_path(conn, SnippetWeb.SnippetIndexLive))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.live_path(conn, SnippetWeb.SnippetIndexLive))
    end
  end
end
