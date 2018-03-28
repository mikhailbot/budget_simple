defmodule BudgetSimple.Budgets.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :date, :date
    field :inflow, :integer
    field :outflow, :integer
    field :user_id, :id
    field :plan_id, :id
    field :category_id, :id
    field :account_id, :id

    timestamps()
  end

  @doc false
  def create_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :inflow, :outflow, :user_id, :plan_id, :category_id, :account_id])
    |> validate_required([:date, :user_id, :plan_id])
  end

  def update_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :inflow, :outflow, :category_id, :account_id])
  end
end
