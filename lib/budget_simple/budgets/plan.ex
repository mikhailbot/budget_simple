defmodule BudgetSimple.Budgets.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :name, :string
    belongs_to :user, BudgetSimple.Accounts.User, foreign_key: :owner_id

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
  end
end
