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
end

declare
fun {Head Xs} Xs.1 end
fun {Tail Xs} Xs.2 end

{Browse {Head [a b c]}}
{Browse {Tail [a b c]}}

/* Exo 2 */

% TODO Quel est l'invariant utilisé

local
    fun {Length Xs}
        fun {Inner Acc Xs}
            case Xs
            of nil then Acc
            [] H|T then {Inner Acc+1 T}
            end
        end
    in
        {Inner 0 Xs}
    end
in
    {Browse {Length [r a p h]}} % affiche 4
    {Browse {Length [[b o r] i s]}} % affiche 3
    {Browse {Length [[l u i s]]}} % affiche 1
    {Browse {Length nil}} % affiche 0
end

/* Exo 3 */

% TODO Maybe append in reverse ?

local
    fun {Append Xs Ys}
        fun {Inner Acc Xs Ys}
            case Xs
            of nil then Acc|Ys
            [] H|T then {Inner Acc|H T Ys}
            end
        end
        Acc
    in
        {Inner Acc Xs Ys}
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

% TODO Peut-on tout convertir en Tail recursive ?
declare
fun {Take Xs N}
    fun {Inner Acc Xs N}
        if N==0 then Acc
        else
            case Xs
            of nil then Acc
            [] H|T then {Inner Acc|H T N-1}
            end
        end
    end
in
    {Inner nil Xs N}|nil
end
{Browse {Take [1 2 3 4 5] 2}}

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
fun {Prefix L1 L2}
    case L1 
    of nil then true
    [] H1|T1 then 
        case L2
        of nil then false
        [] H2|T2 then
            if H1==H2 then
                {Prefix T1 T2}
            else false
            end
        end
    end
end
{Browse {Prefix [1 2 1] [1 2 3 4]}} % affiche false
{Browse {Prefix [1 2 3] [1 2 3 4]}} % affiche true

% TODO Can we make FindString tail recursive ?

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
