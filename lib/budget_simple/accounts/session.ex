defmodule BudgetSimple.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sessions" do
    field :token, :string
    belongs_to :user, BudgetSimple.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
