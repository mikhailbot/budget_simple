defmodule BudgetSimple.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :type, :string
      add :name, :string
      add :plan_id, references(:plans, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts, [:plan_id])
    create index(:accounts, [:user_id])
    create unique_index(:accounts, [:plan_id, :name])
  end
end
