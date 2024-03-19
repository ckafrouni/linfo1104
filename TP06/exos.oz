%--------------------------------------------------------------------------%
% États explicites, programmation orientée objet et abstraction de données %
%--------------------------------------------------------------------------%

/* Exo 1 */

local
    fun {Reverse Xs}
        fun {ReverseAux Xs Ys}
            case Xs of nil then Ys
            [] X|Xr then {ReverseAux Xr X|Ys}
            end
        end
    in
        {ReverseAux Xs nil}
    end
in
    {Browse {Reverse [1 2 3 4 5]}}
end

local
    fun {Reverse Xs}
        Cell = {NewCell nil}
    in
        for I in Xs do
            Cell := I|@Cell
        end
        @Cell
    end
in
    {Browse {Reverse [1 2 3 4 5]}}
end

local
    fun {Reverse Xs}
        proc {Loop Xs}
            case Xs of I|Xr then
                Cell := I|@Cell
                {Loop Xr}
            else skip end
        end
        Cell = {NewCell nil}
    in
        {Loop Xs}
        @Cell
    end
in
    {Browse {Reverse [1 2 3 4 5]}}
end


/* Exo 2 */

% Statefull ADT approach

declare
proc {NewWrapper ?Wrap ?Unwrap}
    Key={NewName}
in
    fun {Wrap X}
        fun {$ K} if K==Key then X end end
    end
    fun {Unwrap W}
        {W Key}
    end
end

local
    NewStack Push Pop
    Eval
in
    local Wrap Unwrap in
        {NewWrapper Wrap Unwrap}
        fun {NewStack} {Wrap {NewCell nil}} end
        proc {Push S E} 
            C={Unwrap S} 
        in 
            C:=E|@C
        end
        fun {Pop S} C={Unwrap S} in
            case @C 
            of X|S1 then 
                C:=S1 
                X
            else nil
            end
        end
    end
    % NewStack Push Pop IsEmpty are available here
    %
    fun {Eval E}
        S = {NewStack}
        proc {Loop E}
            case E of nil then skip
            [] H|T then
                case H
                of '+' then {Push S ({Pop S}+{Pop S})}
                [] '-' then {Push S ~({Pop S}-{Pop S})}
                [] '*' then {Push S ({Pop S}*{Pop S})}
                [] '/' then 
                    Y = {Pop S}
                    X = {Pop S} in {Push S (X div Y)}
                else 
                    {Push S H} 
                end
                {Loop T}
            end
        end
    in            
        {Loop E}
        {Pop S}
    end
    %
    {Browse {Eval [13 45 '+' 89 17 '-' '*']}} % affiche 4176 = (13+45)*(89-17)
    {Browse {Eval [13 45 '+' 89 '*' 17 '-']}} % affiche 5145 = ((13+45)*89)-17
    {Browse {Eval [13 45 89 17 '-' '+' '*']}} % affiche 1521 = 13*(45+(89-17))
end


/* Exo 3 */

% Statefull Object approach

local
    fun {NewStack }
        S = {NewCell nil}
        proc {Push X} S := X|@S end
        fun {Pop}
            case @S of nil then nil
            [] H|T then 
                S := T 
                H
            end
        end
        fun {IsEmpty} @S==nil end
    in
        stack(
            isEmpty: IsEmpty
            push: Push
            pop: Pop
        )
    end
    % NewStack is available here
    %
    fun {Eval E}
        S = {NewStack}
        proc {Loop E}
            case E of nil then skip
            [] H|T then
                case H
                of '+' then {S.push ({S.pop}+{S.pop})}
                [] '-' then {S.push ~({S.pop}-{S.pop})}
                [] '*' then {S.push ({S.pop}*{S.pop})}
                [] '/' then 
                    Y = {S.pop}
                    X = {S.pop} in {S.push (X div Y)}
                else 
                    {S.push H} 
                end
                {Loop T}
            end
        end
    in
        {Loop E}
        {S.pop}
    end
in
    {Browse {Eval [13 45 '+'89 17 '-''*']}} % affiche 4176 = (13+45)*(89-17)
    {Browse {Eval [13 45 '+'89 '*'17 '-']}} % affiche 5145 = ((13+45)*89)-17
    {Browse {Eval [13 45 89 17 '-''+''*']}} % affiche 1521 = 13*(45+(89-17))
end


/* Exo 4 */

declare
fun {Random N} {OS.rand} mod N + 1 end

declare
fun {Shuffle Xs}
    Len = {List.length Xs}
    Arr = {NewArray 1 Len _}
    proc {CopyListToArray Xs Arr I}
        case Xs of nil then skip
        [] H|T then 
            Arr.I := H
            {CopyListToArray T Arr I+1}
        end
    end
    fun {FindIndex} I in
        I = {Random Len}
        case Arr.I
        of nil then {FindIndex}
        else I
        end
    end
    fun {ShuffleAux N}
        if N == 0 then nil
        else
            local I X in
                I = {FindIndex}
                X = Arr.I
                Arr.I := nil
                X|{ShuffleAux N-1}
            end
        end
    end
in
    {CopyListToArray Xs Arr 1}
    {ShuffleAux Len}
