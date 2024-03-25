%%%%%%%%%%%%%%%%%%%%%%%%

% WaitTwo operation
declare
fun {WaitTwo X Y}
   {Record.waitOr X#Y}
end

%%%%%%%%%%%%%%%%%%%%%%%%

% LINFO1104

% Message protocols using port objects

%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Stateless port object

declare
fun {NewPortObject2 Proc}
   P S
in
   {NewPort S P}
   thread
      for M in S do {Proc M} end
   end
   P
end

%%%%% RMI

% RMI (Remote Method Invocation) is a simple base protocol.
% A client sends a request to a server and the server answers.
% This protocol is synchronous: client waits for answer after sending.

% Server
declare
proc {ServerProc Msg}
   case Msg of calc(X Y) then
      Y=X*X+2.0*X+234.3
   end
end
Server={NewPortObject2 ServerProc}

local Y in {Send Server calc(1.0 Y)} {Browse Y} end

% Client (doing normal, synchronous RMI)
declare
proc {ClientProc Msg}
   case Msg of work(Y) then Y1 Y2 in
      {Send Server calc(1.0 Y1)}
      {Wait Y1}
      {Send Server calc(2.0 Y2)}
      {Wait Y2}
      Y=Y1+Y2
   end
end
Client={NewPortObject2 ClientProc}

% Do the work
declare Y in
{Send Client work(Y)}
{Browse Y}

%%%%% Asynchronous RMI

% In this version, the client sends the request without waiting for an answer.
% Multiple requests can be "ongoing" simultaneously.
% This is more efficient than Synchronous RMI (above), but does not require
% changing the server at all.  In fact, the server sees no difference with
% the previous protocol except for timings, which are not important.

declare
proc {ClientProc Msg}
   case Msg of work(Y) then Y1 Y2 in
      {Send Server calc(1.0 Y1)}
      {Send Server calc(2.0 Y2)}
      {Wait Y1}
      {Wait Y2} % Actually, Y1+Y2 does the waits
      Y=Y1+Y2
   end
end
Client2={NewPortObject2 ClientProc}

declare Y in
{Send Client2 work(Y)}
{Browse Y}

%%%%% RMI with callback

% In this version, the server needs to ask
% for some information from the client.

% The first attempt is buggy!

declare
proc {ServerProc Msg}
   case Msg of calc(X Y Client) then D in
      {Send Client delta(D)}
      Y=X*X+2.0*D*X+D*D+23.0
   end
end
Server={NewPortObject2 ServerProc}

% This client deadlocks: client waits *inside* the method,
% and the server waits forever for delta(D).
% The problem is the client has only one thread to handle its
% message stream, and if this thread waits then the client is blocked.
declare
proc {ClientProc Msg}
   case Msg of work(Z) then Y in
      {Send Server calc(10.0 Y Client)}
      % Client waits for Y to be bound:
      Z=Y+10.0
   [] delta(D) then
      D=0.1
   end
end
Client={NewPortObject2 ClientProc}

declare Z in
{Send Client work(Z)}
{Browse Z}

%%%%% RMI with callback (thread version)

% This is a correct version of the client
% Thread = "unit of waiting" -> add a thread to do the waiting
% The server code stays the same as before.
% Don't forget to restart the server when testing the fixed client!
declare
proc {ClientProc Msg}
   case Msg of work(Z) then Y in
      {Send Server calc(10.0 Y Client)}
      thread Z=Y+10.0 end % A new thread!
   [] delta(D) then
      D=0.1
   end
end
Client={NewPortObject2 ClientProc}

declare Z in
{Send Client work(Z)}
{Browse Z}

%%%%% RMI with callback (record continuation)

% This is another way to do it, avoiding creating a new thread
% cont(Y Z) is a record (data structure)
% Need to pass Y to server, which is passed back to the client
declare
proc {ServerProc Msg}
   case Msg of calc(X Client Y) then Z D in
      {Send Client delta(D)}
      Z=X*X+2.0*D*X+D*D+23.0
      {Send Client cont(Y Z)}
   end
end
Server={NewPortObject2 ServerProc}

declare
proc {ClientProc Msg}
   case Msg of work(Y) then % First part of client method
      {Send Server calc(10.0 Client Y)}
   [] cont(Y Z) then        % Second part of client method
      Y=Z+10.0
   [] delta(D) then
      D=0.1
   end
end
Client={NewPortObject2 ClientProc}

declare Z in
{Send Client work(Z)}
{Browse Z}

%%%%% RMI with callback (procedure continuation)

% A variation using higher-order programming
% Advantage is that the server doesn't need to know about the client
% All information is in the first client method
declare
proc {ServerProc Msg}
   case Msg of calc(X Client Y ContProc) then Z D in
      {Send Client delta(D)}
      Y=X*X+2.0*D*X+D*D+23.0
      {Send Client p(ContProc)}
   end
end
Server={NewPortObject2 ServerProc}

declare
proc {ClientProc Msg}
   case Msg of work(Y) then Z in
      {Send Server
       calc(10.0 Client Z proc {$} Y=Z+10.0 end)}
   [] p(ContProc) then
      {ContProc}
   [] delta(D) then
      D=0.1
   end
end
Client={NewPortObject2 ClientProc}

declare Z in
{Send Client work(Z)}
{Browse Z}

%%%%%%%%%%%%%%%%%%%%%

%%%%% Active objects and passive objects

% Passive object = synchronous call, executes the method in the caller thread
% - Concurrent calls are interleaved so will often give bugs!
% Active object = asynchronous call, executes the method in the object's thread
% - Concurrent calls are executed sequentially, so no bugs

% An active object has the same structure as a port object, except that its
% behavior is defined by a class instead of a function with a case statement.

%%%%% Introduction to classes and objects in Oz

% Classes in Oz
% Similar to classes in many object-oriented languages
declare
class Counter
   attr i
   meth init(X)
      i:=X
   end
   meth inc(X)
      i:= @i + X
   end
   meth get(X)
      X=@i
   end
end

% Create a passive object
declare
Ctr={New Counter init(0)}

local X in {Ctr get(X)} {Browse X} end
{Ctr inc(10)}

%%%%%%%%%%%%%%%%%%%%%%%%%%

% New active object
declare
fun {NewActive Class Init}
   Obj={New Class Init}
   P
in
   thread S in
      {NewPort S P}
      for M in S do {Obj M} end
   end
   proc {$ M} {Send P M} end
end

% Create an active object
declare
Ctr={NewActive Counter init(0)}

local X in {Ctr get(X)} {Browse X} end
{Ctr inc(10)}

%%%%%

% Ball playing example using active objects
% This code is very similar to the first ball playing example with port objects
declare
class PlayerClass
   attr state others
   meth init(Others)
      state:=0
      others:=Others
   end
   meth ball
      Ran = ({OS.rand} mod {Width @others})+1
   in
      {(@others).Ran ball}
      state:= @state+1
   end
   meth get(X)
      X=@state
   end
end

% Note: during the lecture this had an error: it called New instead of NewActive
% The following definition is correct
declare
fun {Player Others}
   {NewActive PlayerClass init(Others)} 
end

% Initialize the game
declare P1 P2 P3 in
P1={Player others(P2 P3)}
P2={Player others(P1 P3)}
P3={Player others(P1 P2)}

local X in {P1 get(X)} {Browse X} end

% Start the game
{P1 ball}

%%%%%%%%%%%%%%%%%%%%%%%%%
