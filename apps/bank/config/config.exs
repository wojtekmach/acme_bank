use Mix.Config

## Repo

config :bank,
  ecto_repos: [Bank.Repo]

config :bank, Bank.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "bank_web_#{Mix.env}",
  hostname: "localhost"

if Mix.env == :test do
  config :bank, Bank.Repo,
    pool: Ecto.Adapters.SQL.Sandbox
end

## Messenger

config :bank, messenger: Bank.Messenger.Test
