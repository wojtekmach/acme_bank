# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backoffice,
  ecto_repos: []

# Configures the endpoint
config :backoffice, Backoffice.Endpoint,
  url: [host: "localhost", path: "/"],
  static_url: [host: "localhost", path: "/backoffice"],
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
  # TODO: for now, all DB operations go through Bank.Repo, even managing
  #       Auth.Account etc (which should be done through Auth.Repo).
  #       This works, because both Repos use the same DB. (which happens
  #       to be also useful for Heroku deployment.)
  #
  #       See: https://github.com/smpallen99/ex_admin/issues/138 for a
  #       proper multi-repo support in ExAdmin.
  repo: Bank.Repo,

  module: Backoffice,
  modules: [
    Backoffice.ExAdmin.Dashboard,

    Backoffice.ExAdmin.Bank.Customer,
    Backoffice.ExAdmin.Bank.LedgerAccount,
    Backoffice.ExAdmin.Bank.Ledger.Entry,

    Backoffice.ExAdmin.AuthAccount,
  ]
