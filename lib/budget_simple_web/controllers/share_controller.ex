defmodule BudgetSimpleWeb.ShareController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Budgets

  action_fallback BudgetSimpleWeb.FallbackController

  def create(conn, %{"plan_id" => id}) do
    user = conn.assigns.current_user
    plan = Budgets.get_plan!(id)

    with :ok <- Bodyguard.permit(Budgets, :create_share, user, plan) do
      with {:ok, share} <- Budgets.create_share(%{user_id: user.id, plan_id: plan.id}) do
        conn
        |> put_status(:created)
        |> render("show.json",share: share)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BudgetSimpleWeb.ErrorView, "error.json", changeset: changeset)
      end
    end
  end
end
