-module(exo2).

-export([voiture/0, run_voiture/0]).

voiture() ->
    receive
        start ->
            io:format("Engine is started~n"),
            voiture();
        move ->
            io:format("I'm moving~n"),
            voiture();
        stop ->
            io:format("Engine is down~n"),
            voiture();
        _ ->
            io:format("Aaah noooo! Kernel Panic~n")
    end.

run_voiture() ->
    Voiture = spawn(?MODULE, voiture, []),
    % Voiture = spawn(?MODULE, voiture, [idle]),
    Voiture ! move,
    Voiture ! start,
    Voiture ! move,
    Voiture ! start,
    Voiture ! move,
    Voiture ! stop,
    Voiture ! stop,
    Voiture ! sdqf,
    Voiture ! start.
