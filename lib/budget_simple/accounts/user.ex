defmodule BudgetSimple.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :first_name, :string
    field :password, :string, virtual: true

    has_many :plans, BudgetSimple.Budgets.Plan
    many_to_many :shared_plans, BudgetSimple.Budgets.Plan, join_through: "shares"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :email, :password])
    |> validate_required([:first_name, :email, :password])
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> validate_password(:password)
    |> put_pass_hash()
  end

  @doc false
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  @doc false
  defp valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end
  defp valid_password?(_), do: {:error, "The password is too short"}

  @doc false
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
    %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  defp put_pass_hash(changeset), do: changeset

end
