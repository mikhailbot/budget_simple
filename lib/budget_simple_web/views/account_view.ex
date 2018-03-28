defmodule BudgetSimpleWeb.AccountView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.AccountView

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      name: account.name,
      type: account.type
    }
  end
end
