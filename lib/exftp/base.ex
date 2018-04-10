defmodule Exftp.Base do
  require Logger
  alias Exftp.Error

  defp handle_connection([], host, opts) do
    :inets.start
    case :inets.start(:ftpc, Keyword.merge(opts, [host: host])) do
      {:ok, pid} -> user(pid, opts)
      e -> handle_error(e)
    end
  end
  defp handle_connection([mode: :sftp], host, opts) do
    own_keys = [:port, :mode]
    ssh_opts = opts |> Enum.filter(fn({k,_})-> not (k in own_keys) end)
    :ssh.start()
    case :ssh_sftp.start_channel(host, ssh_opts) do
      {:ok, channel_pid, connection_ref} -> {:sftp, channel_pid, connection_ref}
      e -> handle_error(e)
    end
  end

  @doc """
  Open connection to ftp by passing hostname, user and password.
  Returns the pid that has to be passed to execute commands on that connection
  """
  def open_connection(host, opts \\ [])
  def open_connection(host, opts) do
    mode_keys = [:mode]
    Enum.filter(opts, fn({k,_})-> (k in mode_keys) end)
    |> handle_connection(host, opts)
  end

  @doc """
  close the connection
  """
  def close_connection({:sftp, channel, connection}) do
    :ok = :ssh_sftp.stop_channel(channel)
    :ok = :ssh.close(connection)
  end
  def close_connection({:ftp, pid}) do
    :inets.stop(:ftpc, pid)
  end

  @spec user(PID, List.t) :: {:ftp, PID}
  def user(pid, options) do
    case :ftp.user(pid, options[:user], options[:password]) do
      :ok -> {:ftp, pid}
      e -> handle_error(e)
    end
  end

  defp handle_error(error) do
    message = case error do
      {:error, reason} -> raise %Error{reason: reason}
      _ -> nil
    end
    Logger.error("#{inspect(message)}")
  end
end
