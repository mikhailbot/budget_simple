defmodule BudgetSimpleWeb.CategoryController do
  use BudgetSimpleWeb, :controller

  alias BudgetSimple.Budgets
  alias BudgetSimple.Budgets.Category

  action_fallback BudgetSimpleWeb.FallbackController

  def new(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"plan_id" => plan_id}) do
    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, String.to_integer(plan_id)) do
      changeset =
        %Category{plan_id: plan_id}
        |> Budgets.change_category

      plan = Budgets.get_plan!(plan_id)

      render(conn, "new.html", changeset: changeset, plan: plan)
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render(BudgetSimpleWeb.ErrorView, :"404")
    end
  end

  def create(conn, %{"category" => category_params, "plan_id" => plan_id}) do
    user = conn.assigns.current_user
    plan = Budgets.get_plan!(plan_id)
    attrs =
      category_params
      |> Map.put("plan_id", plan_id)
      |> Map.put("user_id", user.id)

    with :ok <- Bodyguard.permit(Budgets, :plan_access, user, plan.id) do
      with {:ok, category} <- Budgets.create_category(user, plan, attrs) do
        render(conn, "show.html", category: category)
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, plan: plan)
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
