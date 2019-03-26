defmodule Exftp.MixProject do
  use Mix.Project

  def project do
    [
      app: :exftp,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A simple FTP/SFTP Elixir library",
      name: "exftp",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [
      :logger, :ssh, :public_key, :crypto
    ]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:mock, "~> 0.3.0", only: :test}]
  end

  defp package do
    [
      maintainers: ["Damiano Giacomello"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/damjack/exftp"}
    ]
  end
end
