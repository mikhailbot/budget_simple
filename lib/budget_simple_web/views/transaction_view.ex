defmodule BudgetSimpleWeb.TransactionView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.TransactionView

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      date: transaction.date,
      inflow: transaction.inflow,
      outflow: transaction.outflow,
      category_id: transaction.category_id,
      plan_id: transaction.plan_id,
      account_id: transaction.account_id
    }
  end
end
