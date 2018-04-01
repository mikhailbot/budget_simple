defmodule BudgetSimple.Budgets do
  @moduledoc """
  The Budgets context.
  """
  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias BudgetSimple.Repo

  alias BudgetSimple.Accounts
  alias BudgetSimple.Accounts.User
  alias BudgetSimple.Budgets.{Plan, Share, Category, Account, Transaction}

  def authorize(:create_share, %Accounts.User{id: user_id}, %Plan{user_id: user_id}), do: true

  def authorize(:plan_access, user, plan_id) do
    user.plans ++ user.shared_plans
    |> Enum.any?(fn(p) -> p.id == plan_id end)
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

  def change_plan(%Plan{} = plan) do
    Plan.changeset(plan, %{})
  end

  def create_share(attrs \\ %{}) do
    %Share{}
    |> Share.changeset(attrs)
    |> Repo.insert()
  end

  def create_category(%User{} = user, %Plan{} = plan, attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Ecto.Changeset.put_change(:plan_id, plan.id)
    |> Repo.insert()
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def list_categories(plan_id) do
    Category
    |> where([c], c.plan_id == ^plan_id)
    |> order_by(asc: :inserted_at)
    |> Repo.all
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def create_account(%User{} = user, %Plan{} = plan, attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Ecto.Changeset.put_change(:plan_id, plan.id)
    |> Repo.insert()
  end

  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  def list_transactions(account_id) do
    from(t in Transaction, where: t.account_id == ^account_id)
    |> Repo.all()
  end

  def create_transaction(%User{} = user, %Account{} = account, attrs \\ %{}) do
    %Transaction{}
    |> Transaction.create_changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Ecto.Changeset.put_change(:account_id, account.id)
    |> Repo.insert()
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def update_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    transaction
    |> Transaction.update_changeset(attrs)
    |> Repo.update()
  end

  def change_transaction(%Transaction{} = transaction) do
    Transaction.create_changeset(transaction, %{})
  end

end
