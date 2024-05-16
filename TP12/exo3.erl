-module(exo3).

-export([main/0, pow/0, pow/2]).

pow(_, 0) ->
    1;
pow(Base, Exp) ->
    Base * pow(Base, Exp - 1).

pow() ->
    receive
        {Pid, Base, Exp} ->
            Pid ! pow(Base, Exp)
    end,
    pow().

sum_pow2(PowPid, Start, End, Acc) when Start =< End ->
    PowPid ! {self(), Start, 2},
    receive
        Result ->
            sum_pow2(PowPid, Start + 1, End, Acc + Result)
    end;
sum_pow2(_, _, _, Acc) ->
    Acc.

sum_pow2(Start, End) ->
    PowPid = spawn(?MODULE, pow, []),
    sum_pow2(PowPid, Start, End, 0).

main() ->
    io:format("A"),
    Sum = sum_pow2(1, 100),
    io:format("B"),

    io:format("Sum of x^2 ~p~n", [Sum]).
