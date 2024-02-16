/* Exo 1 Somme des carrées */
declare
fun {Sum N}
    fun {Inner Acc X}
        if X == N then
            Acc + X*X
        else
            {Inner (Acc + X*X) X+1}
        end
    end
in
    {Inner 0 1}
end
{Browse {Sum 6}}

/* Exo 2 */

declare
fun {Mirror X}
    fun {Inner Acc X}
        if X == 0 then
            Acc
        else
            {Inner (Acc * 10 + X mod 10) (X div 10)}
        end
    end
in
    {Inner 0 X}
end
{Browse {Mirror 12345}}

/* Exo 3 */

declare
fun {Foo N}
    if N<10 then 1
    else 1+{Foo (N div 10)}
    end
end
{Browse {Foo 0}}
{Browse {Foo 2}}
{Browse {Foo 20}}
{Browse {Foo 69}}
{Browse {Foo 6955}}
{Browse {Foo 694}}
{Browse {Foo ~694}}

/* Exo 4 */

declare
local
    fun {FooHelper N Acc}
        if N<10 then Acc+1
        else {FooHelper (N div 10) Acc+1}
        end
    end
in
    fun {Foo N}
        {FooHelper N 0}
    end
end

/* Exo 5 */

declare
proc {CountDown N}
    if N >= 0 then
        {Browse N}
        {CountDown N - 1}
    end
end
{CountDown 5}
