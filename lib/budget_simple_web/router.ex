defmodule BudgetSimpleWeb.Router do
  use BudgetSimpleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BudgetSimpleWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", BudgetSimpleWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", BudgetSimpleWeb do
  #   pipe_through :api
  # end
end
