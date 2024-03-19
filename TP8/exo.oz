/* Exo 1 */

declare A B C D
thread D = C+1 end
thread C = B+1 end
thread A = 1 end
thread B = A+1 end
{Browse D}

% La thread principale est executé sequentiellement, soit, les threads sont lancé dans
% l'ordre du programme ci-dessus.

% A -> B -> C -> D

% Multiset Semantic Stack ([], [], [], [])
((
    [D = C+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [C = B+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [A = 1,         {A->a, B->b, C->c, D->d, Browse->browse}], % -> The first one to be executed as
    [B = A+1,       {A->a, B->b, C->c, D->d, Browse->browse}], %    the others all depend on unbound
    [{Browse D},    {A->a, B->b, C->c, D->d, Browse->browse}], %    variables.
), { a, b, c, d, browse=(proc {$ X} ... end, ...) })

% This is not the only possible state.
((
    [D = C+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [C = B+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [A = 1,         {A->a, B->b, C->c, D->d, Browse->browse}], % -> Here we can execute this ST
    [thread B = A+1 end                                        %    Before even doing the sequential
     {Browse D},    {A->a, B->b, C->c, D->d, Browse->browse}], %    split on the following lines.
), { a, b, c, d, browse=(proc {$ X} ... end, ...) })
->
((
    [D = C+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [C = B+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [thread B = A+1 end                                        %    Before even doing the sequential
     {Browse D},    {A->a, B->b, C->c, D->d, Browse->browse}], %    split on the following lines.
), { a=1, b, c, d, browse=(proc {$ X} ... end, ...) })
->
((
    [D = C+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [C = B+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [thread B = A+1 end, {A->a, B->b, C->c, D->d, Browse->browse}], % -> Only one not blocked.
    [{Browse D},    {A->a, B->b, C->c, D->d, Browse->browse}],
), { a=1, b, c, d, browse=(proc {$ X} ... end, ...) })
->
((
    [D = C+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [C = B+1,       {A->a, B->b, C->c, D->d, Browse->browse}],
    [B = A+1,       {A->a, B->b, C->c, D->d, Browse->browse}], % -> Only one not blocked
    [{Browse D},    {A->a, B->b, C->c, D->d, Browse->browse}],
), { a=1, b, c, d, browse=(proc {$ X} ... end, ...) })
-> % ... Only one way to continue


/* Exo 2 */

local X Y Z in
    {Browse threadA}
    thread {Browse thread1} if X==1 then Y=2 else Z=2 end end
    {Browse threadB}
    thread {Browse thread2} if Y==1 then X=1 else Z=2 end end
    {Browse values(X Y Z)}
    {Browse threadC}
    {Delay 1000}
    X=1
    {Delay 1000}
    {Browse values(X Y Z)} % X = 1 -> Y = 2 -> Z = 2
end

((
    [],
), { x=1, y=2, z=2, browse=(proc {$ X} ... end, ...) })

% -- %

local X Y Z in
    thread if X==1 then Y=2 else Z=2 end end
    thread if Y==1 then X=1 else Z=2 end end
    X=2
    {Browse values(X Y Z)} % X = 2 -> Z = 2 -> bloqued (Y = _)
end

((
    [if Y==1 then X=1 else Z=2 end, {X->x, Y->y, Z->z, Browse->browse}], % Blocked
), { x=2, y, z=2, browse=(proc {$ X} ... end, ...) })


/* Exo 3 */


local
    fun {Sum S}
        fun {Aux S Acc}
            case S
            of H|T then
                {Delay 200}
                {Browse 'Consuming : '#H}
                {Aux T H+Acc}
            else 
                {Browse 'Stream closed'}
                Acc
            end
        end
    in
        {Aux S 0}
    end
    fun {ProduceInts N}
        fun {Aux Acc}
            if Acc > N then nil
            else 
                {Browse 'Producing : '#Acc}
                {Delay 200}
                Acc|{Aux Acc+1} end
        end
    in
        {Aux 1}
    end
in
    % Concurent use
    local S R in 
        thread S={ProduceInts 10} end
        thread R={Sum S} end
        {Browse stream#S}
        {Browse result#R}
    end
    %
    % Sequential use
    % local S R in 
    %     S={ProduceInts 10}
    %     R={Sum S} % Waits for the previous instruction to be done.
    %     {Browse stream#S}
    %     {Browse result#R}
    % end
end

% Sequential use
local 
    fun {ProduceInts N}
        fun {Aux Acc}
            if Acc > N then nil
            else 
                {Browse 'Producing : '#Acc}
                {Delay 200}
                Acc|{Aux Acc+1} end
        end
    in
        {Aux 1}
    end
    fun {Sum S} 
        fun {$ Acc X} 
            {Delay 200} {Browse 'Consuming : '#X} 
            Acc+X 
        end 
    end
in
    local S R in 
        thread S={ProduceInts 5} end
        thread R = {List.foldL S {Sum S} 0} end
        {Browse stream#S}
        {Browse result#R}
    end
end


/* Exo 4 */

% 1.
local
    Producer = fun {$ N}
        fun {Aux Acc}
            if Acc > N then nil
            else /*{Browse 'Producing : '#Acc}*/ {Delay 200} Acc|{Aux Acc+1}
            end
        end
    in {Aux 1} end
    %
    FilterOddNumber = fun {$ StrIn}
        case StrIn
        of H|T then
            if H mod 2 == 0 then {FilterOddNumber T}
            else H|{FilterOddNumber T}
            end
        else nil
        end
    end
    %
    Consumer = fun {$ StrIn} 
        {List.foldL 
            StrIn 
            fun {$ Acc X} {Browse 'Consuming : '#X} {Delay 200} Acc+X end 
            0}
    end
in
    local S1 S2 R in
        thread S1={Producer 20} end
        thread S2={FilterOddNumber S1} end
        thread R={Consumer S2} end
        {Browse R}
    end
end

% 2. (Charlotte)
local
    Beers = beers(
        beer(type: trap) 
        beer(type: other)
        beer(type: trap) 
        beer(type: other)
        beer(type: other)
    )
    fun {ServeBeer N}
        NBeers = {Width Beers}
        fun {Random N} {OS.rand} mod N + 1 end
        fun {Aux N}
            if N == 0 then nil
            else
                {Delay 3000}
                local I in
                    I = {Random NBeers}
                    Beers.I|{Aux N-1}
                end
            end
        end
    in {Aux N} end
    fun {Charlotte BeerStream}
        fun {SmellTrappist Beer} Beer.type == trap end
    in
        case BeerStream
        of Beer|T then 
            if {SmellTrappist Beer} then {Browse 'Charlotte'#Beer} {Charlotte T} % Consume Beer
            else Beer|{Charlotte T} end
        else nil end
    end
    fun {Friend BeerStream}
        case BeerStream
        of Beer|T then {Browse 'Friend'#Beer} {Friend T} % Consume Beer
        else nil end
    end
in
    local BeerStream NotTrap Remaining in
        thread BeerStream = {ServeBeer 10} end
        thread NotTrap = {Charlotte BeerStream} end
        thread Remaining = {Friend NotTrap} end
        {Browse Remaining}
    end
end


/* Exo 5 */

local
    Letters = letters(a b c d e f g)
    %
    % Returns a list
    fun {ProduceLetters N}
        NLetters = {Width Letters}
        fun {Random N} {OS.rand} mod N + 1 end
        fun {Aux N}
            if N == 0 then nil
            else
                {Delay 3000}
                local I in
                    I = {Random NLetters}
                    Letters.I|{Aux N-1}
                end
            end
        end
    in {Aux N} end
    %
    fun {Counter Cs}
        fun {UpdateCnt Cnt C}
            case Cnt
            of (X#OccX)|T then 
                if X==C then (X#OccX+1)|T
                else (X#OccX)|{UpdateCnt T C} end
            else C#1|nil end
        end
        % Cnt : [a#1 b#4]
        fun {Aux Cs Cnt}
            case Cs
            of C|T then NewCnt in
                NewCnt = {UpdateCnt Cnt C}
                NewCnt|{Aux T NewCnt}
            else nil end
        end
    in thread {Aux Cs nil} end end
    %
in
    % Usage
    % local InS in
    %     {Browse {Counter InS}}
    %     InS=a|b|a|c|_
    % end
    local Cs Counters in
        thread Cs = {ProduceLetters 5} end
        Counters = {Counter Cs}
        {Browse Counters}
    end
    % TODO 
    % Pourquoi c'est super lent alors qu'il y a
    % pas de Delay ??
end

