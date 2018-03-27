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

  pipeline :auth do
    plug :fetch_token_session
  end

  scope "/", BudgetSimpleWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", BudgetSimpleWeb do
    pipe_through :api
    pipe_through :auth

    resources "/sessions", SessionController, only: [:create]
    resources "/plans", PlanController, only: [:create]
    resources "/shares", ShareController, only: [:create]
  end

  scope "/api", BudgetSimpleWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", BudgetSimpleWeb do
  #   pipe_through :api
  # end

  defp fetch_token_session(conn, _) do
    with {:ok, user} <- BudgetSimple.Accounts.get_session_user(conn.params["token"]) do
      conn
      |> assign(:current_user, user)
    else
      _ ->
        conn
        |> put_status(:forbidden)
        |> render(BudgetSimpleWeb.ErrorView, "403", %{})
        |> halt
    end
  end
end
