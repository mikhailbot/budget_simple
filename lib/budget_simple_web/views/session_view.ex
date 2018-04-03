defmodule BudgetSimpleWeb.SessionView do
  use BudgetSimpleWeb, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end
end
