defmodule BudgetSimpleWeb.AccountControllerTest do
  use BudgetSimpleWeb.ConnCase

  alias BudgetSimple.Fixtures

  @create_attrs %{name: "some name", type: "credit_card"}
  @invalid_attrs %{name: "some name", type: "bank_account"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when have permissions" do
      user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: user.id})

      conn = post build_conn(), account_path(build_conn(), :create), %{account: @create_attrs, plan_id: plan.id, token: user.token}
      body = json_response(conn, 201)

      assert body["data"]["id"]
      assert body["data"]["name"] == @create_attrs.name
    end

    test "renders error when don't have permissions" do
      first_user = Fixtures.User.create()
      second_user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: first_user.id})

      conn = post build_conn(), account_path(build_conn(), :create), %{account: @create_attrs, plan_id: plan.id, token: second_user.token}
      assert json_response(conn, 401)
    end

    test "renders errors when wrong type" do
      user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: user.id})

      conn = post build_conn(), account_path(build_conn(), :create), %{account: @invalid_attrs, plan_id: plan.id, token: user.token}
      body = json_response(conn, 422)

      assert body["status"] == 422
      assert body["errors"]
    end
  end
end
