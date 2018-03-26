defmodule BudgetSimple.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :name, :string
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:plans, [:owner_id])
  end
end
