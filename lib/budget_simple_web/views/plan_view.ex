defmodule BudgetSimpleWeb.PlanView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.{CategoryView, PlanView}

  def render("index.json", %{plans: plans}) do
    %{data: %{
        plans: render_many(plans, PlanView, "plan.json")
      }
    }
  end

  def render("show.json", %{plan: plan, categories: categories}) do
    %{data: %{
        plan: render_one(plan, PlanView, "plan.json"),
        categories: CategoryView.render("index.json", %{categories: categories}),
        recentTransactions: []
      }
    }
  end

  def render("plan.json", %{plan: plan}) do
    %{id: plan.id,
      name: plan.name
    }
  end
end
