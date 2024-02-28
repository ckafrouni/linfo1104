% Execution state
(
    ST,    % semantic stack
    sigma  % single assignement memory
)

% ST = semantic stack
[
    (<s>, E), % semantic instruction
    % ...
]

% sigma = single assignement memory
{x1=10, p1=..semantic instruction}

% E = Environment
{X->x, Y->y}




/* Exo 1 */
declare
fun {Sum N}
    if N == 1 then 1
    else N*N + {Sum N-1} end
end
{Browse {Sum 3}}

declare
proc {Sum N ?R}
    local One Cond in
        One = 1
        Cond = (N == One)
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
local R in
    {Sum 3 R}
    {Browse R}
end

%%
declare
fun {SumAux N Acc}
    if N == 1 then Acc + 1
    else {SumAux N-1 N*N+Acc} end
end
fun {Sum N}
    {SumAux N 0}
end

declare
proc {SumAux N Acc ?R}
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
proc {Sum N ?R}
    local Zero in
        Zero = 0
        {SumAux N Zero R}
    end
end
local R in
    {Sum 3 R}
    {Browse R}
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
