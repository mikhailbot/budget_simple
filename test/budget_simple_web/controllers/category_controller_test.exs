defmodule BudgetSimpleWeb.CategoryControllerTest do
  use BudgetSimpleWeb.ConnCase

  alias BudgetSimple.Fixtures

  @create_attrs %{name: "some name"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create category" do
    test "renders category when have permissions", %{conn: conn} do
      first_user = Fixtures.User.create()
      attrs = Map.put(@create_attrs, :user_id, first_user.id)

      conn = post conn, plan_path(conn, :create), %{plan: attrs, token: first_user.token}
      plan_id = json_response(conn, 201)["data"]["id"]

      conn = post build_conn(), category_path(build_conn(), :create), %{plan_id: plan_id, name: "some category name", token: first_user.token}
      body = json_response(conn, 201)

      assert body["data"]["id"]
    end

    test "renders error when don't have permissions", %{conn: conn} do
      first_user = Fixtures.User.create()
      attrs = Map.put(@create_attrs, :user_id, first_user.id)

      conn = post conn, plan_path(conn, :create), %{plan: attrs, token: first_user.token}
      plan_id = json_response(conn, 201)["data"]["id"]

      second_user = Fixtures.User.create()
      conn = post build_conn(), category_path(build_conn(), :create), %{plan_id: plan_id, name: "some category name", token: second_user.token}

      assert json_response(conn, 401)
    end
  end
end
