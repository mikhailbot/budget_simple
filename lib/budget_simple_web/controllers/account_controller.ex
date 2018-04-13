defmodule BudgetSimpleWeb.AccountController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Budgets

  action_fallback BudgetSimpleWeb.FallbackController

  def create(conn, %{"account" => account_params, "plan_id" => plan_id}) do
    user = conn.assigns.current_user
    plan = Budgets.get_plan!(plan_id)
    attrs =
      account_params
      |> Map.put("plan_id", plan_id)
      |> Map.put("user_id", user.id)

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, plan_id) do
      with {:ok, account} <- Budgets.create_account(attrs) do
        conn
        |> put_status(:created)
        |> render("show.json", account: account)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BudgetSimpleWeb.ErrorView, "error.json", changeset: changeset)
      end
    end
  end
end
