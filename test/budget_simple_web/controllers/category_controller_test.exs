defmodule BudgetSimpleWeb.CategoryControllerTest do
  use BudgetSimpleWeb.ConnCase

  import BudgetSimpleWeb.AuthCase
  alias BudgetSimple.Fixtures

  @create_attrs %{name: "some name"}
  @invalid_attrs %{name: nil}

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
  test "renders form for new category", %{conn: conn, user: user} do
    plan = Fixtures.Plan.create(user)

    conn = get(conn, plan_category_path(conn, :new, plan))
    assert html_response(conn, 200) =~ "New Category"
  end

  @tag login: "reg@example.com"
  test "renders /plans/category error for unauthorized user", %{conn: conn, other: other}  do
    plan = Fixtures.Plan.create(other)

    conn = get(conn, plan_category_path(conn, :new, plan))
    assert html_response(conn, 404) =~ "Not Found"
  end

  @tag login: "reg@example.com"
  test "creates category when valid", %{conn: conn, user: user} do
    plan = Fixtures.Plan.create(user)

    conn = post(conn, plan_category_path(conn, :create, plan, category: @create_attrs))
    assert html_response(conn, 200) =~ @create_attrs.name
  end

  @tag login: "reg@example.com"
  test "does not create category when invalid", %{conn: conn, user: user} do
    plan = Fixtures.Plan.create(user)

    conn = post(conn, plan_category_path(conn, :create, plan, category: @invalid_attrs))
    assert html_response(conn, 200) =~ "New Category"
  end
end
