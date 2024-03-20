/* Exo 1 */

% ------------------------------------------- %
% Logic Operators                             %
% ------------------------------------------- %

declare
Ops = ops(
    % Helper methods
    'testBinary': proc {$ Label}
        {Browse 'Testing op : '#Label}
        {Browse 0#Label#0#{Ops.Label 0 0}}
        {Browse 0#Label#1#{Ops.Label 0 1}}
        {Browse 1#Label#0#{Ops.Label 1 0}}
        {Browse 1#Label#1#{Ops.Label 1 1}}
    end
    'testUnary': proc {$ Label}
        {Browse 'Testing op : '#Label}
        {Browse 0#{Ops.Label 0}}
        {Browse 1#{Ops.Label 1}}
    end
    % Defined ops
    'not': fun {$ A} (A+1) mod 2 end
    'and': fun {$ A B} A*B end
    'nand': fun {$ A B} 1 - A*B end % {NOT {AND A B}}
    'or': fun {$ A B} A+B - A*B end
    'nor': fun {$ A B} 1 - (A+B - A*B) end % {NOT {OR A B}}
    'xor': fun {$ A B} (A+B) mod 2 end
    'xnor': fun {$ A B} {Ops.'not' {Ops.'xor' A B}} end
)
% {Ops.'testBinary' 'and'}
% {Ops.'testUnary' 'not'}
%
%
% ------------------------------------------- %
% Gates                                       %
% ------------------------------------------- %
%
declare
Gates = gates(
    % Helper methods
    'makeUnary': fun {$ F}
        fun {$ Xs}
            fun {Gate Xs}
                case Xs
                of H|T then {F H}|{Gate T}
                else nil end
            end
        in thread {Gate Xs} end end
    end
    'makeBinary': fun {$ F}
        fun {$ Xs Ys}
            fun {Gate Xs Ys}
                case Xs#Ys
                of (Xh|Xt)#(Yh|Yt) then {F Xh Yh}|{Gate Xt Yt}
                else nil end
            end
        in thread {Gate Xs Ys} end end
    end
    'test': proc {$ Label}
        Xs = [0 0 1 1]
        Ys = [0 1 0 1]
    in
        {Browse 'Testing gate : '#Label}
        {Browse Xs}
        {Browse Ys}
        {Browse {Gates.Label Xs Ys}}
    end
    % Defined gates
    'not': {Gates.'makeUnary' Ops.'not'}
    'and': {Gates.'makeBinary' Ops.'and'}
    'nand': {Gates.'makeBinary' Ops.'nand'}
    'or': {Gates.'makeBinary' Ops.'or'}
    'nor': {Gates.'makeBinary' Ops.'nor'}
    'xor': {Gates.'makeBinary' Ops.'xor'}
    'xnor': {Gates.'makeBinary' Ops.'xnor'}
)
% {Gates.test 'and'}
% {Gates.test 'or'}


% ------------------------------------------- %
% Simulation                                  %
% ------------------------------------------- %

declare
fun {Simulate G Ss}
    fun {SimUnary Label Xi}
        Gate = Gates.Label  % Gate must be unary
    in
        case Xi
        of input(X) then {Gate Ss.X}
        [] gate(value:Label 1:Xi) then {Gate {SimUnary Label Xi}}
        [] gate(value:Label 1:Xi 2:Yi) then {Gate {SimBinary Label Xi Yi}}
        else raise notValidInput(Xi) end end
    end
    fun {SimBinary Label Xi Yi}
        Gate = Gates.Label % Gate must be binary
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
        of gate(value:Label 1:Xi) then {SimUnary Label Xi}
        [] gate(value:Label 1:Xi 2:Yi) then {SimBinary Label Xi Yi}
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


% ------------------------------------------- %
% Circuits                                    %
% ------------------------------------------- %

% Slides 100
declare
proc {FullAdder X Y Z ?C ?S}
    A B D E F
in
    A = {Gates.'and' X Y}
    B = {Gates.'and' Y Z}
    D = {Gates.'and' X Z}
    E = {Gates.'xor' X Y}
    F = {Gates.'or' B D}
    %
    C = {Gates.'or' A F}
    S = {Gates.'xor' E Z}
end
