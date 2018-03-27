defmodule BudgetSimpleWeb.ShareView do
  use BudgetSimpleWeb, :view
  alias BudgetSimpleWeb.ShareView

  def render("show.json", %{share: share}) do
    %{data: render_one(share, ShareView, "share.json")}
  end

  def render("share.json", %{share: share}) do
    %{id: share.id}
  end
end
