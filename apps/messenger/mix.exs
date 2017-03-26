defmodule Messenger.Mixfile do
  use Mix.Project

  def project do
    [app: :messenger,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: ">= 1.4.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [main: "Messenger"]]
  end

  def application do
    [applications: [:logger],
     mod: {Messenger.Application, []}]
  end

  defp deps do
    []
  end
end
