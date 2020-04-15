defmodule SnippetWeb.Router do
  use SnippetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {SnippetWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SnippetWeb do
    pipe_through :browser

    live "/", SnippetIndexLive
    live "/:id/edit", SnippetEditLive
    live "/:id", SnippetShowLive
  end

  scope "/auth", SnippetWeb do
    pipe_through :browser

    get "/:provider", SessionController, :request
    get "/:provider/callback", SessionController, :create
  end
end
