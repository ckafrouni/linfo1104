-module(exo4).

-export([start/0, update_stats/2, do_stats/1, beer_manager/1, charlotte/2, student/0,
         build_students/1]).

update_stats({Nb, Min, Max, NbStud}, NbBeer) ->
    {Nb + NbBeer,
     if Min == -1 ->
            NbBeer;
        Min > NbBeer ->
            NbBeer;
        true ->
            Min
     end,
     if Max < NbBeer ->
            NbBeer;
        true ->
            Max
     end,
     NbStud + 1}.

do_stats({Nb, Min, Max, NbStud}) ->
    {Nb, Nb * 1.0 / NbStud, Min, Max, NbStud}.

beer_manager({Nb, Min, Max, NbStud}) ->
    receive
        {From, stats} ->
            From ! {self(), do_stats({Nb, Min, Max, NbStud})},
            beer_manager({Nb, Min, Max, NbStud});
        {From, BeerNb} ->
            From ! {self(), ok},
            beer_manager(update_stats({Nb, Min, Max, NbStud}, BeerNb));
        shutdown ->
            ok
    end.

charlotte([], BeerManager) ->
    BeerManager ! {self(), stats},
    receive
        {BeerManager, Stats} ->
            Stats;
        _ ->
            "error"
    end;
charlotte([Stud | StudQueue], BeerManager) ->
    Stud ! {self(), how_much_beers},
    receive
        {Stud, -1} ->
            charlotte(StudQueue, BeerManager);
        {Stud, Nb} when Nb >= 0 ->
            BeerManager ! {self(), Nb},
            receive
                {BeerManager, ok} ->
                    charlotte(StudQueue, BeerManager);
                _ ->
                    "error"
            end;
        _ ->
            "error"
    end.

student() ->
    receive
        {From, how_much_beers} ->
            From ! {self(), rand:uniform(30)};
        {From, _} ->
            From ! {self(), -1}
    end.

build_students(Tot) ->
    [spawn(?MODULE, student, []) || _ <- lists:seq(1, Tot)].

start() ->
    BM = spawn(?MODULE, beer_manager, [{0, -1, 0, 0}]),
    Students = build_students(98956),
    Result = charlotte(Students, BM),
    BM ! shutdown,
    case Result of
        {Nb, Avg, Min, Max, NbStuds} ->
            io:format("Total Beers: ~p~nAverage: ~p~nMin: ~p~nMax: ~p~nStudents: ~p~n",
                      [Nb, Avg, Min, Max, NbStuds]),
            Result;
        _ ->
            "error"
    end.
