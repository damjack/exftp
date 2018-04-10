defmodule Exftp.Tools do
  require Logger
  alias Exftp.Helper
  alias Exftp.Error

  @doc """
  returns the current working directory
  """
  def working_directory({:ftp, pid}) do
    case :ftp.pwd(pid) do
      {:ok, dir} -> List.to_string(dir)
      e -> handle_error(e)
    end
  end
  def working_directory({:sftp, _, _}) do
    raise "pwd for sftp not implemented"
  end

  @doc """
  change directory
  """
  def change_directory(connection, path)
  def change_directory({:ftp, pid}, path) do
    :ftp.cd(pid, Helper.to_chlist(path))
    |> case do
      {:error, :epath} -> {:error, "cant cd to #{path}, dir does not exist"}
      whatelse -> whatelse
    end
  end
  def change_directory({:sftp, _connection_ref, _pid}, _path) do
    raise "cd for sftp not implemented"
  end

  @doc """
  create directory
  """
  def make_directory({:ftp, pid}, path) do
    :ftp.mkdir(pid, Helper.to_chlist(path))
  end
  def make_directory({:sftp, _, pid}, path) do
    :ssh_sftp.make_dir(pid, Helper.to_chlist(path))
  end

  @doc """
  list files in directory
  will return an list of %{name: filename, type: :directory|:file}
  """
  def list_files({:ftp, pid}) do
    case :ftp.ls(pid) do
      {:ok, listing} -> Helper.parse_ls(List.to_string(listing))
      e -> handle_error(e)
    end
  end
  def list_files({:sftp, _, _pid}) do
    raise "ls without path not implemented in sftp"
  end

  def list_files({:ftp, pid}, path) do
    {:ok, listing} = :ftp.ls(pid, Helper.to_chlist(path))
    Helper.parse_ls(listing |> List.to_string)
  end
  def list_files({:sftp, pid, _}, path) do
    {:ok, list} = :ssh_sftp.list_dir(pid, Helper.to_chlist(path))
    list
    |> Enum.map(&List.to_string/1)
    |> Enum.filter(&(!&1 in [".", ".."]))
    |> Enum.map(fn e ->
      :ssh_sftp.opendir(pid, Helper.to_chlist("#{path}/#{e}"))
      |> case do
        {:ok, handle} ->
          :ssh_sftp.close(pid, handle)
          %{name: e, type: :directory}
        {:error, _} -> %{name: e, type: :file}
      end
    end)
  end

  def is_directory?({:ftp, pid}, _path) do
    :ftp.ls(pid)
    |> case do
      {:ok, list} -> true
      _           -> false
    end
  end
  def is_directory?({:sftp, pid, _}, path) do
    :ssh_sftp.list_dir(pid, Helper.to_chlist(path))
    |> case do
      {:ok, list} -> true
      _           -> false
    end
  end

  @doc """
  getrieve a file
  will return {:ok, binary} or {:error, reason}
  """
  def download({:ftp, pid}, filename) do
    :ftp.type(pid, :binary)
    result = :ftp.recv_bin(pid, Helper.to_chlist(filename))
    :ftp.type(pid, :ascii)
    result
  end

  def download({:sftp, pid, _}, filename) do
    :ssh_sftp.read_file(pid, Helper.to_chlist(filename))
  end

  @doc """
  put a file
  will return :ok or {:error, reason}
  """
  def upload({:ftp, pid}, path, binary) do
    :ftp.type(pid, :binary)
    result = :ftp.send_bin(pid, binary, Helper.to_chlist(path))
    :ftp.type(pid, :ascii)
    result
  end

  defp handle_error(error) do
    message = case error do
      {:error, reason} -> raise %Error{reason: reason}
      _ -> nil
    end
    Logger.error("#{inspect(message)}")
  end
end
