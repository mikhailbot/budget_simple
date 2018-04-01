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

  def render("show.json", %{user: user, plans: plans, shared_plans: shared_plans}) do
    %{
      data: %{
        user: render("user.json", %{user: user}),
        plans: render_many(plans, BudgetSimpleWeb.PlanView, "show.json"),
        shared_plans: render_many(shared_plans, BudgetSimpleWeb.PlanView, "show.json")
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
