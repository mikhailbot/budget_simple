defmodule BudgetSimple.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :plan_id, references(:plans, on_delete: :nothing)

      timestamps()
    end

    create index(:categories, [:plan_id])
  end
end
