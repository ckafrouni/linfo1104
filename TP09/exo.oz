/* Exo 1 */

% TODO on paper


/* Exo 2 */

% TODO ressembles a question from TP08


/* Exo 3 */

% Done in TP08 supplementary exercices
% Must run first to load Gates ...


/* Exo 4 */

% RS Flip
% slide 102 : sequential logic
% TODO plus d'explication stp
local 
    fun {DelayStream Xs} 0|Xs end
    %
    Ss = 0|1|0|0|_ 
    Rs = 1|1|1|0|_ 
    Qs
    NotQs
    %
    proc {Flip Rs Ss Qs NotQs}
        DelayedQs = {DelayStream Qs}
        DelayedNotQs = {DelayStream NotQs}
    in
        Qs = {Gates.'nor' Rs DelayedNotQs}
        NotQs = {Gates.'nor' Ss DelayedQs}
    end
in
    {Flip Rs Ss Qs NotQs}
    {Browse Qs#NotQs}
end


/* Exo 5 */

% TODO
