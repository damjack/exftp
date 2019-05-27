defmodule Exftp.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :exftp,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: "A simple FTP/SFTP Elixir library",
      deps: deps(),
      package: package(),
      # Docs
      name: "Exftp",
      docs: docs()
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
    [
      {:mock, "~> 0.3.0", only: :test},
      {:ex_doc, "~> 0.19", only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["Damiano Giacomello"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/damjack/exftp"}
    ]
  end

  defp docs do
    [
      main: "Exftp",
      source_ref: "v#{@version}",
      groups_for_modules: [
        Exftp,
        Exftp.Connection,
        Exftp.File,
        Exftp.Directory,
        Exftp.Helper,
        Exftp.Error
      ]
    ]
  end
end
