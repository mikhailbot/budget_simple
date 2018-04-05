defmodule BudgetSimpleWeb.PlanController do
  use BudgetSimpleWeb, :controller

  import BudgetSimpleWeb.Authorize
  alias BudgetSimple.{Budgets, Accounts}
  alias BudgetSimple.Budgets.Plan

  action_fallback BudgetSimpleWeb.FallbackController

  plug :user_check when action in [:index, :create]

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Budgets.create_plan(conn.assigns.current_user, plan_params) do
      conn
      |> put_status(:created)
      |> render("show.json", plan: plan)
    end
  end

  def index(conn, _) do
    with user = conn.assigns.current_user do
      plans = Budgets.list_user_plans(user.id)

      conn
      |> put_status(:ok)
      |> render("index.json", %{plans: plans})
    end
  end
end
