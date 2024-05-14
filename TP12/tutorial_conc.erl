-module(tutorial_conc).

-export([start/0, loop/0]).

start() ->
    spawn(fun loop/0).

loop() ->
    receive
        Msg ->
            io:format("Pid: ~p, Msg: ~p~n", [self(), Msg]),
            loop()
    end.
