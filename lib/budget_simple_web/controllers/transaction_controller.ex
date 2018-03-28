defmodule BudgetSimpleWeb.TransactionController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Budgets

  action_fallback BudgetSimpleWeb.FallbackController

  def create(conn, %{"transaction" => transaction_params, "plan_id" => plan_id}) do
    user = conn.assigns.current_user
    plan = Budgets.get_plan!(plan_id)
    attrs =
      transaction_params
      |> Map.put("plan_id", plan_id)
      |> Map.put("user_id", user.id)

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, plan.id) do
      with {:ok, transaction} <- Budgets.create_transaction(attrs) do
        conn
        |> put_status(:created)
        |> render("show.json", transaction: transaction)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BudgetSimpleWeb.ErrorView, "error.json", changeset: changeset)
      end
    end
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params, "plan_id" => plan_id}) do
    user = conn.assigns.current_user
    transaction = Budgets.get_transaction!(id)

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, plan_id) do
      with {:ok, transaction} <- Budgets.update_transaction(transaction, transaction_params) do
        conn
        |> put_status(:accepted)
        |> render("show.json", transaction: transaction)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BudgetSimpleWeb.ErrorView, "error.json", changeset: changeset)
      end
    end
  end
end
