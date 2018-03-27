# defmodule BudgetSimple.BudgetsTest do
#   use BudgetSimple.DataCase

#   alias BudgetSimple.{Accounts, Budgets}

#   describe "plans" do
#     @valid_attrs %{name: "some name"}
#     @invalid_attrs %{name: nil}

#     @valid_user %{email: "some email", password: "some encrypted_password", first_name: "some first_name"}

#     def plan_fixture(attrs \\ %{}) do
#       {:ok, plan} =
#         attrs
#         |> Enum.into(@valid_attrs)
#         |> Budgets.create_plan()

#       plan
#     end

#     def user_fixture(attrs \\ %{}) do
#       {:ok, user} =
#         attrs
#         |> Enum.into(@valid_user)
#         |> Accounts.create_user()

#       user
#     end

#     test "list_plans/0 returns all plans" do
#       user = user_fixture()
#       plan = plan_fixture(%{user_id: user.id})
#       assert Budgets.list_plans() == [plan]
#     end

#     test "get_plan!/1 returns the plan with given id" do
#       user = user_fixture()
#       plan = plan_fixture(%{user_id: user.id})
#       assert Budgets.get_plan!(plan.id) == plan
#     end

#     test "create_plan/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Budgets.create_plan(@invalid_attrs)
#     end
#   end
# end
