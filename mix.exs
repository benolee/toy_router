defmodule ToyRouter.Mixfile do
  use Mix.Project

  def project do
    [app: :toy_router,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {ToyRouter, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:vegur, git: "https://github.com/heroku/vegur.git", branch: "master"},
      {:ranch, git: "https://github.com/ninenines/ranch.git", tag: "1.1.0", override: true},
      {:cowlib, git: "https://github.com/ninenines/cowlib.git", tag: "0.4.0", override: true},
      {:uuid, git: "https://github.com/okeuday/uuid.git", tag: "v1.5.0.1", override: true}
    ]
  end
end
