defmodule Exftp.Helper do
  require Logger
  alias Exftp.Error

  def to_chlist(s) when is_atom(s), do: s
  def to_chlist(s) when is_integer(s), do: s
  def to_chlist(s) when is_bitstring(s), do: String.to_charlist(s)

  def parse_ls(raw) do
    raw
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(&parse_ls_line/1)
  end

  def parse_ls_line(nil, line), do: raise("failed to parse ftp ls line: #{line}")

  def parse_ls_line([_all, type, name], _line) do
    %{
      name: name,
      type:
        case type do
          "d" -> :directory
          _ -> :file
        end
    }
  end

  def parse_ls_line(line) do
    ~r/([di-])[rwx-]{9,9}.+ (.+)/
    |> Regex.run(line)
    |> parse_ls_line(line)
  end

  def base_options(opts, default_opts) do
    Enum.map(opts, fn {k, v} ->
      {k, to_chlist(v)}
    end)
    |> Keyword.merge(default_opts)
  end

  def handle_error(error) do
    message =
      case error do
        {:error, reason} -> raise %Error{reason: reason}
        _ -> nil
      end

    Logger.error("#{inspect(message)}")
  end
end
