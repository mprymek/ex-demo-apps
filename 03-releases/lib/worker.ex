defmodule Worker do
  require Logger
  use GenServer

  @version "0.0.1"
  @regname __MODULE__

  #############################################################################
  # API

  def tick, do: send(@regname,:tick)
  def version, do: @version

  #############################################################################
  # GenServer callbacks

  # this still runs in a caller's process, we will be detached later
  def start_link do
    Logger.info "#{__MODULE__} starting..."
    {:ok, _} = GenServer.start_link __MODULE__, [], name: @regname
  end

  # now, we are in the worker's process...
  def init(opts) do
    # start timer
    tick
    {:ok,opts}
  end

  def handle_info(:tick, state) do
    Logger.info "#{__MODULE__} tick! vsn=#{inspect @version} self=#{inspect self}"
    Process.send_after self, :tick, 5000
    {:noreply,state}
  end

  def code_change(old_vsn, state, extra) do
    IO.puts "#{__MODULE__}.code_change old_vsn=#{inspect old_vsn} extra=#{inspect extra}"
    {:ok, state}
  end

end
