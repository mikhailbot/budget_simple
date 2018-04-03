defmodule BudgetSimpleWeb.AuthCase do
  use Phoenix.ConnTest

  alias BudgetSimple.Accounts

  def add_user(email) do
    user = %{email: email, password: "reallyHard2gue$$"}
    {:ok, user} = Accounts.create_user(user)
    user
  end

  def add_token_conn(conn, user) do
    user_token = Phauxth.Token.sign(BudgetSimpleWeb.Endpoint, user.id)
    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", user_token)
  end

  def gen_key(email) do
    Phauxth.Token.sign(BudgetSimpleWeb.Endpoint, %{"email" => email})
  end
end
