defmodule BudgetSimple.Budgets do
  @moduledoc """
  The Budgets context.
  """
  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias BudgetSimple.Repo

  alias BudgetSimple.Accounts
  alias BudgetSimple.Budgets.{Plan, Share}

  def authorize(:create_share, %Accounts.User{id: user_id}, %Plan{user_id: user_id}), do: true

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
  def create_plan(attrs \\ %{}) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Repo.insert()
  end

  def create_share(attrs \\ %{}) do
    %Share{}
    |> Share.changeset(attrs)
    |> Repo.insert()
  end
end
