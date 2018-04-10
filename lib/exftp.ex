defmodule Exftp do
  @moduledoc """
  Functions for transferring and managing files through FTP/SFTP
  """
  alias Exftp.Helper
  alias Exftp.Base
  alias Exftp.Tools

  @default_opts [
    silently_accept_hosts: true,
    timeout: 1000000000,
    port: 21
  ]

  @doc """
    Creates a Pid/Connection struct if the connection is successful,
    else will return {:error, reason}

    ***NOTE: The only required option is ':host'
    Returns {:ok, pid|connection}, or {:error, reason}
  """
  def connect(host, opts \\ []) do
    opts =
      Enum.map(opts, fn {k ,v} ->
          {k, Helper.to_chlist(v)}
        end)
    opts =
      @default_opts
      |> Keyword.merge(opts)
    Base.open_connection(Helper.to_chlist(host), opts)
  end

  def disconnect(pid) do
    Base.close_connection(pid)
  end

  @doc """
    Opens a file or directory given a connection and remote_path
    Returns {:ok, handle}, or {:error, reason}
  """
  def open(pid, remote_path) do
    # Tools.open(pid, remote_path, :read)
  end

  @doc """
    Lists the contents of a directory given a connection a handle or remote path
    Returns {:ok, [Filename]}, or {:error, reason}
  """
  def ls(pid) do
    Tools.list_files(pid)
  end
  def ls(pid, remote_path) do
    Tools.list_files(pid, remote_path)
  end

  def cd(pid, remote_path) do
    Tools.change_directory(pid, remote_path)
  end

  def pwd(pid) do
    Tools.working_directory(pid)
  end

  @doc """
    Create new directory into remote_path
    Returns :ok, or {:error, reason}
  """
  def mkdir(pid, remote_path) do
    Tools.make_directory(pid, remote_path)
  end

  # def lstat(pid, remote_path) do
  #   Tools.file_info(pid, remote_path)
  # end
  #
  # def rm(pid, file) do
  #   Tools.remove_file(pid, file)
  # end
  #
  # def rm_dir(pid, remote_path) do
  #   Tools.remove_directory(pid, remote_path)
  # end
  #
  # def move(pid, old_name, new_name) do
  #   Tools.move(pid, old_name, new_name)
  # end

  @doc """
    Download a file given the connection and remote_path
    Returns {:ok, data}, {:error, reason}
  """
  def get(pid, remote_path) do
    Tools.download(pid, remote_path)
  end

  @doc """
    Uploads data to a remote path via SFTP
    Returns :ok, or {:error, reason}
  """
  def put(pid, remote_path, file_handle) do
    Tools.upload(pid, remote_path, file_handle)
  end
end
