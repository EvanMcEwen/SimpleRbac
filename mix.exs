defmodule SimpleRbac.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_rbac,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      description: "A very simple role based access control (RBAC) library for Phoenix LiveView applications.",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev], runtime: false},
      {:phoenix_ecto, "~> 4.6"},
      {:ecto_sql, "~> 3.12"}
    ]
  end
end
