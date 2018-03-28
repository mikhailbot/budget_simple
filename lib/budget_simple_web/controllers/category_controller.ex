defmodule BudgetSimpleWeb.CategoryController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Budgets

  action_fallback BudgetSimpleWeb.FallbackController

  def create(conn, %{"name" => name, "plan_id" => plan_id}) do
    user = conn.assigns.current_user

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, plan_id) do
      with {:ok, category} <- Budgets.create_category(%{name: name, plan_id: plan_id}) do
        conn
        |> put_status(:created)
        |> render("show.json", category: category)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(BudgetSimpleWeb.ErrorView, "error.json", changeset: changeset)
      end
    end
  end

  def index(conn, %{"plan_id" => plan_id}) do
    user = conn.assigns.current_user

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, plan_id) do
      categories = Budgets.list_categories(plan_id)

      conn
      |> put_status(:ok)
      |> render("index.json", categories: categories)
    end
  end
end
