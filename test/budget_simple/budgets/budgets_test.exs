defmodule BudgetSimple.BudgetsTest do
  use BudgetSimple.DataCase

  alias BudgetSimple.{Accounts, Budgets}

  describe "plans" do
    @valid_attrs %{name: "Plan name"}
    @invalid_attrs %{name: nil}

    @valid_user %{first_name: "Fred", email: "fred@example.com", password: "reallyHard2gue$$"}

    def plan_fixture(attrs \\ %{}) do
      {:ok, plan} =
        attrs.user
        |> Budgets.create_plan(@valid_attrs)
      plan
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_user)
        |> Accounts.create_user()

      user
    end

    test "list_plans/0 returns all plans" do
      user = user_fixture()
      plan = plan_fixture(%{user: user})
      assert Budgets.list_plans() == [plan]
    end

    test "get_plan!/1 returns the plan with given id" do
      user = user_fixture()
      plan = plan_fixture(%{user: user})
      assert Budgets.get_plan!(plan.id) == plan
    end

    test "create_plan/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.create_plan(user, @invalid_attrs)
    end
  end
end
