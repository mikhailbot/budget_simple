defmodule BudgetSimpleWeb.UserController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Accounts

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params), {:ok, session} <- Accounts.create_session(%{user_id: user.id}) do
      conn
        |> put_status(:created)
        |> render("show.json", %{user: user, session: session})
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BudgetSimpleWeb.ErrorView, "error.json", changeset: changeset)
    end
  end
end
