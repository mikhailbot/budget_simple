defmodule BudgetSimpleWeb.PlanControllerTest do
  use BudgetSimpleWeb.ConnCase

  alias BudgetSimple.{Budgets, Fixtures}

  @create_attrs %{name: "some name"}
  @invalid_attrs %{name: nil}

  def fixture(:plan) do
    {:ok, plan} = Budgets.create_plan(@create_attrs)
    plan
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create plan" do
    test "renders plan when data is valid", %{conn: conn} do
      user = Fixtures.User.create()
      attrs =
        @create_attrs
        |> Map.put(:user_id, user.id)

      conn = post conn, plan_path(conn, :create), %{plan: attrs, token: user.token}
      body = json_response(conn, 201)
      assert body["data"]["id"]
      assert body["data"]["name"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = Fixtures.User.create()
      attrs =
        @invalid_attrs
        |> Map.put(:user_id, user.id)

      conn = post conn, plan_path(conn, :create), %{plan: attrs,  token: user.token}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
