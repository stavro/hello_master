defmodule HelloMaster.Echo do
  use GenServer

  #
  # Public interface
  #

  def start_link(options \\ []) do
    :gen_server.start_link(__MODULE__, options, [])
  end

  def hello(pid) do
    :gen_server.call(pid, :hello)
  end

  #
  # Internal interface
  #

  def init(options) do
    {:ok, nil}
  end

  def handle_call(:hello, _from, _state) do
    {:reply, {:ok, "Hello from #{node()}"}, _state}
  end
end