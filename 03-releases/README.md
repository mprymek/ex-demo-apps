# Releases

This code demonstrates Elixir code deployment using self-contained releases (see https://github.com/bitwalker/exrm).

## get dependencies, compile
```
$ mix do deps.get, compile
```

## deploy release 0.0.1
```
$ mix release
```
deploy it:
```
mkdir -p /tmp/03-release/basic
export vsn=0.0.1
cp rel/basic/basic-$vsn.tar.gz /tmp/03-release/
cd /tmp/03-release/basic
tar xzf ../basic-$vsn.tar.gz
ln -s ../../../basic-$vsn.tar.gz releases/$vsn/basic.tar.gz
bin/basic console
```
...version 0.0.1 now runs in this shell.

## deploy release 0.0.2
Leave the 0.0.1 version from previous step running. Change `"0.0.1"` to `"0.0.2"` in `mix.exs`
and `lib/worker.ex` (
[here](https://github.com/mprymek/ex-demo-apps/blob/devel/03-releases/mix.exs#L6) and
[here](https://github.com/mprymek/ex-demo-apps/blob/devel/03-releases/lib/worker.ex#L5))
and create a new release:
```
mix release
export vsn=0.0.2
cp rel/basic/basic-$vsn.tar.gz /tmp/03-release/
cd /tmp/03-release/basic
mkdir releases/$vsn
ln -s ../../../basic-$vsn.tar.gz releases/$vsn/basic.tar.gz
bin/basic upgrade "0.0.2"
```

## bug?!
When I run this code, I get:
```
=CRASH REPORT==== 23-Mar-2015::23:48:58 ===
  crasher:
    initial call: Elixir.Worker:init/1
    pid: <0.58.0>
    registered_name: 'Elixir.Worker'
    exception exit: {#{'__exception__' => true,
                       '__struct__' => 'Elixir.RuntimeError',
                       message => <<"Cannot use Logger, the :logger application is not running">>},
                     [{'Elixir.Logger.Config','__data__',0,
                          [{file,"lib/logger/config.ex"},{line,50}]},
                      {'Elixir.Logger',log,3,
                          [{file,"lib/logger.ex"},{line,401}]},
                      {'Elixir.Worker',handle_info,2,
                          [{file,"lib/worker.ex"},{line,31}]},
                      {gen_server,try_dispatch,4,
                          [{file,"gen_server.erl"},{line,593}]},
                      {gen_server,handle_msg,5,
                          [{file,"gen_server.erl"},{line,659}]},
                      {proc_lib,init_p_do_apply,3,
                          [{file,"proc_lib.erl"},{line,237}]}]}
      in function  gen_server:terminate/7 (gen_server.erl, line 804)
    ancestors: ['Elixir.Basic.Supervisor',<0.56.0>]
    messages: []
    links: [<0.57.0>]
    dictionary: []
    trap_exit: false
    status: running
    heap_size: 610
    stack_size: 27
    reductions: 5944
  neighbours:
```

If I change `Logger.info` to `IO.puts` [here](https://github.com/mprymek/ex-demo-apps/blob/devel/03-releases/lib/worker.ex#L31), everything is ok.
