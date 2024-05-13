
/* Exo 2 */

declare
fun {LaunchMathServer}
    Stream
    proc {MathProcess E}
        % {Browse 'processing'#E}
        case E
        of 'add'(X Y ?R) then R = X + Y
        [] 'sub'(X Y ?R) then R = X - Y
        [] 'pow'(B E ?R) then R = {Number.pow B E}
        [] 'div'(X Y ?R) then R = X div Y
        else {Browse 'feature not implemented'} end
    end
    proc {MPThreaded E}
        thread {MathProcess E} end
    end
in 
    thread {List.forAll Stream MPThreaded} end
    {Port.new Stream} 
end
%
MP = {LaunchMathServer}

declare G

{Browse {Send MP 'div'(10 2 $)}}

% This would block the server if it didn't
% start a new thread for every request.
{Browse {Send MP 'div'(G 2 $)}}

G = 100


% TODO check if true
% Port Object ? This isn't really a Port OBJECT that we returned,
% rather a port ADT. 
% Since we aren't bundeling the port with functions ? Or does the
% port actually have methods ?
% {P.<method> ...}
% 
% From what I understand the Port should be an ADT, as to send
% we do {Port.send P <arg>}, so we pass P as an argument.
% 

% Here I am creating an Object that uses a Port under the hood.
% So it is not a Port itself.

declare
fun {LaunchMathServer}
    S P
    proc {MathProcess E}
        {Browse 'processing'#E}
        case E
        of 'add'(X Y ?R) then R = X + Y
        [] 'sub'(X Y ?R) then R = X - Y
        [] 'pow'(B E ?R) then R = {Number.pow B E}
        [] 'div'(X Y ?R) then R = X div Y
        else {Browse 'feature not implemented'} end
    end
    proc {MPThreaded E}
        thread {MathProcess E} end
    end
in
    thread {List.forAll S MPThreaded} end
    P = {Port.new S}
    %
    'interface'(
        'add': proc {$ X Y ?R} {Port.send P 'add'(X Y R)} end
        'sub': proc {$ X Y ?R} {Port.send P 'sub'(X Y R)} end
        'pow': proc {$ X Y ?R} {Port.send P 'pow'(X Y R)} end
        'div': proc {$ X Y ?R} {Port.send P 'div'(X Y R)} end
    ) 
end
MPObj = {LaunchMathServer}

{Browse MPObj}

declare G

{Browse {MPObj.'div' 10 2 $}}

{Browse {MPObj.'div' G 2 $}}
{Browse {MPObj.'div' 10 2 $}}

G = 100




/* Exo 4 */

declare
fun {Portier}
    S
in
    thread _ = {List.foldL S
        fun {$ U Msg}
            case Msg
            of 'getIn'(N) then U+N
            [] 'getOut'(N) then U-N
            [] 'getCount'(?N) then N=U U
            end
        end
        0}
    end
    {Port.new S}
end
%
P = {Portier}

{Port.send P getIn(5)}
{Browse {Port.send P getCount($)}}



/* 
    5. Ma Stack bien aimée. Implémentez la fonction NewStack sans arguments, qui renvoie un Port
    Object représentant une pile. Utilisez la fonction NewPortObject donnée ci-dessus (ou utilisez la
    vôtre si vous le souhaitez). Ensuite, implémentez les trois opérations principales qui peuvent être
    effectuées sur une pile. {Push S X}, qui pousse l’élément X dans la pile S. {Pop S} qui renvoie
    l’élément en haut de la pile S, et {IsEmpty S}, qui renvoie une valeur booléenne indiquant si la pile
    S est vide ou non. Chacune de ces procédures doit envoyer le message correspondant à l’objet port
    créé par NewStack.
*/

declare
fun {NewPortObject Behaviour Init}
    Sin
in
    thread _ = {List.foldL Sin Behaviour Init} end
    {NewPort Sin}
end

declare
fun {NewStack}
    Init = nil
    fun {Behaviour State Msg}
        case Msg
        of 'push'(X) then X|State
        [] 'pop'(?R) then
            case State
            of H|T then R=H T
            [] nil then R=nil nil
            end
        [] 'isEmpty'(?R) then R=(State==nil) State
        end
    end
in
    {NewPortObject Behaviour Init}
end
proc {Push P X}
    {Port.send P 'push'(X)}
end
fun {Pop P}
    {Port.send P 'pop'($)}
end
fun {IsEmpty P}
    {Port.send P 'isEmpty'($)}
end

declare
P = {NewStack}

{Push P 1}
{Push P 2}
{Push P 3}

{Browse {Pop P}}
{Browse {Pop P}}

{Browse {IsEmpty P}}
{Browse {Pop P}}
{Browse {IsEmpty P}}


/*
    6. File concurrente. Maintenant que vous savez comment mettre en place une pile, la mise en place
    d’une file d’attente ne sera pas du tout difficile. Implémentez la fonction NewQueue sans argument,
    qui renvoie un objet port représentant une file d’attente FIFO. Les opérations suivantes doivent
    être implémentées : {Enqueue Q X} qui met l’élément X dans la file d’attente Q. {Dequeue Q} qui
    renvoie le premier élément de la file d’attente. {IsEmpty Q} qui renvoie si Q est vide ou non, et
    {GetElements Q} qui renvoie tous les éléments de la file d’attente.
*/

declare
fun {NewQueue}
    Init = nil
    fun {Behaviour State Msg}
        case Msg
        of 'enqueue'(X) then {List.append State [X]}
        [] 'dequeue'(?R) then
            case State
            of H|T then R=H T
            [] nil then R=nil nil
            end
        [] 'isEmpty'(?R) then R=(State==nil) State
        [] 'getElements'(?R) then R=State State
        end
    end
in
    {NewPortObject Behaviour Init}
end
proc {Enqueue P X}
    {Port.send P 'enqueue'(X)}
end
fun {Dequeue P}
    {Port.send P 'dequeue'($)}
end
fun {IsEmpty P}
    {Port.send P 'isEmpty'($)}
end
fun {GetElements P}
    {Port.send P 'getElements'($)}
end

declare
Q = {NewQueue}

{Enqueue Q 1}
{Enqueue Q 2}
{Enqueue Q 3}

{Browse {Dequeue Q}}
{Browse {Dequeue Q}}

{Browse {IsEmpty Q}}
{Browse {Dequeue Q}}
{Browse {IsEmpty Q}}

{Browse {GetElements Q}}

