defmodule Worker do
  require Logger
  use GenServer

  #############################################################################
  # API

  # code swap is done by GenServer callback calls, we don't need to call
  # __MODULE__.xxx explicitly.
  def reload do
    :code.purge __MODULE__
    Code.load_file "lib/worker.ex"
    print_version
  end

  # all functions below are just convenience functions

  def msg(m), do: GenServer.cast(Worker,m)
  def set_state(x), do: msg({:set_state,x})
  def print_version, do: msg(:print_version)

  #############################################################################
  # GenServer callbacks

  # this still runs in a caller's process, we will be detached later
  def start_link do
    Logger.info "#{__MODULE__} starting..."
    {:ok, _} = GenServer.start_link Worker, [], name: Worker
  end

  def handle_cast({:set_state,x}, _state), do: {:noreply,x}

  def handle_cast(:tick, state) do
    Logger.info "#{__MODULE__} tick!"
    father = self
    spawn fn ->
      :timer.sleep 2000
      GenServer.cast father, :tick
    end
    {:noreply,state}
  end

  def handle_cast(:crash, _state), do: IO.puts("This will not happen! #{1/0}")

  def handle_cast(:exit, _state), do: exit(:normal)

  def handle_cast(:print_version, state) do
    Logger.info "#{__MODULE__} code version 0. state=#{inspect state}"
    {:noreply,state}
  end

  # note simple send(pid,x) messages are handled by handle_info in GenServer
  # GenServer.cast messages are handled here
  def handle_cast(any, state) do
    Logger.info "#{__MODULE__} received cast #{inspect any}"
    {:noreply, state}
  end

  def handle_info(any, state) do
    Logger.info "#{__MODULE__} received #{inspect any}"
    {:noreply, state}
  end

end
