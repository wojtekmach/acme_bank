# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backoffice,
  ecto_repos: [Backoffice.Repo]

# Configures the endpoint
config :backoffice, Backoffice.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oqP7+8kIDrpIetIPddC3hf7pmNxOZbTjqUpWkR6nsvJelI7kfR7bhaBE0PP9pdDa",
  render_errors: [view: Backoffice.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Backoffice.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

config :ex_admin,
  repo: Bank.Repo,
  module: Backoffice,
  modules: [
    Backoffice.ExAdmin.Dashboard,
    Backoffice.ExAdmin.Bank.Ledger.Account,
    Backoffice.ExAdmin.Bank.Ledger.Entry,
  ]
