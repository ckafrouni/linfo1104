local
	fun {NewQueue}
		proc {HandleRequest S Acc}
			case S of H|T then
				case H 
				of get(?R) then R = Acc {HandleRequest T Acc}
				[] set(X) then {HandleRequest T X}
				else skip end
			end
		end
		S P in
		P = {Port.new S}
		thread {HandleRequest S nil} end
		P
	end

	proc {Enqueue Q X}
		Old in
		{Port.send Q get(Old)}
		{Port.send Q set({List.append Old X|nil})}
	end

	fun {Dequeue Q}
		Old R in
		{Port.send Q get(Old)}
		case Old 
		of H|T then R = H {Port.send Q set(T)}
		else R= nil
		end
		R
	end

	fun {IsEmpty Q}
		{List.length {Port.send Q get($)}} == 0
	end

	fun {GetElements Q}
		{Port.send Q get($)}
	end

	Q
in
	Q = {NewQueue}
	{Browse {GetElements Q}}

	{Browse 'is empty'#{IsEmpty Q}}

	{Enqueue Q 123}

	{Browse 'is empty'#{IsEmpty Q}}

	{Enqueue Q 456}

	{Browse {GetElements Q}}

	{Browse {Dequeue Q}}

	{Browse {GetElements Q}}

	{Browse {Dequeue Q}}

	{Browse {GetElements Q}}

	{Browse {Dequeue Q}}

	{Browse 'is empty'#{IsEmpty Q}}
end