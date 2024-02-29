/* Exo 1 */

% 1. Explication :
% -- Définition d'une procédure:
%
% (<x>=proc {$ <x>_1 ... <x>_n} <s> end, E)
%
% On crée un environement contextuel pour la procédure:
% E_c=E|{<z>__>, ..., <z>_n}
% (restriction de E aux identificateurs libres <z>_n se trouvant dans <s>)
%
% On rajoute alors le binding suivant dans la mémoire:
% x=(proc {$ <x>_1 ... <x>_n} <s> end, E_c)
%
% -- Appel d'une procédure
%
% ({<x> <y>_1 ... <y>_n}, E)
% with E(<x>)=(proc {$ <z>_1 ... <z>_n} <s> end, E_c)
%
% On rajoute à la stack sémantique l'instruction:
% (<s>, E_c + {<z>_1->E(<y>_1), ..., <z>_n->E(<y>_n)})

% 2. Etat de mémoire:
% Lors de la définition de P:
%   E={Browse->browse, P->p, Z->z}
%   On va créer l'environment contextuel de la procédure Ec
%   Ec=E|{Z->z}={Z->z}

([
    (local P in ... end, {Browse->browse}),
], {
    browse=(proc {$ X} ... end, ...)
})
=>
([
    (local Z in ... end
     local B A in ... end, {Browse->browse, P->p}),
], {
    browse=(proc {$ X} ... end, ...),
    p
})
=> % sequential composition split
([
    (local Z in ... end, {Browse->browse, P->p}),
    (local B A in ... end, {Browse->browse, P->p}),
], {
    browse=(proc {$ X} ... end, ...),
    p
})
=> % forward two steps (local, seq. composition)
([
    (Z=1, {Browse->browse, P->p, Z->z}),
    (proc {P X Y} Y=X+Z end, {Browse->browse, P->p, Z->z}),
    (local B A in ... end, {Browse->browse, P->p}),
],{
    browse=(proc {$ X} ... end, ...),
    p, z
})
=>
([
    (proc {P X Y} ... end, {Browse->browse, P->p, Z->z}),
    (local B A in ... end, {Browse->browse, P->p}),
],{
    browse=(proc {$ X} ... end, ...),
    p, z=1,
})
=> % Déclaration proc
([
    (local B A in ... end, {Browse->browse, P->p}),
],{
    browse=(proc {$ X} ... end, ...),
    p=(proc {P X Y} Y=X+Z end, {Z->z}),
    z=1,
})
=> % 3 steps: local B, local A, seq. split
([
    (A=10, {Browse->browse, P->p, A->a, B->b}),
    ({P A B}
     {Browse B}, {Browse->browse, P->p, A->a, B->b}),
],{
    browse=(proc {$ X} ... end, ...),
    p=(proc {P X Y} Y=X+Z end, {Z->z}),
    z=1, a, b,
})
=> % 2 steps: assignement, seq. split
([
    ({P A B}, {Browse->browse, P->p, A->a, B->b}),
    ({Browse B}, {Browse->browse, P->p, A->a, B->b}),
],{
    browse=(proc {$ X} ... end, ...),
    p=(proc {P X Y} Y=X+Z end, {Z->z}),
    z=1, a=10, b,
})
=>
([
    (Y=X+Z, {Z->z, X->a, Y->b}),
    ({Browse B}, {Browse->browse, P->p, A->a, B->b}),
],{
    browse=(proc {$ X} ... end, ...),
    p=(proc {P X Y} Y=X+Z end, {Z->z}),
    z=1, a=10, b,
})
=>
([
    ({Browse B}, {Browse->browse, P->p, A->a, B->b}),
],{
    browse=(proc {$ X} ... end, ...),
    p=(proc {P X Y} Y=X+Z end, {Z->z}),
    z=1, a=10, b=11,
})
=> % Application de browse qui imprime E(B)=b=11
([],{
    browse=(proc {$ X} ... end, ...),
    p=(proc {P X Y} Y=X+Z end, {Z->z}),
    z=1, a=10, b=11,
})

