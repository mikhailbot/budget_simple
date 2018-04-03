defmodule BudgetSimpleWeb.Router do
  use BudgetSimpleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phauxth.Authenticate
  end

  scope "/", BudgetSimpleWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/plans", PlanController, only: [:show, :create, :new, :index] do
      resources "/categories", CategoryController, only: [:new, :create, :show]
      resources "/transactions", TransactionController, only: [:new, :create, :show]
      resources "/accounts", AccountController, only: [:new, :create, :show]
    end
  end

end
