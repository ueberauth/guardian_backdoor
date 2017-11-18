defmodule Guardian.Backdoor.Mixfile do
  use Mix.Project

  @version "1.0.0"
  @url "https://github.com/ueberauth/guardian_backdoor"
  @maintainers [
    "Daniel Neighman",
    "Sean Callan",
    "Sonny Scroggin",
  ]

  def project do
    [
      app: :guardian_backdoor,
      version: @version,
      package: package(),
      maintainers: @maintainers,
      description: "A plug to write faster acceptance tests by skipping the sign-in process.",
      homepage_url: @url,
      elixir: "~> 1.4 or ~> 1.5",
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:guardian, "~> 1.0"},
      {:plug, "~> 1.3.3 or ~> 1.4"},

      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package do
    [
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{github: @url},
      files: ~w(lib) ++ ~w(LICENSE mix.exs README.md)
    ]
  end
end
