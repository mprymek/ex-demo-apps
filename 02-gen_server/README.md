# Basic (GenServer version)

The same thing as 01-basic but implemented using GenServer.

## run
```
[02-gen_server]$ iex -S mix run
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Compiled lib/basic.ex
lib/worker.ex:43: warning: this expression will fail with ArithmeticError
Compiled lib/worker.ex
Generated basic.app

02:54:22.869 [info]  Elixir.Worker starting...
Interactive Elixir (1.0.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

## message sending
```
iex(1)> send Worker, :blah
:blah

02:55:34.356 [info]  Elixir.Worker received :blah

iex(2)> Worker.msg :blah_blah
:ok

02:55:48.693 [info]  Elixir.Worker received cast :blah_blah
```

## code reloading
In this example, change version number on
[this line](https://github.com/mprymek/ex-demo-apps/blob/master/02-gen_server/lib/worker.ex#L48).
Again, save file and run `Worker.reload`
```
iex(4)> Worker.set_state :some_state
:ok
iex(5)> Worker.print_version
:ok

02:59:41.863 [info]  Elixir.Worker code version 0. state=:some_state
iex(6)> # version number changed now
nil
iex(7)> Worker.reload
lib/worker.ex:1: warning: redefining module Worker
lib/worker.ex:43: warning: this expression will fail with ArithmeticError
:ok

03:00:30.271 [info]  Elixir.Worker code version 1. state=:some_state
```

## best erlang fun - crash a process!
```
iex(8)> Worker.msg :crash
:ok

03:01:45.959 [info]  Elixir.Worker starting...

03:01:45.966 [error] GenServer Worker terminating
Last message: {:"$gen_cast", :crash}
State: :some_state
** (exit) an exception was raised:
    ** (ArithmeticError) bad argument in arithmetic expression
        (basic) lib/worker.ex:43: Worker.handle_cast/2
        (stdlib) gen_server.erl:593: :gen_server.try_dispatch/4
        (stdlib) gen_server.erl:659: :gen_server.handle_msg/5
        (stdlib) proc_lib.erl:237: :proc_lib.init_p_do_apply/3
```

## make process exit normally - booooring...
```
iex(10)> Worker.msg :exit
:ok

03:03:04.219 [info]  Elixir.Worker starting...
```

## starting a dumbest cyclic timer ever
```
iex(11)> Worker.msg :tick

03:03:41.014 [info]  Elixir.Worker tick!
:ok
iex(12)>
03:03:43.015 [info]  Elixir.Worker tick!

03:03:45.018 [info]  Elixir.Worker tick!

03:03:47.024 [info]  Elixir.Worker tick!
```
