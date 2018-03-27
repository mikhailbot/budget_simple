defmodule BudgetSimple.Budgets.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :name, :string

    belongs_to :user, BudgetSimple.Accounts.User
    many_to_many :users, BudgetSimple.Accounts.User, join_through: "shares"

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
