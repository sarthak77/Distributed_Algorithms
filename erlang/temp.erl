-module(temp).
-import(lists,[nth/2]). 
-export([main/1,merge_sort/1,for/2,f/1]).

merge_sort([L]) -> [L]; 

merge_sort(L)   ->
    {L1,L2} = lists:split(length(L) div 2, L),
    lists:merge(merge_sort(L1), merge_sort(L2)).



f(N) ->
    io:fwrite("~p~n",[N]).



for(0,_) -> 
    
    []; 
   
for(N,Term) when N > 0 -> 
   
    % io:fwrite("~p~n",[nth(N,Term)]),
    PID=spawn(temp,f,[N]),
   [Term|for(N-1,Term)]. 



main(Args) ->

    [IP,OP]=Args,

    {ok, Binary} = file:read_file(IP),
    Lines = string:tokens(erlang:binary_to_list(Binary), " "),

    NOP=4,
    LS=ceil(length(Lines)/NOP),

    A=[lists:sublist(Lines, X, LS) || X <- lists:seq(1,length(Lines),LS)],

    % io:fwrite("~p~n",[length(A)]),
    % io:fwrite("~p~n",[A]),

    for(length(A),A).

    % M=merge_sort(Lines),
    % io:fwrite("~p~n",[Lines]),
    % io:fwrite("~p~n",[M]).