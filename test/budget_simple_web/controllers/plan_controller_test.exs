defmodule BudgetSimpleWeb.PlanControllerTest do
  use BudgetSimpleWeb.ConnCase

  import BudgetSimpleWeb.AuthCase

  @create_attrs %{name: "plan name"}
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

  test "renders form for new plans", %{conn: conn} do
    conn = get(conn, plan_path(conn, :new))
    assert html_response(conn, 200) =~ "New Plan"
  end

  @tag login: "reg@example.com"
  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, plan_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing Plans"
  end

  test "renders /plans error for unauthorized user", %{conn: conn}  do
    conn = get(conn, plan_path(conn, :index))
    assert redirected_to(conn) == session_path(conn, :new)
  end

  @tag login: "reg@example.com"
  test "creates plan when data is valid", %{conn: conn} do
    conn = post(conn, plan_path(conn, :create), plan: @create_attrs)
    assert html_response(conn, 200) =~ @create_attrs.name
  end

  @tag login: "reg@example.com"
  test "does not create plan when data is invalid", %{conn: conn} do
    conn = post(conn, plan_path(conn, :create), plan: @invalid_attrs)
    assert html_response(conn, 200) =~ "New Plan"
  end
end
