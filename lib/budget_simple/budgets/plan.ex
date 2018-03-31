defmodule BudgetSimple.Budgets.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :name, :string

    has_many :accounts, BudgetSimple.Budgets.Account
    belongs_to :user, BudgetSimple.Accounts.User
    many_to_many :users, BudgetSimple.Accounts.User, join_through: "shares"

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
