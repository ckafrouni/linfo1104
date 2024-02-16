/*
Shortcuts:
    ctrl+. ctrl+l (feed line)
    ctrl+. ctrl+b (feed file)
    ctrl+. ctrl+r (feed selection)
    ctrl+alt+x (feed paragraph)
*/

/* Exo 1 */

{Browse 1}
{Browse 2}
{Browse 3}
{Browse 4}

/* Exo 2 */

{Browse (1+5)*(9-2)}
{Browse 19 - 970}
{Browse 192 - 980 + 191 * 967}
{Browse (192 - 780) * (~3) - 191 * 967}

/* Exo 3 */
{Browse 123 + 456.0} % Error, operands must be of the same type

/* Exo 4 */

declare 
X = (6 + 5) * (9 - 7)

{Browse X}
{Browse X+5}

local X = 2 in
    {Browse X}
end

{Browse X}

/* Exo 5 */

declare
X=42
Z=~3
{Browse X} % (1)
{Browse Z}

declare
Y=X+5
{Browse Y} % (2)

declare
X=1234567890
{Browse X} % (3)

{Browse Z} 
% Le premier X n'est plus en mémoire, mais le Z l'est toujours
% car il n'a pas été réassigner

/* Exo 6 */

{Browse 3 == 7} % egaux
{Browse 3 \= 7} % differents
{Browse 3 < 7} % plus petit
{Browse 3 =< 7} % plus petit ou egal
{Browse 3 > 7} % plus grand
{Browse 3 >= 7} % plus grand ou egal

/* Exo 7 */

local
    X=7
    Y=5
    Z=6
    fun {Max3 X Y Z}
        {Max {Max X Y} Z}
    end
in
    {Browse {Max3 X Y Z}}
end

local
    fun {Sign X}
        if X < 0 then
            ~1
        elseif X > 0 then
            1
        else
            0
        end
    end
in
    {Browse {Sign 1}}
    {Browse {Sign ~3}}
    {Browse {Sign 0}}
end

/* Exo 8 */

/* Exo 9 */

declare
X=3
fun {Add2}
    X + 2
end
fun {Mul2}
    X * 2
end

{Browse {Add2}}
{Browse {Mul2}}

declare
X=4
