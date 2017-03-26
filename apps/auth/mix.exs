defmodule Auth.Mixfile do
  use Mix.Project

  def project do
    [app: :auth,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [main: "Auth"]]
  end

  def application do
    [applications: [:logger, :ecto, :postgrex],
     mod: {Auth.Application, []}]
  end

  defp deps do
    [{:ecto, "~> 2.0"},
     {:postgrex, ">= 0.0.0"},
     {:comeonin, "~> 2.5"}]
  end
end
