defmodule BudgetSimple.Budgets do
  @moduledoc """
  The Budgets context.
  """
  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias BudgetSimple.Repo

  alias BudgetSimple.Accounts
  alias BudgetSimple.Accounts.User
  alias BudgetSimple.Budgets.{Plan, Share, Category, Account, Transaction, Allotment}

  def authorize(:create_share, %Accounts.User{id: user_id}, %Plan{user_id: user_id}), do: true

  def authorize(:plan_access, user, plan_id) do
    list_user_plans(user.id)
    |> Enum.any?(fn(p) -> p.id == String.to_integer(plan_id) end)
  end

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false

  @doc """
  Returns the list of plans.

  ## Examples

      iex> list_plans()
      [%Plan{}, ...]

  """
  def list_plans do
    Repo.all(Plan)
  end

  def list_user_plans(id) do
    Plan
    |> where([p], p.user_id == ^id)
    |> preload([:user])
    |> Repo.all
  end

  @doc """
  Gets a single plan.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan!(123)
      %Plan{}

      iex> get_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plan!(id), do: Repo.get!(Plan, id)

  @doc """
  Creates a plan.

  ## Examples

      iex> create_plan(%{field: value})
      {:ok, %Plan{}}

      iex> create_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan(%User{} = user, attrs \\ %{}) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  def create_share(attrs \\ %{}) do
    %Share{}
    |> Share.changeset(attrs)
    |> Repo.insert()
  end

  def create_category(plan_id, attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Ecto.Changeset.put_change(:plan_id, plan_id)
    |> Repo.insert()
  end

  def list_categories(plan_id) do
    Category
    |> where([c], c.plan_id == ^plan_id)
    |> order_by(asc: :inserted_at)
    |> Repo.all
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def list_accounts(plan_id) do
    Account
    |> where([a], a.plan_id == ^plan_id)
    |> order_by(asc: :inserted_at)
    |> Repo.all
  end

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.create_changeset(attrs)
    |> Repo.insert()
  end

  def list_transactions(plan_id) do
    Transaction
    |> where([t], t.plan_id == ^plan_id)
    |> order_by(desc: :date)
    |> Repo.all
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def update_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    transaction
    |> Transaction.update_changeset(attrs)
    |> Repo.update()
  end

end
