defmodule Exftp.Base do
  require Logger
  alias Exftp.Helper

  @spec user(PID, List.t()) :: {:ftp, PID}
  def user(pid, options) do
    case :ftp.user(pid, options[:user], options[:password]) do
      :ok -> {:ftp, pid}
      e -> Helper.handle_error(e)
    end
  end
end
