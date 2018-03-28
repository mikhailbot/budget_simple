defmodule BudgetSimple.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :date, :date
      add :inflow, :integer
      add :outflow, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :plan_id, references(:plans, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:user_id])
    create index(:transactions, [:plan_id])
    create index(:transactions, [:category_id])
    create index(:transactions, [:account_id])
  end
end
