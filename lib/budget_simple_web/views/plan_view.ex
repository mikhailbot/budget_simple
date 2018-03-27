defmodule BudgetSimpleWeb.PlanView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.PlanView

  def render("index.json", %{plans: plans, shared_plans: shared_plans}) do
    %{data: %{
        plans: render_many(plans, PlanView, "plan.json"),
        shared_plans: render_many(shared_plans, PlanView, "plan.json")
      }
    }
  end

  def render("show.json", %{plan: plan}) do
    %{data: render_one(plan, PlanView, "plan.json")}
  end

  def render("plan.json", %{plan: plan}) do
    %{id: plan.id,
      name: plan.name}
  end
end
