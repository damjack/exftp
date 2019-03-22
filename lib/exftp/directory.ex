defmodule Exftp.Directory do
  require Logger
  alias Exftp.Helper

  @doc """
  returns the current working directory
  """
  def current({:ftp, pid}) do
    case :ftp.pwd(pid) do
      {:ok, dir} -> List.to_string(dir)
      e -> Helper.handle_error(e)
    end
  end

  def current({:sftp, _, _}) do
    raise "pwd for sftp not implemented"
  end

  @doc """
  change directory
  """
  def change(connection, path)

  def change({:ftp, pid}, path) do
    :ftp.cd(pid, Helper.to_chlist(path))
    |> case do
      {:error, :epath} -> {:error, "cant cd to #{path}, dir does not exist"}
      whatelse -> whatelse
    end
  end

  def change({:sftp, _connection_ref, _pid}, _path) do
    raise "cd for sftp not implemented"
  end

  @doc """
  create directory
  """
  def make({:ftp, pid}, path) do
    :ftp.mkdir(pid, Helper.to_chlist(path))
  end

  def make({:sftp, _, pid}, path) do
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
