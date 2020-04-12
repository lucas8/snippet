defmodule SnippetWeb.Router do
  use SnippetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SnippetWeb do
    pipe_through :browser

    resources("/content", PageController)

    live "/snippet", SnippetLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", SnippetWeb do
  #   pipe_through :api
  # end
end
