defmodule BudgetSimpleWeb.PlanController do
  use BudgetSimpleWeb, :controller

  import BudgetSimpleWeb.Authorize
  alias BudgetSimple.{Budgets, Accounts}
  alias BudgetSimple.Budgets.Plan

  plug :user_check when action in [:index, :create]

  action_fallback BudgetSimpleWeb.FallbackController

  def new(conn, _) do
    changeset = Budgets.change_plan(%Budgets.Plan{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Budgets.create_plan(conn.assigns.current_user, plan_params) do
      render(conn, "show.html", plan: plan)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _) do
    with user = conn.assigns.current_user do
      user = Accounts.get_user_plans!(user.id)
      plans = user.plans ++ user.shared_plans

      render(conn, "index.html", %{plans: plans})
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, String.to_integer(id)) do
      plan = Budgets.get_plan!(id)
      render(conn, "show.html", plan: plan)
    else
      _ ->
        render(conn, BudgetSimpleWeb.ErrorView, "403.json", %{})
    end
  end
end