/* Exo 2 */

local MakeMulFilter IsPrime Filter L1 MulFilter3 MulFilter2 in
    fun {MakeMulFilter N}
        fun {$ I} (I mod N)==0 end
    end
    fun {Filter L F}
        case L
        of nil then nil
        [] H|T then
            if {F H} then H|{Filter T F}
            else {Filter T F}
            end
        end
    end
    fun {IsPrime N}
        fun {IsDivisible I}
            if I*I > N then true
            elseif (N mod I)==0 then false
            else {IsDivisible I+1}
            end
        end
    in
        if N < 2 then false
        else {IsDivisible 2}
        end
    end
    L1=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]
    MulFilter2={MakeMulFilter 2} % Nombres pairs
    MulFilter3={MakeMulFilter 3} % Multiples de 3
    {Browse {Filter L1 MulFilter2}} % Liste contenant uniquement les nombres pairs
    {Browse {Filter L1 MulFilter3}} % Liste contenant uniquement les multiples de 3
    {Browse {Filter L1 IsPrime}}
end

% http://mozart2.org/mozart-v1/doc-1.4.0/base/list.html
{Browse {List.filter [1 2 3 4 5 6 7 8] fun {$ I} I=<4 end}}
{Browse {List.map [1 2 3 4 5 6 7 8] Number.'~'}}
{Browse {List.foldR [1 2 3 4] fun {$ X Acc} {Browse X#Acc} X*Acc end 1}} % commence par le dernier élement
{Browse {List.foldL [1 2 3 4] fun {$ Acc X} {Browse X#Acc} Acc*X end 1}} % commence par le premier élement


/* Exo 3 */

local
    fun {FoldL L F Acc} % tail-recursive
        case L
        of nil then Acc
        [] H|T then {FoldL T F {F Acc H}}
        end
    end
in
    {Browse {FoldL [1 2 3 4] Number.'*' 1}}
    {Browse {FoldL [1 2 3 4] Number.'-' 0}}
end

local
    fun {FoldR L F Acc} % not tail-recursive
        case L
        of nil then Acc
        [] H|T then {F H {FoldR T F Acc}}
        end
    end
in
    {Browse {FoldR [1 2 3 4] Number.'*' 1}}
    {Browse {FoldR [1 2 3 4] Number.'-' 0}}
end


/* Exo 4 */

local
    fun {Applique Xs F} % C'est la fonction List.map
        case Xs
        of nil then nil
        [] H|T then {F H}|{Applique T F}
        end
    end
    fun {MakePow E}
        fun {$ N}
            {Number.pow N E}
        end
    end
in
    {Browse {Applique [1 2 3 4 5] {MakePow 3}}}
end


/* Exo 5 */

local
    fun {Convertir T O V} T*V + O end
    fun {MakeConverter T O} fun {$ V} {Convertir T O V} end end
    PiedToMeter={MakeConverter 0.3048 0.}
    FahrenheitToCelcius={MakeConverter 0.56 ~17.78}
in
    {Browse {PiedToMeter 1000.}}
    {Browse {FahrenheitToCelcius 100.}}
end

/* Exo 6 */

local
    fun {PipeLine N}
        P1 P2 P3 in
        P1 = {GenerateList N}
        P2 = {MyFilter P1 fun {$ X} X mod 2 \= 0 end}
        P3 = {MyMap P2 fun {$ X} X * X end}
        {MyFoldL P3 fun {$ Acc X} X + Acc end 0}
    end
    fun {GenerateList N}
        if N == 0 then nil
        else N|{GenerateList N-1}
        end
    end
    fun {MyFilter L F}
        case L
        of nil then nil
        [] H|T then
            if {F H} then H|{MyFilter T F}
            else {MyFilter T F}
            end
        end
    end
    fun {MyMap L F}
        case L
        of nil then nil
        [] H|T then {F H}|{MyMap T F}
        end
    end
    fun {MyFoldL L F Acc}
        case L
        of nil then Acc
        [] H|T then {MyFoldL T F {F Acc H}}
        end
    end
in
    {Browse {PipeLine 5}}
end


/* Exo 7 */

local Y LB in
    Y=10
    LB=proc {$ X ?Z} %
        local Cond in %
            Cond=(X>=Y) %
            if Cond then Z=X %
            else Z=Y end
        end
    end
    local Y Z N5 in %
        Y=15 %
        N5=5 %
        {LB N5 Z} %
        {Browse Z}
    end
end

([
    (local Y LB in ... end, {Browse->browse}),
],{
    browse=(proc {$ X} ... end, ...),
})
=> % 3 steps: 2*local, seq. split
([
    (Y=10, {Browse->browse, Y->y, LB->lb}),
    (LB=proc {$ X ?Z} ... end
     local Y Z N5 in ... end, {Browse->browse, Y->y, LB->lb}),
],{
    browse=(proc {$ X} ... end, ...),
    y, lb,
})
=> % 2 steps: assignment, seq. split
([
    (LB=proc {$ X ?Z} ... end, {Browse->browse, Y->y, LB->lb}),
    (local Y Z N5 in ... end, {Browse->browse, Y->y, LB->lb}),
],{
    browse=(proc {$ X} ... end, ...),
    y=10, lb,
})
=>
([
    (local Y Z N5 in ... end, {Browse->browse, Y->y, LB->lb}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
})
=> % 4 steps: 3*local, seq. split
([
    (Y=15, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
    (N5=5
     {LB N5 Z}
     {Browse Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2, z, n5
})
=> % 4 steps: assignment, seq. split, assignment, seq. split
([
    ({LB N5 Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
    ({Browse Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2=15,
    n5=5,
    z,
})
=> % procedure call
([
    (local Cond in
        Cond=(X>=Y)
        if Cond then Z=X
        else Z=Y end
     end, {Y->y, X->n5, Z->z}),
    ({Browse Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2=15,
    n5=5,
    z,
})
=> % 2 steps: ...
([
    (Cond=(X>=Y), {Y->y, X->n5, Z->z, Cond->cond}),
    (if Cond then Z=X
     else Z=Y end, {Y->y, X->n5, Z->z, Cond->cond}),
    ({Browse Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2=15,
    n5=5,
    z,
    cond,
})
=>
([
    (if Cond then Z=X
     else Z=Y end, {Y->y, X->n5, Z->z, Cond->cond}),
    ({Browse Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2=15,
    n5=5,
    z,
    cond=false,
})
=>
([
    (Z=Y, {Y->y, X->n5, Z->z, Cond->cond}),
    ({Browse Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2=15,
    n5=5,
    z,
    cond=false,
})
=>
([
    ({Browse Z}, {Browse->browse, Y->y2, LB->lb, Z->z, N5->n5}),
],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2=15,
    n5=5,
    z=10,
    cond=false,
})
=>
([],{
    browse=(proc {$ X} ... end, ...),
    lb=(proc {$ X ?Z} ... end, {Y->y}),
    y=10,
    y2=15,
    n5=5,
    z=10, % printed
    cond=false,
})


/* (Extra) Conversion de Map en fonction tail récursif */

% fun {Map L F}
%     case L
%     of nil then nil
%     [] H|T then {F H}|{Map T F} % comment rendre cela tail-récursif ?
%     end
% end

local Map in
    Map=proc {$ L F ?R}
        case L of nil then R=nil
        else
            case L of H|T then
                local H2 T2 in
                    R=H2|T2 % On assigne R à des variables 'unbound'
                    {F H H2} % On 'bound' H2
                    {Map T F T2} % On 'bound' T2
                end
            end
        end
    end
    {Browse {Map [1 2 3 4] fun {$ X} X*X end $}} % le $ est du sucre syntaxique, c'est remplacé par un local X in {Map ... X} {Browse X} end
end

% TODO
% la composition fonctionnelle (Compose)
% l'encapsulation (Inc/Zero)
% l'execution retardée (IfTrue)
% structure de controle (While)
