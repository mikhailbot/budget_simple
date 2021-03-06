defmodule BudgetSimpleWeb.Router do
  use BudgetSimpleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :fetch_token_session
  end

  scope "/api", BudgetSimpleWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/sessions", SessionController, :create
  end

  scope "/api", BudgetSimpleWeb do
    pipe_through :api
    pipe_through :auth

    post "/share", ShareController, :create
    resources "/plans", PlanController, only: [:index, :create, :show] do
      resources "/categories", CategoryController, only: [:index, :create]
      resources "/accounts", AccountController, only: [:create]
      resources "/transactions", TransactionController, only: [:create]
    end
  end

  defp fetch_token_session(conn, _) do
    with {:ok, user} <- BudgetSimple.Accounts.get_session_user(get_req_header(conn, "authorization")) do
      conn
      |> assign(:current_user, user)
    else
      _ ->
        conn
        |> put_status(:forbidden)
        |> render(BudgetSimpleWeb.ErrorView, "403.json", %{})
        |> halt
    end
  end

end
