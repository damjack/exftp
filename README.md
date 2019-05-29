# Exftp

Client FTP to transferring and managing files through remote server

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exftp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exftp, "~> 0.1.0"}
  ]
end
```

Ensure `exftp` is started before your application:

```elixir
def application do
  [applications: [:exftp]]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exftp](https://hexdocs.pm/exftp).

## License

This project is MIT licensed. Please see the [LICENSE](LICENSE.md) file for more details.
