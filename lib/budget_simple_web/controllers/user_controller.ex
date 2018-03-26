defmodule BudgetSimpleWeb.UserController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Accounts

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BudgetSimpleWeb.ErrorView, "error.json", changeset: changeset)
    end
  end
end
