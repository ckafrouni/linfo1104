/* Exo 1 */

% 1.
declare
fun {Sum N}
    if N == 1 then 1
    else N*N + {Sum N-1} end
end

local Sum in 
    Sum=proc {$ N ?R}
        local One Cond in
            One = 1
            Cond=(N==One)
            if Cond then 
                R = One
            else 
                local X N2 R1 in
                    X = N*N
                    N2 = N-1
                    {Sum N2 R1}
                    R = X + R1
                end
            end
        end
    end
end

% 2.
declare
fun {SumAux N Acc}
    if N == 1 then Acc + 1
    else {SumAux N-1 N*N+Acc} end
end
fun {Sum N}
    {SumAux N 0}
end

local SumAux Sum in
    SumAux=proc {$ N Acc ?R}
        local One Cond in
            One = 1
            Cond = (N == 1)
            if Cond then
                R = Acc + One
            else
                local NDec NN Acc2 in
                    NDec = N - One
                    NN = N * N
                    Acc2 = NN + Acc
                    {SumAux NDec Acc2 R}
                end
            end
        end
    end
    Sum=proc {$ N ?R}
        local Zero in
            Zero = 0
            {SumAux N Zero R}
        end
    end
end

/* Exo 2 */

% [1]
% [1 2 3]
% nil
% state(4 f 3)
{Browse '|'(1:1 2:test)}
{Browse '|'(1:1 2:'|'(1:2 2:'|'(1:3 2:nil)))}
{Browse nil}
{Browse state(1:4 2:f 3:3)}

/* Exo 3 */

% 1.
proc {Q A} {P A+1} end
Ec = E|{P->E(P)}
   = {P->E(P)}

% 2.
proc {P} {Browse A} end
Ec = {Browse->E(Browse)}

% 3.
local P Q in
    % {P->p, Q->q}

    proc {P A R} R=A+2 end % Ec = {}
    

    local P R in
        % {Q->q, P->p2, R->r}

        fun {Q A}
            {P A R}
            R
        end % Ec = {R->r, P->p2}

        proc {P A R} R=A-2 end % Ec = {}
    end
    {Browse {Q 4}} % 2 car on appel p2
end
