defmodule BudgetSimpleWeb.UserControllerTest do
  use BudgetSimpleWeb.ConnCase

  @valid_attrs %{email: "some email", password: "some encrypted_password", first_name: "some first_name"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["data"]["user"]["id"]
    assert body["data"]["user"]["email"]
    refute body["data"]["user"]["password"]
    assert body["data"]["session"]["token"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

end
