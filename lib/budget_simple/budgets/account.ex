defmodule BudgetSimple.Budgets.Account do
  use Ecto.Schema
  import Ecto.Changeset


  schema "accounts" do
    field :name, :string
    field :type, :string

    belongs_to :user, BudgetSimple.Accounts.User
    belongs_to :plan, BudgetSimple.Budgets.Plan

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:type, :name])
    |> validate_required([:type, :name])
    |> validate_inclusion(:type, ["credit_card", "debit_card", "line_of_credit", "investment"])
  end
end
