defmodule BudgetSimple.Fixtures.Account do
  alias BudgetSimple.Budgets

  def create(user, plan) do
    with {:ok, account} <- Budgets.create_account(user, plan, %{name: Faker.StarWars.character(), type: "credit_card"}) do
      account
    end
  end
end
