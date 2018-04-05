defmodule BudgetSimpleWeb.Router do
  use BudgetSimpleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.Authenticate, method: :token
  end

  scope "/api", BudgetSimpleWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    resources "/users", UserController, only: [:index, :show]
    resources "/plans", PlanController, only: [:index, :create]
  end

end
