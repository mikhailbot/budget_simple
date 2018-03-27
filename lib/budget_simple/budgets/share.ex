defmodule BudgetSimple.Budgets.Share do
  use Ecto.Schema
  import Ecto.Changeset


  schema "shares" do
    belongs_to :user, BudgetSimple.Accounts.User
    belongs_to :plan, BudgetSimple.Budgets.Plan

    timestamps()
  end

  @doc false
  def changeset(share, attrs) do
    share
    |> cast(attrs, [:user_id, :plan_id])
    |> validate_required([:user_id, :plan_id])
  end
end
