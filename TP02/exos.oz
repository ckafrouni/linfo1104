/* Exo 1 */
local 
    L1=a|nil
    L2=a|(b|c|nil)|d|nil
    L3= proc {$} {Browse oui} end | proc {$} {Browse non} end | nil
    L4=est|une|liste|nil
    L5=(a|p|nil)|nil
    L4bis=ceci|L4
in
    {Browse L1}
    {Browse L2}
    {Browse L3}
    {Browse L4}
    {Browse L5}
    {Browse L4bis}
    {Browse L2.2}
    {L3.1 }
end

declare
fun {Head Xs} Xs.1 end
fun {Tail Xs} Xs.2 end

{Browse {Head [a b c]}}
{Browse {Tail [a b c]}}

/* Exo 2 */

local
    fun {Length Xs}
        fun {Inner Xs Acc}
            case Xs
            of nil then Acc
            [] H|T then {Inner T  Acc+1}
            end
        end
    in
        {Inner Xs 0}
    end
in
    {Browse {Length [r a p h]}} % affiche 4
    {Browse {Length [[b o r] i s]}} % affiche 3
    {Browse {Length [[l u i s]]}} % affiche 1
    {Browse {Length nil}} % affiche 0
end

/* Exo 3 */

local
    fun {Append Xs Ys}
        case Xs
        of nil then Ys
        [] H|T then H|{Append T Ys}
        end
    end
in
    {Browse {Append [r a] [p h]}} % affiche [r a p h]
    {Browse {Append [b [o r]] [i s]}} % affiche [b [o r] i s]
    {Browse {Append nil [l u i s]}} % affiche [l u i s]
end

/* Exo 4 */

declare
fun {IsList Xs}
    {Browse Xs}
    case Xs
    of nil then empty
    [] H|T then nonEmpty
    else other
    end
end
{Browse {IsList 1}}
{Browse {IsList 1|2|nil}}
{Browse {IsList 1|2}}
{Browse {IsList nil}}

/* Exo 5 */

declare
fun {Take Xs N}
    if N == 0 then nil
    else
        case Xs 
        of nil then nil
        [] H|T then H|{Take T N-1}
        end
    end
end
{Browse {Take [r a p h] 2}} % [r a]
{Browse {Take [r a p h] 7}} % [r a p h]
{Browse {Take [r [a p] h] 2}} % [r [a p]]

declare
fun {Drop Xs N}
    if N == 0 then Xs
    else
        case Xs
        of nil then nil
        [] H|T then {Drop T N-1}
        end
    end
end
{Browse {Drop [r a p h] 2}} % [p h]
{Browse {Drop [r a p h] 7}} % nil
{Browse {Drop [r [a p] h] 2}} % [h]


/* Exo 6 */

declare
fun {MultList Xs}
    fun {Inner Acc Xs}
        case Xs
        of nil then Acc
        [] H|T then {Inner Acc*H T}
        end
    end
in
    {Inner 1 Xs}
end
{Browse {MultList [1 2 3 4]}} % affiche 24
{Browse {MultList nil}} % affiche 24


/* Exo 7 */

/* Exo 8 */

declare
fun {FindString Xs Ys}
    fun {Inner I Xs Ys}
        case Ys
        of nil then nil
        [] _|T then
            if {Prefix Xs Ys} then
                I|{Inner I+1 Xs T}
            else
                {Inner I+1 Xs T}
            end
        end
    end
in
    {Inner 1 Xs Ys}
end
{Browse {FindString [a b a b] [a b a b a b]}} % affiche [1 3]
{Browse {FindString [a] [a b a b a b]}} % affiche [1 3 5]
{Browse {FindString [c] [a b a b a b]}} % affiche nil


/* Exo 9 */
declare
Carte = carte(menu(entree: 'salade verte aux lardons'
                    plat: 'steak frites'
                    prix: 10)
                menu(entree: 'salade de crevettes grises'
                    plat: 'saumon fume et pommes de terre'
                    prix: 12)
                menu(plat: 'choucroute garnie'
                    prix: 9))
SecMenu=Carte.2
{Browse SecMenu}
{Browse SecMenu.plat}
{Browse Carte.1.entree}
{Browse {Arity Carte}}
{Browse {Arity Carte.1}}

/* Exo 10 */

% Pre-Order traversal
% <btree T> ::= empty | btree(T left:<btree T> right:<btree T>)

declare
fun {Promenade BT}
    case BT
    of empty then nil
    [] btree(Value left:Left right:Right) then
        Value|{Append {Promenade Left} {Promenade Right}}
    end
end

%% affiche [42 26 54 18 37 11]
{Browse
    {Promenade
        btree(42
            left: btree(26
                left: btree(54
                    left: empty
                    right: btree(18
                        left: empty
                        right: empty))
                    right: empty)
            right: btree(37
                left: btree(11
                    left: empty
                    right: empty)
                right: empty))}}


/* Exo 11 */

