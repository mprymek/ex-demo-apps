defmodule Worker do
  require Logger

  #############################################################################
  # API

  # this runs in supervisor's process
  def start_link do
    Logger.info "#{__MODULE__} starting..."
    pid = spawn_link fn ->
      Process.register self, __MODULE__
      loop nil
    end
    {:ok,pid}
  end

  # all functions below are just convenience functions

  def msg m do
    send __MODULE__, m
    :ok
  end

  def reload, do: msg(:reload)
  def set_state(x), do: msg({:set_state,x})

  #############################################################################
  # PRIVATE

  # this function must be exported because code reloading uses __MODULE__.loop(state) call
  def loop(state) do
    # uncomment this and run Worker.reload
    #Logger.info "#{__MODULE__} WOW! NEW CODE RUNNING!"
    Logger.info "#{__MODULE__} loop, state=#{inspect state}"
    receive do
      {:set_state, x} ->
        loop x

      :tick ->
        Logger.info "#{__MODULE__} tick!"
        # you can use: Process.send_after self, :tick, 2000
        father = self
        spawn fn ->
          :timer.sleep 2000
          send father, :tick
        end
        loop state

      :reload ->
        :code.purge __MODULE__
        Code.load_file "lib/worker.ex"
        __MODULE__.loop state

      :crash ->
        IO.puts "This will not happen! #{1/0}"

      :exit ->
        exit :normal

      any ->
        Logger.info "#{__MODULE__} received #{inspect any}"
        loop state
    end
  end

end

