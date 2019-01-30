defmodule PicoSM.MixProject do
  use Mix.Project

  def project do
    [
      app: :pico_sm,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: "https://github.com/fuelen/pico_sm"
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
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    Very small Elixir library for state transitions validation.
    """
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib config .formatter.exs mix.exs README* LICENSE*),
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => "https://github.com/fuelen/pico_sm"}
    ]
  end
end
