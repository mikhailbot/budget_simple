defmodule BudgetSimple.Budgets.Category do
  use Ecto.Schema
  import Ecto.Changeset


  schema "categories" do
    field :name, :string
    belongs_to :plan, BudgetSimple.Budgets.Plan

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :plan_id])
    |> validate_required([:name, :plan_id])
  end
end
