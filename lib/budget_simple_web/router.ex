defmodule BudgetSimpleWeb.Router do
  use BudgetSimpleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.Authenticate, method: :token
  end

  scope "/api", BudgetSimpleWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    resources "/users", UserController, only: [:index, :show, :create]
    resources "/plans", PlanController, only: [:index, :create, :show] do
      resources "/categories", CategoryController, only: [:index, :create]
    end
  end

end
