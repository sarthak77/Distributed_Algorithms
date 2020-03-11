-module(temp).
-export([main/1,merge_sort/1,for/2]).

merge_sort([L]) -> [L]; 

merge_sort(L)   ->
    {L1,L2} = lists:split(length(L) div 2, L),
    lists:merge(merge_sort(L1), merge_sort(L2)).



for(0,_) -> 
    
    []; 
   
for(N,Term) when N > 0 -> 
   
    io:fwrite("~p~n",[N]), 
   [Term|for(N-1,Term)]. 



main(Args) ->

    [IP,OP]=Args,
    NOP=2,

    {ok, Binary} = file:read_file(IP),
    Lines = string:tokens(erlang:binary_to_list(Binary), " "),

    A=[lists:sublist(Lines, X, NOP) || X <- lists:seq(1,length(Lines),NOP)],

    io:fwrite("~p~n",[A]),

    for(NOP,A).

    % M=merge_sort(Lines),
    % io:fwrite("~p~n",[Lines]),
    % io:fwrite("~p~n",[M]).








