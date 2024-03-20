declare
fun {BasicServer}
    proc {Loop S}
        case S
        of H|T then
            {Browse H}
            {Loop T}
        end
    end
in {Port.new thread {Loop $} end} end

% declare P = {BasicServer} in

% {Send P 'hello'}


/* Exo 2 */

declare
fun {LaunchMathServer}
    proc {Loop S Process}
        % This looks like a map since
        % there is no remaining state
        case S
        of H|T then
            % Thread to not block if H is unbound
            thread {Process H} end
            {Loop T Process}
        end
    end
    %
    proc {MathProcess E}
        {Browse 'processing'#E}
        case E
        of 'add'(X Y ?R) then R = X + Y
        [] 'sub'(X Y ?R) then R = X - Y
        [] 'pow'(B E ?R) then R = {Number.pow B E}
        [] 'div'(X Y ?R) then R = X div Y
        else {Browse 'feature not implemented'} end
    end
in {Port.new thread {Loop $ MathProcess} end} end
MP = {LaunchMathServer}

declare G

{Browse {Send MP 'div'(10 2 $)}}

% This would block the server if it didn't
% start a new thread for every request.
{Browse {Send MP 'div'(G 2 $)}}

G = 100
