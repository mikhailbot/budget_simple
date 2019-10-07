defmodule BudgetSimpleWeb.SessionController do
  use BudgetSimpleWeb, :controller

  import BudgetSimpleWeb.Authorize
  alias BudgetSimple.Accounts
  alias Phauxth.Login

  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]

  # plug :guest_check when action in [:create]

  # If you are using Argon2 or Pbkdf2, add crypto: Comeonin.Argon2
  # or crypto: Comeonin.Pbkdf2 to Login.verify (after Accounts)
  # def create(conn, %{"session" => params}) do
  #   case Login.verify(params, Accounts, crypto: Comeonin.Argon2) do
  #     {:ok, user} ->
  #       token = Phauxth.Token.sign(conn, user.id)
  #       render(conn, "info.json", %{info: token})
  #     {:error, _message} ->
  #       error(conn, :unauthorized, 401)
  #   end
  # end

  def create(conn, %{"user" => user_params}) do
    user = Accounts.get_by(%{email: user_params["email"]})

    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        {:ok, session} = Accounts.create_session(%{user_id: user.id})
        conn
        |> put_status(:created)
        |> render("show.json", token: session.token)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
      true ->
        dummy_checkpw
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
    end
  end
end
