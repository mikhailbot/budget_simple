defmodule BudgetSimpleWeb.SessionController do
  use BudgetSimpleWeb, :controller

  import BudgetSimpleWeb.Authorize
  alias BudgetSimple.Accounts
  alias Phauxth.Login

<<<<<<< HEAD
  plug :guest_check when action in [:create]
=======
  plug :guest_check when action in [:new, :create]
  plug :id_check when action in [:delete]

  def new(conn, _) do
    render(conn, "new.html")
  end
>>>>>>> origin/master

  # If you are using Argon2 or Pbkdf2, add crypto: Comeonin.Argon2
  # or crypto: Comeonin.Pbkdf2 to Login.verify (after Accounts)
  def create(conn, %{"session" => params}) do
    case Login.verify(params, Accounts, crypto: Comeonin.Argon2) do
      {:ok, user} ->
<<<<<<< HEAD
        token = Phauxth.Token.sign(conn, user.id)
        render(conn, "info.json", %{info: token})
      {:error, _message} ->
        error(conn, :unauthorized, 401)
    end
  end
=======
        session_id = Login.gen_session_id("F")
        Accounts.add_session(user, session_id, System.system_time(:second))

        Login.add_session(conn, session_id, user.id)
        |> login_success(user_path(conn, :index))

      {:error, message} ->
        error(conn, message, session_path(conn, :new))
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    <<session_id::binary-size(17), _::binary>> = get_session(conn, :phauxth_session_id)
    Accounts.delete_session(user, session_id)

    delete_session(conn, :phauxth_session_id)
    |> success("You have been logged out", page_path(conn, :index))
  end
>>>>>>> origin/master
end