end
{Browse {Shuffle [a b c d e]}}
{Browse {Shuffle [a b c d e]}}
{Browse {Shuffle [a b c d e]}}


/* Exo 5 */

local
    fun {ToListL1 Xs}
        case Xs of nil then nil
        [] H|T then @H|{ToListL1 T}
        end
    end
    fun {ToListL2 Xs}
        case Xs 
        of nil then nil
        [] H|T then H|{ToListL2 @T}
        end
    end
    %
    fun {InsertL1 X Xs}
        {NewCell X}|Xs
    end
    fun {InsertL2 X Xs}
        X|{NewCell Xs}
    end
    %
    fun {AppendL1 X Xs}
        case Xs of nil then {NewCell X}|nil
        [] H|T then H|{AppendL1 X T}
        end
    end
    fun {AppendL2 X Xs}
        case Xs of nil then X|{NewCell nil}
        [] H|T then H|{NewCell {AppendL2 X @T}}
        end
    end
    %
    fun {Swap12L1 Xs}
        case Xs
        of X1|X2|T then
            X2|X1|T
        else Xs end
    end
    fun {Swap12L2 Xs}
        case Xs
        of X1|T1 then
            case @T1
            of X2|T2 then
                X2|{NewCell X1|T2}
            else Xs end
        else Xs end
    end
    %
    L1={NewCell 0}|{NewCell 1}|{NewCell 2}|nil
    L2=0|{NewCell 1|{NewCell 2|{NewCell nil}}}
in
    {Browse L1}
    {Browse L2}
    {Browse {ToListL1 L1}}
    {Browse {ToListL2 L2}}
    %
    {Browse {ToListL1 {InsertL1 5 L1}}}
    {Browse {ToListL2 {InsertL2 5 L2}}}
    %
    {Browse {ToListL1 {AppendL1 10 L1}}}
    {Browse {ToListL2 {AppendL2 10 L2}}}
    %
    {Browse {ToListL1 {Swap12L1 L1}}}
    {Browse {ToListL2 {Swap12L2 L2}}}
    % Quels sont les complexitées ?
end


%-------------------------------%
% Programmation oritentée objet %
%-------------------------------%

declare
class Counter
    attr value
    meth init % (re)initialise le compteur
        value := 0
    end
    meth inc % incremente le compteur
        value := @value+1
    end
    meth get(X) % renvoie la valeur courante du compteur dans X
        X = @value
    end
end
MonCompteur = {New Counter init}
for _ in 1..5 do {MonCompteur inc} end
{Browse {MonCompteur get($)}} % affiche 5

/* Exo 6 */

declare
class Collection
    attr elements
    meth init % initialise la collection
        elements := nil
    end
    meth put(X) % insere X
        elements := X|@elements
    end
    meth get($) % extrait un element et le renvoie
        case @elements 
        of X|Xr then 
            elements := Xr
            X
        else nil end
    end
    meth isEmpty($) % renvoie true ssi la collection est vide
        @elements == nil
    end
    meth union(C)
        if {Not {C isEmpty($)}} then
            {self put({C get($)})}
            {self union(C)}
        end
    end
    meth browse
        {Browse @elements}
    end
end
C1 C2
in
C1 = {New Collection init}
C2 = {New Collection init}
{C1 put(1)}
{C1 put(2)}
{C1 put(3)}
{C1 browse}
{C2 put(4)}
{C2 put(5)}
{C2 put(6)}
{C2 browse}
{C1 union(C2)}
{C1 browse}
{C2 browse}

declare
class SortedCollection from Collection
    meth get(X)
    end
end

% Complexité de union
%   Collection: ...
%   SortedCollection: ...

/* Exo 7 */

declare
class Expr
    attr valeur
    meth evalue($)
        1
    end
    meth derive(V ?R)
        skip
    end
end
class Variable from Expr
    attr valeur
    meth init(N)
        valeur := N
    end
    meth set(N)
        valeur := N
    end
end
class Constante from Expr
    attr valeur
    meth init(N)
        valeur := N
    end
end
class Somme from Expr
    attr E1 E2
    meth init(E1 E2)
        E1 := E1
        E2 := E2
    end
end
class Difference from Expr
    attr E1
    attr E2
    meth init(E1 E2)
        E1 := E1
        E2 := E2
    end
end
class Produit from Expr
    attr E1
    attr E2
    meth init(E1 E2)
        E1 := E1
        E2 := E2
    end
end
class Puissance from Expr
    attr Base
    attr Exposant
    meth init(Base Exposant)
        Base := Base
        Exposant := Exposant
    end
end

declare
VarX={New Variable init(0)}
VarY={New Variable init(0)}
local
    ExprX2={New Puissance init(VarX 2)}
    Expr3={New Constante init(3)}
    Expr3X2={New Produit init(Expr3 ExprX2)}
    ExprXY={New Produit init(VarX VarY)}
    Expr3X2mXY={New Difference init(Expr3X2 ExprXY)}
    ExprY3={New Puissance init(VarY 3)}
in
    Formule={New Somme init(Expr3X2mXY ExprY3)}
end


local C V1 in
    V1 = 1
    C = {NewCell V1}
    {Browse @C}
    local V2 in
        V2 = 2
        C := V2
        {Browse @C}
    end
    {Browse @C}
end
