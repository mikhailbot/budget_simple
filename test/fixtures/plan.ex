defmodule BudgetSimple.Fixtures.Plan do
  alias BudgetSimple.Budgets

  def create(user) do
    with {:ok, plan} <- Budgets.create_plan(user, %{name: Faker.StarWars.character()}) do
      plan
    end
  end
end
