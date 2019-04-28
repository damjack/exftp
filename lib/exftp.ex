defmodule Exftp do
  @moduledoc ~S"""
  Manage a FTP or SFTP connection to remote host and manage files.

  ## Connection

  In the example above we have connect to host via FTP. Default port is 21.
  If successful, returns a PID. This pid will be passed to the
  authenticate command

  ## Examples

      iex> Exftp.connect("ftp.speedtest.net")
      #PID<0.158.0>

  The `connect/2` function accept second parameter with custom data for port,
  username, password and mode.

  ## Examples

      iex> Exftp.connect("ftp.speedtest.net", {mode: :sftp})
      #PID<0.158.0>

  """

  alias Exftp.{
    Helper,
    Connection,
    Directory,
    Files
  }

  @default_opts [
    silently_accept_hosts: true,
    timeout: 100_000_000,
    port: 21
  ]

  @doc """
    Creates a PID/Connection struct if the connection is successful,
    else will return {:error, reason}

    ***NOTE: The only required option is ':host'
    Returns {:ok, pid|connection}, or {:error, reason}
  """
  def connect(host, opts \\ []) do
    opts = Helper.base_options(opts, @default_opts)
    Connection.open(Helper.to_chlist(host), opts)
  end

  @doc """
    Clear current PID/Connection struct
  """
  def disconnect(pid) do
    Connection.close(pid)
  end

  @doc """
    Opens a file or directory given a connection and remote_path

    ## Params

      * `pid` - an FTP pid connection
      * `remote_path` - a string

    Returns {:ok, handle}, or {:error, reason}
  """
  def open(_pid, _remote_path) do
    # Files.open(pid, remote_path, :read)
  end

  @doc """
    Lists the contents of a directory given a connection a handle or remote path
    Returns {:ok, [Filename]}, or {:error, reason}
  """
  def ls(pid) do
    Files.list_files(pid)
  end

  def ls(pid, remote_path) do
    Files.list_files(pid, remote_path)
  end

  @doc """
    Change current working directory
  """
  def cd(pid, remote_path) do
    Directory.change_dir(pid, remote_path)
  end

  @doc """
    Get current working directory
    Returns
  """
  def pwd(pid) do
    Directory.working_dir(pid)
  end

  @doc """
    Create new directory into remote_path
    Returns :ok, or {:error, reason}
  """
  def mkdir(pid, remote_path) do
    Directory.make_dir(pid, remote_path)
  end

  # def lstat(pid, remote_path) do
  #   Files.file_info(pid, remote_path)
  # end
  #
  # def rm(pid, file) do
  #   Files.remove_file(pid, file)
  # end
  #
  # def rm_dir(pid, remote_path) do
  #   Files.remove_directory(pid, remote_path)
  # end
  #
  # def mv(pid, old_name, new_name) do
  #   Files.move(pid, old_name, new_name)
  # end

  @doc """
    Download a file given the connection and remote_path
    Returns {:ok, data}, {:error, reason}
  """
  def get(pid, remote_path) do
    File.download(pid, remote_path)
  end

  @doc """
    Uploads data to a remote path via SFTP
    Returns :ok, or {:error, reason}
  """
  def put(pid, remote_path, file_handle) do
    File.upload(pid, remote_path, file_handle)
  end
end
