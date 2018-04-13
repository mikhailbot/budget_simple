defmodule BudgetSimple.Budgets.Allotment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "allotments" do
    field :amount, :integer
    field :date, :date
    belongs_to :category, BudgetSimple.Budgets.Category

    timestamps()
  end

  @doc false
  def changeset(allotment, attrs) do
    allotment
    |> cast(attrs, [:date, :amount])
    |> validate_required([:date, :amount])
  end
end
