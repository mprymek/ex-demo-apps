Basic
=====

A basic OTP application with one [worker](https://github.com/mprymek/ex-demo-apps/blob/master/01-basic/lib/worker.ex). Demonstrates:
  * basic messaging
  * supervisor `:one_for_one` strategy
  * hot code reloading
  * KISS periodic timer

## run
```
[01-basic]$ iex -S mix run
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Compiled lib/basic.ex
lib/worker.ex:55: warning: this expression will fail with ArithmeticError
Compiled lib/worker.ex
Generated basic.app

00:33:21.765 [info]  Elixir.Worker starting...
Interactive Elixir (1.0.2) - press Ctrl+C to exit (type h() ENTER for help)

00:33:21.772 [info]  Elixir.Worker loop, state=nil
```

## message sending
```
iex(1)> send Worker, :blah

00:33:31.991 [info]  Elixir.Worker received :blah
:blah

00:33:31.991 [info]  Elixir.Worker loop, state=nil
iex(2)> Worker.msg :blah_blah

00:33:38.580 [info]  Elixir.Worker received :blah_blah
:ok

00:33:38.580 [info]  Elixir.Worker loop, state=nil
```

## code reloading
Note the Worker's state remain intact after reloading. After setting the state, edit the file lib/worker.ex,
uncomment [this line](https://github.com/mprymek/ex-demo-apps/blob/master/01-basic/lib/worker.ex#L33),
save file and run `Worker.reload`
```
iex(3)> Worker.set_state :some_state

00:33:56.636 [info]  Elixir.Worker loop, state=:some_state
:ok
iex(4)> # the line uncommented now...
nil
iex(5)> Worker.reload
:ok
iex(6)> lib/worker.ex:1: warning: redefining module Worker
lib/worker.ex:55: warning: this expression will fail with ArithmeticError

00:34:44.908 [info]  Elixir.Worker WOW! NEW CODE RUNNING!

00:34:44.908 [info]  Elixir.Worker loop, state=:some_state

nil
iex(7)> # the line commented out again...
nil
iex(8)> Worker.reload
:ok
iex(9)> lib/worker.ex:1: warning: redefining module Worker
lib/worker.ex:55: warning: this expression will fail with ArithmeticError

00:35:23.137 [info]  Elixir.Worker loop, state=:some_state
```

## best erlang fun - crash a process!
Note that after crash, the Worker's state is lost...
```
00:35:23.137 [info]  Elixir.Worker loop, state=:some_state

iex(10)> Worker.msg :crash

00:35:58.711 [info]  Elixir.Worker starting...
:ok

00:35:58.714 [error] Error in process <0.95.0> with exit value: {badarith,[{'Elixir.Worker',loop,1,[{file,"lib/worker.ex"},{line,55}]}]}



00:35:58.714 [info]  Elixir.Worker loop, state=nil
```

## make process exit normally - booooring...
```
iex(11)> Worker.msg :exit

00:36:03.182 [info]  Elixir.Worker starting...

00:36:03.182 [info]  Elixir.Worker loop, state=nil
```

## starting a dumbest cyclic timer ever
```
iex(12)> Worker.msg :tick

00:36:30.007 [info]  Elixir.Worker tick!
:ok

00:36:30.007 [info]  Elixir.Worker loop, state=nil
iex(13)>
00:36:32.012 [info]  Elixir.Worker tick!

00:36:32.012 [info]  Elixir.Worker loop, state=nil

00:36:34.014 [info]  Elixir.Worker tick!

00:36:34.014 [info]  Elixir.Worker loop, state=nil

00:36:36.020 [info]  Elixir.Worker tick!

00:36:36.020 [info]  Elixir.Worker loop, state=nil
```

## exit
Press CTRL+C twice.
