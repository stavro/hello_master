defmodule HelloMaster.SlaveNode do
  def start(host) do
    allow_boot(host)
    {:ok, slave} = :slave.start(host, :slave, inet_loader_args)
    load_paths(slave)
    {:ok, slave}
  end

  def call(slave, module, method, args) do
    :rpc.block_call(slave, module, method, args)
  end

  defp inet_loader_args do
    "-loader inet -hosts #{master_node_ip} -setcookie #{:erlang.get_cookie}" |> to_char_list
  end

  defp allow_boot(host) do
    {:ok, ipv4} = :inet.parse_ipv4_address(host)
    :erl_boot_server.add_slave(ipv4)
  end

  defp load_paths(slave) do
    :rpc.block_call(slave, :code, :add_paths, [:code.get_path])
  end

  defp master_node_ip do
    node()
    |> to_string
    |> String.split("@")
    |> Enum.at(1)
    |> to_char_list
  end
end
