use Mix.Config

## Logger
config :logger, level: :debug

## Repo
config :auth, ecto_repos: [Auth.Repo]

import_config "#{Mix.env}.exs"
