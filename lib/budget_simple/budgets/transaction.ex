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
    field :merchant, :string

    timestamps()
  end

  @doc false
  def create_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :inflow, :outflow, :user_id, :plan_id, :category_id, :account_id, :merchant])
    |> validate_required([:date, :user_id, :plan_id])
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
