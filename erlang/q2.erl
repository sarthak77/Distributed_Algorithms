-module(q2).
-import(lists,[nth/2,map/2,flatten/1,merge/2,split/2]). 
-export([main/1,merge_sort/1,for/2,f/5]).



merge_sort([L]) -> [L]; 

merge_sort(L)   ->
    {L1,L2}=split(length(L) div 2, L),
    merge(merge_sort(L1), merge_sort(L2)).



% N -> index
% L -> ip list
% Fl -> flag(0 for base process)
% PID -> parent ID
% OP -> op file

f(N,L,Fl,PID,OP) ->

    LL=nth(N,L),
    SL=merge_sort(LL),

    if

        %receive all chunks and merge
        Fl == 0 ->
            if
                N == 1 ->%if only one element to sort
                    MM=flatten([io_lib:format("~p ",[V]) || V<-SL]),
                    {ok,S}=file:open(OP,[write]),
                    io:format(S,"~s",[MM]);                 
                
                N /= 1 ->
                    receive
                        {List} ->
                            M=merge(SL,List),
                            MM=flatten([io_lib:format("~p ",[V]) || V<-M]),
                            {ok,S}=file:open(OP,[write]),
                            io:format(S,"~s",[MM])
                    end
            end;

        %send sorted chunk
        N == 1 ->
            PID ! {SL};

        %merge the chunk and send
        Fl /= 0 ->
            receive
                {List} ->
                    M=lists:merge(SL,List),
                    PID ! {M}
            end

    end.



for(0,_) ->   
    []; 
   
for(N,Term) when N > 0 -> 
   
    [PPID,L,OP]=Term,
    PID=spawn(q2,f,[N,L,1,PPID,OP]),
    [[PID,L,OP]|for(N-1,[PID,L,OP])]. 



main(Args) ->

	%read arguments
    [IP,OP]=Args,

	%read from input file
    {ok,Binary}=file:read_file(IP),
    L=string:tokens(erlang:binary_to_list(Binary), " "),
    
    %convert strings to integers
    Lines=map(fun(X) -> list_to_integer(X) end,L),
    
    %set no of processes
    NOP=8,

    %calculate list size
    LS=ceil(length(Lines)/NOP),

    %split list into NOP parts
    A=[lists:sublist(Lines, X, LS) || X <- lists:seq(1,length(Lines),LS)],

    %base process for writing to file
    PID=spawn(q2,f,[length(A),A,0,0,OP]),

    %create other processes
    for(length(A)-1,[PID,A,OP]).