use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :budget_simple, BudgetSimpleWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :budget_simple, BudgetSimple.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST"),
  database: "budget_simple_test",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

# Speed up tests
config :argon2_elixir,
  t_cost: 1,
  m_cost: 6


# Comeonin password hashing test config
#config :argon2_elixir,
  #t_cost: 2,
  #m_cost: 8
# config :bcrypt_elixir, log_rounds: 4
#config :pbkdf2_elixir, rounds: 1
