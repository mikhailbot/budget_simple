defmodule BudgetSimple.Fixtures.Plan do
  alias BudgetSimple.Budgets

  def create(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{name: Faker.StarWars.character()})

    with {:ok, plan} <- Budgets.create_plan(attrs) do
      plan
    end
  end
end
