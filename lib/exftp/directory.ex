defmodule Exftp.Directory do
  @moduledoc ~S"""
  Manage directory on remote host.
  """

  alias Exftp.Helper

  @doc """
  returns the current working directory
  """
  def working_dir({:ftp, pid}) do
    case :ftp.pwd(pid) do
      {:ok, dir} -> List.to_string(dir)
      e -> Helper.handle_error(e)
    end
  end

  @doc """
  Change directory
  """
  def change_dir({:ftp, pid}, path) do
    :ftp.cd(pid, Helper.to_chlist(path))
    |> case do
      {:error, :epath} -> {:error, "cant cd to #{path}, dir does not exist"}
      whatelse -> whatelse
    end
  end

  @doc """
  Create directory on remote host

  ## Params
    * `pid` - valid PID of current connection
    * `path` - remote absolute path tof new directory

  """
  def make_dir({:ftp, pid}, path) do
    :ftp.mkdir(pid, Helper.to_chlist(path))
  end

  def is_dir?({:ftp, pid}, _path) do
    :ftp.ls(pid)
    |> case do
      {:ok, _list} -> true
      _ -> false
    end
  end
end
