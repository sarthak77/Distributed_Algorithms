-module(q1).
-export([main/1,f/5]). 

f(I,ID,N,T,OP) ->
   % io:fwrite("HEllo ~w ~w ~w~n",[I,ID,N]),

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
               file:write(Fd,L)   ,
               ID ! {I,PID}
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
               file:write(Fd,L)   ,
               ID ! {I,PID}
         end

   end.



for(0,_) -> 
   []; 
   
for(N,Term) when N > 0 -> 

   [C,ID,T,OP]=Term,

   PID=spawn(q1,f,[C+1,ID,N+C,T,OP]),
   [[C+1,PID]|for(N-1,[C+1,PID,T,OP])]. 

main(Args) -> 

    [IP,OP]=Args,

    {ok, Binary} = file:read_file(IP),
    Lines = string:tokens(erlang:binary_to_list(Binary), " "),
   
    [NOP,Token]=Lines,

    PID=spawn(q1,f,[0,0,list_to_integer(NOP)-1,list_to_integer(Token),OP]),

    for(list_to_integer(NOP)-1,[0,PID,list_to_integer(Token),OP]).