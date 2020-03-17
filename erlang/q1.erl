-module(q1).
-export([main/1,f/5]). 

% I -> process no
% ID -> parent id
% N -> total processes-1
% T -> token
% OP -> output file

f(I,ID,N,T,OP) ->

	if

		I == N ->
			ID ! {I,self()},
			receive
				0 ->
					{ok, Fd} = file:open(OP,[append]), 
					L=io_lib:format("Process ~w received token ~w from process ~w.~n",[N-I,T,N-0]),
					file:write(Fd,L)
			end;

		I == N-1 ->
			receive
				{J,PID} ->
					{ok, Fd} = file:open(OP,[write]), 
					L=io_lib:format("Process ~w received token ~w from process ~w.~n",[N-I,T,N-J]),
					file:write(Fd,L),
					
					%case when 2 processes and N-1=0
					if
						I == 0 ->
							PID ! I;
						I /= 0 ->
							ID ! {I,PID}
					end
			end;

		I == 0 ->
			receive
				{J,PID} ->
					{ok, Fd} = file:open(OP,[append]), 
					L=io_lib:format("Process ~w received token ~w from process ~w.~n",[N-I,T,N-J]),
					file:write(Fd,L),
					PID ! I
			end;

		I /= 0 ->
			receive
				{J,PID} ->
					{ok, Fd} = file:open(OP,[append]), 
					L=io_lib:format("Process ~w received token ~w from process ~w.~n",[N-I,T,N-J]),
					file:write(Fd,L),
					ID ! {I,PID}
			end

	end.



for(0,_) -> 
	[]; 

for(N,Term) when N > 0 -> 

	%extract values from list
	[C,ID,T,OP]=Term,

	%create a process
	PID=spawn(q1,f,[C+1,ID,N+C,T,OP]),
	
	%recursively call for loop by decreasing N
	[[C+1,PID,T,OP]|for(N-1,[C+1,PID,T,OP])]. 



main(Args) -> 

	%read arguments
	[IP,OP]=Args,

	%read from input file
	{ok,Binary}=file:read_file(IP),
	Lines=string:tokens(erlang:binary_to_list(Binary), " "),
	[NOP,Token]=Lines,

	%create first process
	PID=spawn(q1,f,[0,0,list_to_integer(NOP)-1,list_to_integer(Token),OP]),

	%create other processes
	for(list_to_integer(NOP)-1,[0,PID,list_to_integer(Token),OP]).