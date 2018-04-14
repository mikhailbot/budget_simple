defmodule BudgetSimpleWeb.TransactionControllerTest do
  use BudgetSimpleWeb.ConnCase

  import BudgetSimpleWeb.AuthCase
  alias BudgetSimple.Fixtures

  @create_attrs %{date: ~D[2011-10-06], outflow: 1000}
  @invalid_attrs_inflow_outflow %{date: ~D[2011-10-06]}
  @invalid_attrs_date %{outflow: 1000}

  setup %{conn: conn} = config do
    conn = conn |> bypass_through(BudgetSimpleWeb.Router, [:browser]) |> get("/")
    if email = config[:login] do
      user = add_user(email)
      other = add_user("tony@example.com")
      conn = conn |> add_phauxth_session(user) |> send_resp(:ok, "/")
      {:ok, %{conn: conn, user: user, other: other}}
    else
      {:ok, %{conn: conn}}
    end
  end

  @tag login: "reg@example.com"
  test "renders form for new transaction", %{conn: conn, user: user} do
    plan = Fixtures.Plan.create(user)
    account = Fixtures.Account.create(user, plan)

    conn = get(conn, plan_account_transaction_path(conn, :new, plan, account))
    assert html_response(conn, 200) =~ "New Transaction"
  end

  @tag login: "reg@example.com"
  test "lists all entries on index", %{conn: conn, user: user} do
    plan = Fixtures.Plan.create(user)
    account = Fixtures.Account.create(user, plan)

    conn = get(conn, plan_account_transaction_path(conn, :index, plan, account))
    assert html_response(conn, 200) =~ "Listing Transactions"
  end

  @tag login: "reg@example.com"
  test "renders /plans error for unauthorized user", %{conn: conn, other: other}  do
    plan = Fixtures.Plan.create(other)
    account = Fixtures.Account.create(other, plan)

    conn = get(conn, plan_account_transaction_path(conn, :index, plan, account))
    assert html_response(conn, 401)
  end

  @tag login: "reg@example.com"
  test "creates plan when data is valid", %{conn: conn, user: user} do
    plan = Fixtures.Plan.create(user)
    account = Fixtures.Account.create(user, plan)

    conn = post(conn, plan_account_transaction_path(conn, :create, plan, account), transaction: @create_attrs)
    assert html_response(conn, 200) =~ Date.to_string(@create_attrs.date)
  end

  @tag login: "reg@example.com"
  test "does not create transaction when data is invalid", %{conn: conn, user: user} do
    plan = Fixtures.Plan.create(user)
    account = Fixtures.Account.create(user, plan)

    conn = post(conn, plan_account_transaction_path(conn, :create, plan, account), transaction: @invalid_attrs_date)
    assert html_response(conn, 200) =~ "New Transaction"

    conn = post(conn, plan_account_transaction_path(conn, :create, plan, account), transaction: @invalid_attrs_inflow_outflow)
    assert html_response(conn, 200) =~ "New Transaction"
  end
end
