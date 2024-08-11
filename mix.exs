defmodule LogicGates.MixProject do
  use Mix.Project

  def project do
    [
      app: :logic_gates,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        # Put the project-level PLT in the priv/ directory (instead of the default _build/ location)
        plt_file: {:no_warn, "priv/plts/project.plt"}

        # The above is equivalent to:
        # plt_local_path: "priv/plts/project.plt"

        # You could also put the core Erlang/Elixir PLT into the priv/ directory like so:
        # plt_core_path: "priv/plts/core.plt"
      ]
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
      {:dialyxir, "~> 1.3", only: [:test], runtime: false}
    ]
  end
end
