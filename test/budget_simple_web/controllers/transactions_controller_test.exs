defmodule BudgetSimpleWeb.TransactionControllerTest do
  use BudgetSimpleWeb.ConnCase

  alias BudgetSimple.Fixtures

  @create_attrs %{date: "2011-10-06T02:48:00.000Z", outflow: 1000}
  @invalid_attrs %{outflow: 1000}
  @update_attrs %{inflow: 1000}

  describe "create transaction" do
    test "renders transaction when have permissions" do
      user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: user.id})

      conn = post build_conn(), transaction_path(build_conn(), :create), %{transaction: @create_attrs, plan_id: plan.id, token: user.token}
      body = json_response(conn, 201)

      assert body["data"]["id"]
    end

    test "renders error when don't have permissions" do
      first_user = Fixtures.User.create()
      second_user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: first_user.id})

      conn = post build_conn(), transaction_path(build_conn(), :create), %{transaction: @create_attrs, plan_id: plan.id, token: second_user.token}
      assert json_response(conn, 401)
    end

    test "renders error when don't have a date" do
      user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: user.id})

      conn = post build_conn(), transaction_path(build_conn(), :create), %{transaction: @invalid_attrs, plan_id: plan.id, token: user.token}
      body = json_response(conn, 422)

      assert body["status"] == 422
      assert body["errors"]
    end
  end

  describe "update transaction" do
    test "renders transaction when have permissions" do
      user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: user.id})
      transaction = Fixtures.Transaction.create(%{user_id: user.id, plan_id: plan.id})

      conn = patch build_conn(), transaction_path(build_conn(), :update, transaction.id), %{transaction: @update_attrs, plan_id: plan.id, token: user.token}
      body = json_response(conn, 202)

      assert body["data"]["id"] == transaction.id
      assert body["data"]["outflow"] == transaction.outflow
      assert body["data"]["inflow"] == @update_attrs.inflow
    end

    test "renders error when don't have permissions" do
      first_user = Fixtures.User.create()
      second_user = Fixtures.User.create()
      plan = Fixtures.Plan.create(%{user_id: first_user.id})
      transaction = Fixtures.Transaction.create(%{user_id: first_user.id, plan_id: plan.id})

      conn = patch build_conn(), transaction_path(build_conn(), :update, transaction.id), %{transaction: @update_attrs, plan_id: plan.id, token: second_user.token}
      assert json_response(conn, 401)
    end
  end
end
