defmodule Exftp.Connection do
  require Logger
  alias Exftp.Helper

  @spec auth(PID, List.t()) :: {:ftp, PID}
  def auth(pid, []), do: {:ftp, pid}

  def auth(pid, options) do
    case :ftp.user(pid, options[:user], options[:password]) do
      :ok -> {:ftp, pid}
      e -> Helper.handle_error(e)
    end
  end

  defp handle_open([], host, opts) do
    :inets.start()

    case :inets.start(:ftpc, Keyword.merge(opts, host: host)) do
      {:ok, pid} -> auth(pid, opts)
      e -> Helper.handle_error(e)
    end
  end

  defp handle_open([mode: :sftp], host, opts) do
    own_keys = [:port, :mode]
    ssh_opts = opts |> Enum.filter(fn {k, _} -> not (k in own_keys) end)
    :ssh.start()

    case :ssh_sftp.start_channel(host, ssh_opts) do
      {:ok, channel_pid, connection_ref} -> {:sftp, channel_pid, connection_ref}
      e -> Helper.handle_error(e)
    end
  end

  @doc """
  Open connection to ftp by passing hostname, user and password.
  Returns the pid that has to be passed to execute commands on that connection
  """
  def open(host, opts \\ [])

  def open(host, opts) do
    mode_keys = [:mode]

    Enum.filter(opts, fn {k, _} -> k in mode_keys end)
    |> handle_open(host, opts)
  end

  @doc """
  close the connection
  """
  def close({:sftp, channel, connection}) do
    :ok = :ssh_sftp.stop_channel(channel)
    :ok = :ssh.close(connection)
  end

  def close({:ftp, pid}) do
    :inets.stop(:ftpc, pid)
  end
end
