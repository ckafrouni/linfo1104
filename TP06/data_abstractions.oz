% Types of data abstractions

declare
% Simple version
% proc {NewWrapper ?Wrap ?Unwrap}
%     Key={NewName}
% in
%     fun {Wrap X}
%         fun {$ K} if K==Key then X end end
%     end
%     fun {Unwrap W}
%         {W Key}
%     end
% end
% Advanced Version
proc {NewWrapper ?Wrap ?Unwrap}
    Key={NewName}
in
    fun {Wrap X}
        {Chunk.new w(Key:X)}
    end
    fun {Unwrap W}
        try W.Key
        catch  _ then raise error(unwrap(W)) end
        end
    end
end

% (Functional) ADT
local 
    NewStack Push Pop IsEmpty
in
    local Wrap Unwrap in
        {NewWrapper Wrap Unwrap}
        fun {NewStack} {Wrap nil} end
        fun {Push S X} {Wrap X|{Unwrap S}} end
        fun {Pop S ?R}
            R = {Unwrap S}.1
            {Wrap {Unwrap S}.2} 
        end
        fun {IsEmpty S} {Unwrap S} == nil end
    end
    % Do Something
    S = {NewStack}
    S = {Push S 1}
    {Browse {Pop S}}
    S = {Push S 1}
    S = {Push S 1}
    S = {Push S 1}
end

% Statefull ADT
local
NewStack Push Pop IsEmpty
in
    local Wrap Unwrap in
        {NewWrapper Wrap Unwrap}
        fun {NewStack} {Wrap {NewCell nil}} end
        proc {Push S E} 
            C={Unwrap S} 
        in 
            C:=E|@C
        end
        fun {Pop S} C={Unwrap S} in
            case @C 
            of X|S1 then 
                C:=S1 
                X
            else nil
            end
        end
        fun {IsEmpty S} @{Unwrap S}==nil end
    end
    % Do Something
    local
        S = {NewStack}
        S2 = {NewStack}
    in
        {Push S 1}
        {Browse {Pop S}}
        {Push S2 2}
        {Browse {Pop S2}}
        {Push S 1}
        {Push S 1}
    end
end

% Functional Object
local 
    NewStack
in
    fun {NewStack}
        fun {StackObject S}
            fun {Push X} {StackObject X|S} end
            fun {Pop ?S1}
                case S
                of X|T then 
                    S1 = {StackObject T}
                    X
                else {StackObject nil}
                end
            end
            fun {IsEmpty} S==nil end
        in
            stack(push:Push pop:Pop isEmpty:IsEmpty)
        end
    in
        {StackObject nil}
    end
    % Do Something
    S = {NewStack}
    S = {S.push 1}
    S = {S.push 1}
    S = {S.push 1}
    S = {S.push 1}

end

% (Statefull) Object
local NewStack in
    fun {NewStack}
        S = {NewCell nil}
        proc {Push X} S := X|@S end
        fun {Pop}
            case @S
            of X|T then 
                S := T
                X
            else nil end
        end
        fun {IsEmpty} @S==nil end
    in
        stack(push:Push pop:Pop isEmpty:IsEmpty)
    end
    % Do Something
    local 
        S = {NewStack}
    in
        for I in 0..10 do {S.push I} end
        for _ in 0..5 do {Browse {S.pop}} end
        % for I in 0..10 do {S push(I)} end
        % for _ in 0..5 do {Browse {S pop($)}} end
    end
end

local Stack in
    class Stack
        attr S
        meth init
            S := nil
        end
        meth push(E)
            S := E|@S
        end
        meth pop($)
            case @S
            of E|T then 
                S := T
                E
            else nil end
        end
        meth isEmpty($)
            @S==nil
        end
    end
    %
    local
        S = {New Stack init}
        X
    in
        for I in 0..10 do {S push(I)} end
        for _ in 0..5 do {Browse {S pop($)}} end
        {S pop(X)}
        {Browse X}
        for I in 0..10 do {S init} end
        for _ in 0..5 do {Browse {S pop($)}} end
    end
end

local New Stack in
    % TODO Que fait New ??
    fun {New Class Init}
        Object = {Class}
    in
        {Object Init}
        Object
    end
    %
    fun {Stack}
        S = {NewCell nil}
        proc {Init } S:=nil end
        proc {Push X} S := X|@S end
        proc {Pop ?R}
            case @S
            of X|T then 
                S := T
                R=X
            else R=nil end
        end
        proc {IsEmpty ?R} R=(@S==nil) end
    in
        proc {$ Route}
            case Route
            of init then {Init}
            [] push(E) then {Push E}
            [] pop(R) then {Pop R}
            [] isEmpty(R) then {IsEmpty R}
            end
        end
    end
    % Do Something
    local 
        S = {New Stack init}
    in
        for I in 0..10 do {S push(I)} end
        for _ in 0..5 do {Browse {S pop($)}} end
        for I in 0..10 do {S init} end
        for _ in 0..5 do {Browse {S pop($)}} end
    end
end
