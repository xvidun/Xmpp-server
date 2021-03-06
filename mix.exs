defmodule Spotlight.Mixfile do
  use Mix.Project

  def project do
    [app: :spotlight_api,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Spotlight, []},
     applications: [:phoenix, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :comeonin,
                    :cors_plug, :phoenix_pubsub,
                    :guardian, :ejabberd, :p1_pgsql,
                    :arc_ecto, :httpoison, :poison]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.4"},
     {:p1_utils, "~> 1.0.7"},
     {:relx, "3.22.0"},
     {:exrm, "~> 1.0.8"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.12.1"},
     {:gettext, "~> 0.11"},
     {:comeonin, "~> 2.0"},
     {:guardian, "~> 0.14.4"},
     {:cors_plug, "~> 1.1"},
     {:ejabberd, "~> 16.6"},
     {:p1_pgsql, ">= 1.1.0"},
     {:jose, "~> 1.8"},
     {:cowboy, "~> 1.0"},
     {:arc, "~> 0.8.0"},
     {:arc_ecto, "~> 0.7.0"},
     {:ex_aws, "~> 1.1"},
     {:poison, "~> 2.2.0"},
     {:httpoison, "~> 0.11.1"},
     {:sweet_xml, "~> 0.6"},
     {:phoenix_html, "~> 2.6"},
     {:hackney, "~> 1.7.1"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
