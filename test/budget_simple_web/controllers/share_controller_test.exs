defmodule BudgetSimpleWeb.ShareControllerTest do
  use BudgetSimpleWeb.ConnCase

  alias BudgetSimple.{Budgets, Fixtures}

  @create_attrs %{name: "some name"}

  def fixture(:plan) do
    {:ok, plan} = Budgets.create_plan(@create_attrs)
    plan
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create share" do
    test "renders share when have permissions", %{conn: conn} do
      user = Fixtures.User.create()
      attrs = Map.put(@create_attrs, :owner_id, user.id)

      conn = post conn, plan_path(conn, :create), %{plan: attrs, token: user.token}
      plan_id = json_response(conn, 201)["data"]["id"]

      conn = post conn, share_path(conn, :create), %{plan_id: plan_id, token: user.token}
      body = json_response(conn, 201)

      assert body["data"]["id"]
    end

    test "renders error when don't have permissions", %{conn: conn} do
      first_user = Fixtures.User.create()
      attrs = Map.put(@create_attrs, :owner_id, first_user.id)

      conn = post conn, plan_path(conn, :create), %{plan: attrs, token: first_user.token}
      plan_id = json_response(conn, 201)["data"]["id"]

      second_user = Fixtures.User.create()
      conn = post conn, share_path(conn, :create), %{plan_id: plan_id, token: second_user.token}

      assert json_response(conn, 401)
    end
  end
end
