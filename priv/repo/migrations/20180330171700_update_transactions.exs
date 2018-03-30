defmodule BudgetSimple.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :merchant, :string
    end
  end
end
