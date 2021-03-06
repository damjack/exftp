defmodule Exftp.File do
  @moduledoc ~S"""
  Manage files on remote host.
  """

  alias Exftp.Helper

  @doc """
    List files in current working directory
    will return an list of %{name: filename, type: :directory|:file}
  """
  def list_files({:ftp, pid}) do
    case :ftp.ls(pid) do
      {:ok, listing} -> Helper.parse_ls(List.to_string(listing))
      e -> Helper.handle_error(e)
    end
  end

  @doc """
    List files in custom remote path
    will return an list of %{name: filename, type: :directory|:file}
  """
  def list_files({:ftp, pid}, path) do
    {:ok, listing} = :ftp.ls(pid, Helper.to_chlist(path))
    Helper.parse_ls(listing |> List.to_string())
  end

  @doc """
    Retrieve a file from remote host
    will return {:ok, binary} or {:error, reason}
  """
  def download({:ftp, pid}, filename) do
    :ftp.type(pid, :binary)
    result = :ftp.recv_bin(pid, Helper.to_chlist(filename))
    :ftp.type(pid, :ascii)
    result
  end

  @doc """
    Put a file to remote host
    will return :ok or {:error, reason}
  """
  def upload({:ftp, pid}, path, binary) do
    :ftp.type(pid, :binary)
    result = :ftp.send_bin(pid, binary, Helper.to_chlist(path))
    :ftp.type(pid, :ascii)
    result
  end

  @doc """
    Rename a file to remote host
    will return :ok or {:error, reason}
  """
  def move({:ftp, pid}, old_name, new_name) do
    :ftp.rename(pid, Helper.to_chlist(old_name), Helper.to_chlist(new_name))
  end

  def remove_file({:ftp, pid}, filename) do
    :ftp.delete(pid, Helper.to_chlist(filename))
  end
end
