% Generic Stateless Port (Object)

declare
fun {BasicServer Proc} S in 
    thread 
        {List.forAll S 
            proc {$ X} thread {Proc X} end end} 
    end
    {Port.new S} 
end
%
Prt = {BasicServer 
    proc {$ M} 
        {Browse M*10} 
    end}
A B

{Send Prt 1}
{Send Prt A}

A = 2

{Send Prt 1}


% Generic Statefull Port (Object)

declare
fun {BasicServer Fun U} S in 
    thread /*Out in*/ _ = {List.foldL S Fun U} /*{Browse Out}*/ end % Out is just lost
    {Browse S}
    {Port.new S}
end
%
A
Prt = {BasicServer 
    fun {$ State M}
        {Browse State#M#'->'#State+M}
        State + M
    end 
    0}

A = 38

{Send Prt 3}

{Send Prt A}



% Active Functionnal Object

declare
fun {MathInterface P} S Prt in 
    thread 
        {List.forAll S 
            proc {$ X} thread {P X} end end} 
    end
    Prt = {Port.new S}
    proc {$ Msg} {Port.send Prt Msg} end
end
%
Math = {MathInterface
    proc {$ Msg}
        case Msg
        of 'add'(X Y ?R) then R = X+Y
        [] 'sub'(X Y ?R) then R = X-Y
        end
    end
}


declare G

G = 5

{Browse {Math 'add'(10 22 $)}}
