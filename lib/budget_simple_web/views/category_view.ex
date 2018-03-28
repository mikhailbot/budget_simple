defmodule BudgetSimpleWeb.CategoryView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.CategoryView

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name
    }
  end
end
