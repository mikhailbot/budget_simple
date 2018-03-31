# defmodule BudgetSimple.Fixtures.User do
#   alias BudgetSimple.Accounts

#   def create(attrs \\ %{}) do
#     attrs =
#       attrs
#       |> Enum.into(%{email: Faker.Internet.email, password: "some encrypted_password", first_name: "some first_name"})

#     with {:ok, user} <- Accounts.create_user(attrs), {:ok, session} <- Accounts.create_session(%{user_id: user.id}) do
#       user
#       |> Map.put(:token, session.token)
#     end
#   end
# end
