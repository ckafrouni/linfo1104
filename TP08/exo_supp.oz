/* Exo 1 */

% ------------------------------------------- %
% Logic Operators                             %
% ------------------------------------------- %

declare
fun {Not A}
    (A+1) mod 2
end
fun {And A B}
    if A==1 then B
    else 0 end
end
fun {Xand A B}
    if A==B then 1 else 0 end
end
fun {Or A B}
    if A==1 then 1
    elseif B==1 then 1
    else 0 end
end
fun {Xor A B}
    (A+B) mod 2
end


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
NotGate = {MakeUnaryGate Not}
AndGate = {MakeBinaryGate And}
OrGate = {MakeBinaryGate Or}
XorGate = {MakeBinaryGate Xor}
XandGate = {MakeBinaryGate Xand}
% {Browse notGate#{NotGate [1 1 0 0]}}
% {Browse andGate#{AndGate [1 1 0 0] [1 0 1 0]}}
% {Browse orGate#{OrGate [1 1 0 0] [1 0 1 0]}}
% {Browse xorGate#{XorGate [1 1 0 0] [1 0 1 0]}}
% {Browse xandGate#{XandGate [1 1 0 0] [1 0 1 0]}}

declare
fun {GateRouter LogicOp}
    case LogicOp
    of 'not' then NotGate
    [] 'and' then AndGate
    [] 'or' then OrGate
    [] 'xor' then XorGate
    [] 'xand' then XandGate
    else raise badGateSpec(LogicOp) end end
end


% ------------------------------------------- %
% Simulation                                  %
% ------------------------------------------- %

declare
fun {Simulate G Ss}
    fun {SimUnary Op In}
        % Gate must be unary
        Gate = {GateRouter Op}
    in
        case In
        of input(X) then {Gate Ss.X}
        [] gate(value:Op2 1:In2) then {Gate {SimUnary Op2 In2}}
        [] gate(value:Op2 1:In21 2:In22) then {Gate {SimBinary Op2 In21 In22}}
        else raise notValidInput(In) end end
    end
    fun {SimBinary Op In1 In2}
        % Gate must be binary
        Gate = {GateRouter Op}
    in
        case In1#In2
        of input(X)#input(Y) then {Gate Ss.X Ss.Y}
        [] input(X)#_ then {Gate Ss.X {Simulate In2 Ss}}
        [] _#input(Y) then {Gate {Simulate In1 Ss} Ss.Y}
        else {Gate {Simulate In1 Ss} {Simulate In2 Ss}} end
    end
in
    thread 
        case G
        of gate(value:Op 1:In) then {SimUnary Op In}
        [] gate(value:Op 1:In1 2:In2) then {SimBinary Op In1 In2}
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
    Ss = input(x:1|0|1|0|_ y:0|1|0|1|_ z:1|1|0|0|_)
end
