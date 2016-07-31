use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :bank, ecto_repos: [Bank.Repo]

import_config "#{Mix.env}.exs"
