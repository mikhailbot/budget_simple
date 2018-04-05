defmodule BudgetSimpleWeb.UserView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.UserView

  def render("index.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      firstName: user.first_name}
  end
end
