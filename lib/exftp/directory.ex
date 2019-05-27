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

  def working_dir({:sftp, _, _}) do
    raise "pwd for sftp not implemented"
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

  def change_dir({:sftp, _connection_ref, _pid}, _path) do
    raise "cd for sftp not implemented"
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

  def make_dir({:sftp, _, pid}, path) do
    :ssh_sftp.make_dir(pid, Helper.to_chlist(path))
  end

  def is_dir?({:ftp, pid}, _path) do
    :ftp.ls(pid)
    |> case do
      {:ok, _list} -> true
      _ -> false
    end
  end

  def is_dir?({:sftp, pid, _}, path) do
    :ssh_sftp.list_dir(pid, Helper.to_chlist(path))
    |> case do
      {:ok, _list} -> true
      _ -> false
    end
  end
end
