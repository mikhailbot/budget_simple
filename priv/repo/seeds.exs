# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

users = [
  %{email: "jane.doe@example.com", password: "password", first_name: "Jane"},
  %{email: "john.smith@example.org", password: "password", first_name: "John"}
]

for user <- users do
  {:ok, _} = BudgetSimple.Accounts.create_user(user)
end
