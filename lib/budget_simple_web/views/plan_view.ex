defmodule BudgetSimpleWeb.PlanView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.PlanView

  def render("index.json", %{plans: plans}) do
    %{data: %{
        plans: render_many(plans, PlanView, "plan.json")
      }
    }
  end

  def render("show.json", %{plan: plan}) do
    %{data: render_one(plan, PlanView, "plan.json")}
  end

  def render("plan.json", %{plan: plan}) do
    %{id: plan.id,
      name: plan.name,
      owner_id: plan.user.id
    }
  end
end
