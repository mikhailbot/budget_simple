defmodule BudgetSimpleWeb.UserView do
  use BudgetSimpleWeb, :view

  def render("show.json", %{user: user, session: session}) do
    %{
      data: %{
        user: render("user.json", %{user: user}),
        session: render("session.json", %{session: session})
      }
    }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end

  def render("session.json", %{session: session}) do
    %{token: session.token}
  end
end
