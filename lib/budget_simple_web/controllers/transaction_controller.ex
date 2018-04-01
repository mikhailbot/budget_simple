defmodule BudgetSimpleWeb.TransactionController do
  use BudgetSimpleWeb, :controller

  import BudgetSimpleWeb.Authorize
  alias BudgetSimple.Budgets
  alias BudgetSimple.Budgets.Transaction

  plug :user_check

  action_fallback BudgetSimpleWeb.FallbackController

  def index(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"plan_id" => plan_id, "account_id" => account_id}) do
    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, String.to_integer(plan_id)) do
      transactions = Budgets.list_transactions(account_id)
      plan = Budgets.get_plan!(plan_id)
      account = Budgets.get_account!(account_id)

      render(conn, "index.html", transactions: transactions, plan: plan, account: account)
    end
  end

  def new(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"plan_id" => plan_id, "account_id" => account_id}) do
    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, String.to_integer(plan_id)) do
      changeset =
        %Transaction{account_id: account_id}
        |> Budgets.change_transaction

      plan = Budgets.get_plan!(plan_id)
      account = Budgets.get_account!(account_id)
      categories = Budgets.list_categories(plan_id)

      render(conn, "new.html", changeset: changeset, plan: plan, account: account, categories: categories)
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render(BudgetSimpleWeb.ErrorView, :"404")
    end
  end

  def create(conn, %{"transaction" => transaction_params, "plan_id" => plan_id, "account_id" => account_id,}) do
    user = conn.assigns.current_user
    IO.inspect account_id
    account = Budgets.get_account!(String.to_integer(account_id))

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, String.to_integer(plan_id)) do
      with {:ok, transaction} <- Budgets.create_transaction(user, account, transaction_params) do
        render(conn, "show.html", transaction: transaction)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          plan = Budgets.get_plan!(plan_id)
          categories = Budgets.list_categories(plan_id)

          render(conn, "new.html", changeset: changeset, plan: plan, account: account, categories: categories)
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
