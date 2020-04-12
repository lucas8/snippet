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

    # get "/pages/:page", PageController, :show

    resources("/content", PageController, except: [:delete, :update, :create, :edit])
    live "/content/:id/edit", SnippetLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", SnippetWeb do
  #   pipe_through :api
  # end
end
