defmodule BudgetSimpleWeb.AccountController do
  use BudgetSimpleWeb, :controller

  import BudgetSimpleWeb.Authorize
  alias BudgetSimple.Budgets
  alias BudgetSimple.Budgets.Account

  plug :user_check

  action_fallback BudgetSimpleWeb.FallbackController

  def new(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"plan_id" => plan_id}) do
    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, String.to_integer(plan_id)) do
      changeset =
        %Account{plan_id: plan_id}
        |> Budgets.change_account

      plan = Budgets.get_plan!(plan_id)

      render(conn, "new.html", changeset: changeset, plan: plan)
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render(BudgetSimpleWeb.ErrorView, :"404")
    end
  end

  def create(conn, %{"account" => account_params, "plan_id" => plan_id}) do
    user = conn.assigns.current_user
    plan = Budgets.get_plan!(plan_id)

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, plan.id) do
      with {:ok, account} <- Budgets.create_account(user, plan, account_params) do
        transactions = Budgets.list_transactions(account.id)

        render(conn, "show.html", account: account, plan_id: plan.id, transactions: transactions)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, plan: plan)
      end
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render(BudgetSimpleWeb.ErrorView, :"404")
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"plan_id" => plan_id, "id" => id}) do
    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, String.to_integer(plan_id)) do
      account = Budgets.get_account!(id)
      transactions = Budgets.list_transactions(id)

      render(conn, "show.html", account: account, plan_id: plan_id, transactions: transactions)
    else
      _ ->
        render(conn, BudgetSimpleWeb.ErrorView, "403.json", %{})
    end
  end
end
