defmodule BudgetSimpleWeb.PlanControllerTest do
  use BudgetSimpleWeb.ConnCase

  alias BudgetSimple.{Budgets, Accounts}

  @create_attrs %{name: "some name"}
  @invalid_attrs %{name: nil}

  def fixture(:plan) do
    {:ok, plan} = Budgets.create_plan(@create_attrs)
    plan
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "some email", password: "some encrypted_password", first_name: "some first_name"})
      |> Accounts.create_user()

    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create plan" do
    test "renders plan when data is valid", %{conn: conn} do
      user = user_fixture()
      attrs = Map.put(@create_attrs, :owner_id, user.id)
      conn = post conn, plan_path(conn, :create), plan: attrs
      body = json_response(conn, 201)
      assert body["data"]["id"]
      assert body["data"]["name"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, plan_path(conn, :create), plan: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
