/* Exo 3 */

declare
fun {NOT A} (A+1) mod 2 end
fun {AND A B} A*B end
fun {OR A B} A+B - A*B end
fun {NOR A B} {NOT {OR A B}} end
fun {XOR A B} (A+B) mod 2 end

declare
fun {MakeBinaryGate F}
    fun {$ Xs Ys}
        fun {Gate Xs Ys}
            case Xs#Ys
            of (Xh|Xt)#(Yh|Yt) then {F Xh Yh}|{Gate Xt Yt}
            else nil end
        end
    in thread {Gate Xs Ys} end end
end
ANDGate = {MakeBinaryGate AND}
ORGate = {MakeBinaryGate OR}
NORGate = {MakeBinaryGate NOR}
XORGate = {MakeBinaryGate XOR}


/* Exo 4 */

% Bascule RS
% slide 102 : sequential logic
% TODO plus d'explication stp
local 
    fun {DelayStream Xs} 0|Xs end
    %
    Ss = 0|1|0|0|_ 
    Rs = 1|1|1|0|_ 
    Qs
    NotQs
    %
    proc {Bascule Rs Ss Qs NotQs}
        DelayedQs = {DelayStream Qs}
        DelayedNotQs = {DelayStream NotQs}
    in
        Qs = {NORGate Rs DelayedNotQs}
        NotQs = {NORGate Ss DelayedQs}
    end
in
    {Bascule Rs Ss Qs NotQs}
    {Browse Qs#NotQs}
end
