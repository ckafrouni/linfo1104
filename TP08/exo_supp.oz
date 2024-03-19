/* Exo 1 */

% ------------------------------------------- %
% Logic Operators                             %
% ------------------------------------------- %



declare
fun {NOT A} (A+1) mod 2 end
%
fun {AND A B} A*B end
fun {NAND A B} {NOT {AND A B}} end
%
fun {OR A B} A+B - A*B end
fun {NOR A B} {NOT {OR A B}} end
fun {XOR A B} (A+B) mod 2 end
fun {XNOR A B} {NOT {XOR A B}} end
%
proc {TestGate Label Gate}
    {Browse 0#Label#0#'='#{Gate 0 0}}
    {Browse 0#Label#1#'='#{Gate 0 1}}
    {Browse 1#Label#0#'='#{Gate 1 0}}
    {Browse 1#Label#1#'='#{Gate 1 1}}
end
% {TestGate 'xnor' XNOR}
% {Browse _}

% ------------------------------------------- %
% Gates                                       %
% ------------------------------------------- %

declare
fun {MakeUnaryGate F}
    fun {$ Xs}
        fun {Gate Xs}
            case Xs
            of H|T then {F H}|{Gate T}
            else nil end
        end
    in thread {Gate Xs} end end
end
fun {MakeBinaryGate F}
    fun {$ Xs Ys}
        fun {Gate Xs Ys}
            case Xs#Ys
            of (Xh|Xt)#(Yh|Yt) then {F Xh Yh}|{Gate Xt Yt}
            else nil end
        end
    in thread {Gate Xs Ys} end end
end
NOTGate = {MakeUnaryGate NOT}
ANDGate = {MakeBinaryGate AND}
NANDGate = {MakeBinaryGate NAND}
ORGate = {MakeBinaryGate OR}
NORGate = {MakeBinaryGate NOR}
XORGate = {MakeBinaryGate XOR}
XNORGate = {MakeBinaryGate XNOR}
% {Browse 'NOTGate'#{NOTGate [0 0 1 1]}}
% {Browse 'ANDGate'#{ANDGate [0 0 1 1] [0 1 0 1]}}

declare
fun {GateRouter Label}
    case Label
    of 'not' then NOTGate
    [] 'and' then ANDGate
    [] 'nand' then NANDGate
    [] 'or' then ORGate
    [] 'nor' then NORGate
    [] 'xor' then XORGate
    [] 'xnor' then XNORGate
    else raise badGateSpec(Label) end end
end


% ------------------------------------------- %
% Simulation                                  %
% ------------------------------------------- %

declare
fun {Simulate G Ss}
    fun {SimUnary OpLabel Xi}
        % Gate must be unary
        Gate = {GateRouter OpLabel}
    in
        case Xi
        of input(X) then {Gate Ss.X}
        [] gate(value:OpLabel 1:Xi) then {Gate {SimUnary OpLabel Xi}}
        [] gate(value:OpLabel 1:Xi 2:Yi) then {Gate {SimBinary OpLabel Xi Yi}}
        else raise notValidInput(Xi) end end
    end
    fun {SimBinary OpLabel Xi Yi}
        % Gate must be binary
        Gate = {GateRouter OpLabel}
    in
        case Xi#Yi
        of input(X)#input(Y) then {Gate Ss.X Ss.Y}
        [] input(X)#_ then {Gate Ss.X {Simulate Yi Ss}}
        [] _#input(Y) then {Gate {Simulate Xi Ss} Ss.Y}
        else {Gate {Simulate Xi Ss} {Simulate Yi Ss}} end
    end
in
    thread 
        case G
        of gate(value:OpLabel 1:Xi) then {SimUnary OpLabel Xi}
        [] gate(value:OpLabel 1:Xi 2:Yi) then {SimBinary OpLabel Xi Yi}
        else raise notValidGate(G) end end
    end
end
local G Ss in
    G = gate(value:'or'
        gate(value:'and'
            input(x)
            input(y))
        gate(value:'not' input(z)))
    {Browse {Simulate G Ss}}
    Ss = input(x:1|0|1|0|_ y:1|1|0|1|_ z:1|1|0|0|_)
end
