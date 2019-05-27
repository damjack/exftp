defmodule Exftp do
  @moduledoc ~S"""
  Client FTP/SFTP to transferring and managing files through remote server

  ## Connection

  In the example above we have connect to host via FTP. Default port is 21.
  If successful, returns a PID. This pid will be passed to the
  authenticate command

  ## Examples

      iex> Exftp.connect("ftp.speedtest.net")
      {:ftp, #PID<0.215.0>}

  ## Connect through SFTP

      iex> Exftp.connect("sftp.speedtest.net", {mode: :sftp})
      {:sftp, #PID<0.215.0>}

  The `connect/2` function accept second parameter with custom data for port,
  username, password and mode.

  ## Examples

      iex> Exftp.connect("ftp.speedtest.net", {mode: :sftp})
      {:sftp, #PID<0.215.0>}

  """

  alias Exftp.{
    Helper,
    Connection,
    Directory,
    File
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

    ## Examples

        iex> Exftp.disconnect(pid)
        :ok

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
    # File.open(pid, remote_path, :read)
  end

  @doc """
    Lists the contents of a directory given a connection a handle or remote path
    Returns {:ok, [Filename]}, or {:error, reason}

    ## Examples

        iex> Exftp.ls(pid)
        [
          %{name: "directory", type: :directory},
          %{name: "filename.ext", type: :file}
        ]

  """
  def ls(pid) do
    File.list_files(pid)
  end

  def ls(pid, remote_path) do
    File.list_files(pid, remote_path)
  end

  @doc """
    Change current working directory

    ## Examples

        iex> Exftp.cd(pid, "directory")
        :ok

  """
  def cd(pid, remote_path) do
    Directory.change_dir(pid, remote_path)
  end

  @doc """
    Get current working directory
    Returns

    ## Examples

        iex> Exftp.pwd(pid)
        "/directory"

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

  @doc """
    Remove remote file
  """
  def rm(pid, file) do
    File.remove_file(pid, file)
  end

  # def rm_dir(pid, remote_path) do
  #   Directory.remove_directory(pid, remote_path)
  # end

  @doc """
    Change name of remote file
  """
  def mv(pid, old_name, new_name) do
    File.move(pid, old_name, new_name)
  end

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
