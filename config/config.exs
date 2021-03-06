# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :budget_simple,
  ecto_repos: [BudgetSimple.Repo]

# Configures the endpoint
config :budget_simple, BudgetSimpleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RLIGDRXi4jRtMfmAQ1s1SmfwskcL/IHL8pTXZ5QyjfYaotqtfUx8IQP2AcOJWvIZ",
  render_errors: [view: BudgetSimpleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BudgetSimple.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  token_salt: "G7XLuMA3",
  endpoint: BudgetSimpleWeb.Endpoint

# CORS
config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