declare
fun {DictionaryFilter D F}
    % Initialize an empty list for storing filtered elements
    local
        fun {Filter D Acc}
            % Base case: if D is a leaf, return the accumulated list
            case D
            of leaf then Acc
            else
                % D is a node: check if the node satisfies the predicate F
                if {F D.info} then
                    % If true, include this node's key and info in the list
                    {Filter D.left {Filter D.right (D.key#D.info)|Acc}}
                else
                    % Otherwise, continue filtering the left and right subtrees
                    {Filter D.left {Filter D.right Acc}}
                end
            end
        end
    in
        % Start filtering from the root of the dictionary with an empty list
        {Filter D nil}
    end
end

local
    Old Class Val
in
    Class = dict(key:10
                info:person('Christian'19)
                left:dict(key:7
                    info:person('Denys'25)
                    left:leaf
                    right:dict(key:9
                        info:person('David'7)
                        left:leaf
                        right:leaf))
                right:dict(key:18
                    info:person('Rose'12)
                    left:dict(key:14
                        info:person('Ann'27)
                        left:leaf
                        right:leaf)
                    right:leaf))
    fun {Old Info}
        Info.2 > 20
    end
    Val = {DictionaryFilter Class Old}
    {Browse Val} % Val --> [7#person('Denys'25) 14#person('Ann'27)]
end

/* Exo 12 */
local
    T1 T2
in
{Browse '|'(a b)}
{Browse {IsList '|'(a b)}} % false
{Browse {IsTuple '|'(a b)}} % true
{Browse {IsRecord'|'(a b)}} % true

{Browse '|'(a '|'(b nil))}
{Browse {IsList '|'(a '|'(b nil))}} % false
{Browse {IsTuple '|'(a '|'(b nil))}} % true
{Browse {IsRecord'|'(a '|'(b nil))}} % true

{Browse '|'(2:nil a)}
{Browse {IsList '|'(2:nil a)}} % false
{Browse {IsTuple '|'(2:nil a)}} % true
{Browse {IsRecord'|'(2:nil a)}} % true

{Browse tree(v:a T1 T2)}
{Browse {IsList tree(v:a T1 T2)}} % false
{Browse {IsTuple tree(v:a T1 T2)}} % true
{Browse {IsRecord tree(v:a T1 T2)}} % true
end

/* Exo 13 */

declare
fun {Applique Xs F}
    case Xs
    of nil then nil
    [] H|T then {F H}|{Applique T F}
    end
end

declare
fun {Lol X} lol(X) end
{Browse {Applique [1 2 3] Lol}} % Affiche [lol(1) lol(2) lol(3)]

declare
fun {MakeAdder N}
    fun {$ X}
        X + N
    end
end

declare
Add5 = {MakeAdder 5}
{Browse {Add5 13}} % 18

declare
fun {AddAll Xs N}
    {Applique Xs {MakeAdder N}}
end
{Browse {AddAll [1 2 3 4 5] 10}}

/* Exo 14 */

{Browse [1 2 3 4]}
{Browse label#{Label [1 2 3 4]}}
{Browse width#{Width [1 2 3 4]}}
{Browse arity#{Arity [1 2 3 4]}}
{Browse length#{Length [1 2 3 4]}}

{Browse a#b#c}
{Browse label#{Label a#b#c}}
{Browse width#{Width a#b#c}}
{Browse arity#{Arity a#b#c}}

declare
fun {SameLength Xs Ys}
    case Xs#Ys
    of nil#nil then true
    [] (_|Xr)#(_|Yr) then {SameLength Xr Yr}
    else false
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXTRA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Exo 1 */

local 
    fun {Flatten Xs}
        case Xs
        of nil then nil
        [] H|T then
            case H
            of _|_ then
                {Append {Flatten H} {Flatten T}}
            else
                H|{Flatten T}
            end
        end
    end
in
    % [a [b [c d]] e [[[f]]]]
    % a|(b|(c|d|nil)|nil)|e|(((f|nil)|nil)|nil)|nil
    {Browse {Flatten [a [b [c d]] e [[[f]]]]}} % affiche [a b c d e f]
end

/* Exo 2 */

declare 
fun {AddDigits D1 D2 CI}
    local
        Sum = D1 + D2 + CI
    in
        if Sum == 0 then [0 0]
        elseif Sum == 1 then [1 0]
        elseif Sum == 2 then [0 1]
        elseif Sum == 3 then [1 1]
        end
    end  
end
fun {Add B1 B2}
    % A helper function that behaves like a fold right for binary addition.
    fun {FoldRBinary B1 B2 CI Acc}
        case B1#B2
        of nil#nil then
            if CI==0 then Acc else CI|Acc end
        [] (H1|T1)#nil then
            {FoldRBinary T1 nil {AddDigits H1 0 CI}.2 {AddDigits H1 0 CI}.1|Acc}
        [] nil#(H2|T2) then
            {FoldRBinary nil T2 {AddDigits 0 H2 CI}.2 {AddDigits 0 H2 CI}.1|Acc}
        [] (H1|T1)#(H2|T2) then
            {FoldRBinary T1 T2 {AddDigits H1 H2 CI}.2 {AddDigits H1 H2 CI}.1|Acc}
        end
    end
in
    % Start the fold with both lists, an initial carry of 0, and an empty accumulator.
    {FoldRBinary {Reverse B1} {Reverse B2} 0 nil}
end

{Browse {Add [1 1 0 1 1 0] [0 1 0 1 1 1]}} % affiche [1 0 0 1 1 0 1]

% declare
% fun {DecToBin X}
%     fun {Inner X}
%         if X == 0 then nil
%         else (X mod 2)|{Inner X div 2}
%         end
%     end
% in
%     {Reverse {Inner X}}
% end
