defmodule BudgetSimpleWeb.PlanController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Budgets
  alias BudgetSimple.Budgets.Plan

  action_fallback BudgetSimpleWeb.FallbackController

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Budgets.create_plan(plan_params) do
      conn
      |> put_status(:created)
      |> render("show.json", plan: plan)
    end
  end
end
