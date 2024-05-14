-module(tutorial).

-export([main/1, greet/1, produce_list/0, add/2, factorial/1]).

% The -module and -export directives aren't necessary if running from escript
% But they are necessary if running from the Erlang shell or compiled

greet(Name) ->
    io:fwrite("Hello ~s~n", [Name]).

% List comprehensions
produce_list() ->
    N = [1, 2, 3, 4, 5],
    [10 * X * Y || X <- N, Y <- N, X < Y].

% Multiple function clauses (name and arity must match)
add(X, Y) when is_integer(X), is_integer(Y) ->
    X + Y;
add(X, Y) when is_float(X), is_float(Y) ->
    X + Y;
add(X, Y) when is_list(X), is_list(Y) ->
    X ++ Y;
add(_, _) ->
    {error, "The types aren't supported!"}.

% Tail recursion (we only export the function with one argument)
factorial(N) when N > 0 ->
    factorial(N, 1).

factorial(0, Acc) ->
    Acc;
factorial(N, Acc) ->
    factorial(N - 1, N * Acc).

% The main function is called when the module is run as a script
main(_) ->
    greet("World"),
    io:fwrite("~p~n", [produce_list()]),
    io:fwrite("~p~n", [add(1, 2)]),
    io:fwrite("~p~n", [add(1.0, 2.0)]),
    io:fwrite("~p~n", [add("Hello, ", "World")]),
    io:fwrite("~p~n", [add(1, 2.0)]),
    io:fwrite("~p~n", [add([1, 2], [3, 4])]).
