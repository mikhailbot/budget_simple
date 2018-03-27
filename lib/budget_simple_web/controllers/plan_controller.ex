defmodule BudgetSimpleWeb.PlanController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.{Budgets, Accounts}
  alias BudgetSimple.Budgets.Plan

  action_fallback BudgetSimpleWeb.FallbackController

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Budgets.create_plan(plan_params) do
      conn
      |> put_status(:created)
      |> render("show.json", plan: plan)
    end
  end

  def index(conn, _) do
    with user = conn.assigns.current_user do
      user = Accounts.get_user_plans!(user.id)
      plans = Map.get(user, :plans)
      shared_plans = Map.get(user, :shared_plans)

      conn
      |> put_status(:ok)
      |> render("index.json", %{plans: plans, shared_plans: shared_plans})
    end
  end
end
