defmodule Guardian.Backdoor.Mixfile do
  use Mix.Project

  def project do
    [
      app: :guardian_backdoor,
      version: "0.1.0",
      elixir: "~> 1.3.2 or ~> 1.4 or ~> 1.5",
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:guardian, "1.0.0-beta.1"},
      {:plug, "~> 1.3.3 or ~> 1.4"}
    ]
  end
end
