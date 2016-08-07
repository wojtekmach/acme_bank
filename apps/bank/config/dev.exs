use Mix.Config

# TODO: rename DB to bank_*
config :bank, Bank.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "bank_platform_#{Mix.env}",
  hostname: "localhost"

