defmodule BankPlatform.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     version: "1.0.0-dev",
     source_url: "https://github.com/wojtekmach/acme_bank",
     name: "Acme Bank",
     docs: [source_ref: "HEAD", main: "main", assets: "docs", extras: ["docs/main.md"]],
     deps: deps(),
     aliases: aliases()]
  end

  defp deps do
    [{:ex_doc, github: "elixir-lang/ex_doc", branch: "master", only: :dev}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
     "ecto.seed": ["run apps/bank/priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
