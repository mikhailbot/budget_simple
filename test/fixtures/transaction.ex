defmodule BudgetSimple.Fixtures.Transaction do
  alias BudgetSimple.Budgets

  def create(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{date: Faker.Date.date_of_birth(), outlfow: Faker.Address.building_number()})

    with {:ok, transaction} <- Budgets.create_transaction(attrs) do
      transaction
    end
  end
end
