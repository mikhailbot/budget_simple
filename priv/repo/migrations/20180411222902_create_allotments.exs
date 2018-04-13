defmodule BudgetSimple.Repo.Migrations.CreateAllotments do
  use Ecto.Migration

  def change do
    create table(:allotments) do
      add :date, :date
      add :amount, :integer
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:allotments, [:category_id])
  end
end
