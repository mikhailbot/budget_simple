defmodule BudgetSimple.Repo.Migrations.CreateShares do
  use Ecto.Migration

  def change do
    create table(:shares) do
      add :plan_id, references(:plans, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:shares, [:plan_id])
    create index(:shares, [:user_id])
    create unique_index(:shares, [:plan_id, :user_id])
  end
end
