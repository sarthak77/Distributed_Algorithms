-module(q2).
-export([main/1,merge_sort/1]).

merge_sort([L]) -> [L]; 

merge_sort(L)   ->
    {L1,L2} = lists:split(length(L) div 2, L),
    lists:merge(merge_sort(L1), merge_sort(L2)).


main(Args) ->

    [IP,OP]=Args,

    {ok, Binary} = file:read_file(IP),
    Lines = string:tokens(erlang:binary_to_list(Binary), " "),

    M=merge_sort(Lines),
    io:fwrite("~p~n",[Lines]),
    io:fwrite("~p~n",[M]).