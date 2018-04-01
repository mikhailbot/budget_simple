defmodule BudgetSimple.Budgets.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :date, :date
    field :inflow, :integer
    field :outflow, :integer
    field :merchant, :string

    belongs_to :category, BudgetSimple.Budgets.Category
    belongs_to :account, BudgetSimple.Budgets.Account
    belongs_to :user, BudgetSimple.Accounts.User

    timestamps()
  end

  @doc false
  def create_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :inflow, :outflow, :merchant, :category_id])
    |> validate_required([:date])
    |> validate_required_inclusion([:inflow, :outflow])
  end

  def update_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :inflow, :outflow, :category_id, :merchant])
  end

  defp validate_required_inclusion(changeset, fields) do
    if Enum.any?(fields, &present?(changeset, &1)) do
      changeset
    else
      # Add the error to the first field only since Ecto requires a field name for each error.
      add_error(changeset, hd(fields), "One of these fields must be present: #{inspect fields}")
    end
  end

  defp present?(changeset, field) do
    value = get_field(changeset, field)
    value && value != ""
  end
end
