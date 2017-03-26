defmodule Money.Mixfile do
  use Mix.Project

  def project do
    [app: :money,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: ">= 1.4.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [main: "Money"]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ecto, "~> 2.0", optional: true},
     {:phoenix_html, "~> 2.6", optional: true},
     {:plug, "~> 1.2", optional: true}]
  end
end
