defmodule LogicGates.MixProject do
  use Mix.Project

  def project do
    [
      app: :logic_gates,
      name: "Logic Gates",
      version: "0.7.2",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      dialyzer: dialyzer(),
      source_url: "https://github.com/ordermind/logic-gates-elixir"
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
      {:dialyxir, "~> 1.3", only: [:test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "logic_gates",
      # These are the default files included in the package
      files: ~w(lib mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ordermind/logic-gates-elixir"}
    ]
  end

  defp description() do
    "Provides logic gates such as AND and OR to be used by other libraries."
  end

  defp dialyzer() do
    [
      # Put the project-level PLT in the priv/ directory (instead of the default _build/ location)
      plt_file: {:no_warn, "priv/plts/project.plt"}
    ]
  end
end
