defmodule BudgetSimpleWeb.SessionView do
  use BudgetSimpleWeb, :view

  def render("show.json", %{token: token}) do
    %{session_token: token}
  end

  def render("error.json", _) do
    %{errors: "failed to authenticate"}
  end
end
