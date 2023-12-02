/* Check if a list is sorted */
isSorted([]).
isSorted([_]).
isSorted([X,Y|T]) :- X =< Y, isSorted([Y|T]).

/* combine 2 list */
concat([], L, L).
concat([X | Rest1], L2, [X | Result]) :-
    concat(Rest1, L2, Result).

/* Count occurrences of an element in a list */
count_occurrences([], _, 0).
count_occurrences([Head | Tail], Elem, Count) :-
    (   Head = Elem ->
        count_occurrences(Tail, Elem, RestCount),
        Count is RestCount + 1
    ;   count_occurrences(Tail, Elem, Count)
    ).

/* Swap elements at positions I and J in List, Result is the updated list */
swap(List, I, J, Result) :-
    nth0(I, List, ElemI),
    nth0(J, List, ElemJ),
    replace(List, I, ElemJ, Temp),
    replace(Temp, J, ElemI, Result).

/* Replace element at position Index in List with NewElem, Result is the updated list */
replace(List, Index, NewElem, Result) :-
    length(Prefix, Index),
    append(Prefix, [_ | Rest], List),
    append(Prefix, [NewElem | Rest], Result).

/* Creat a list of integers from 1 to N */
getNumberList(N, List) :-
    getNumberList(1, N, List).

getNumberList(N, N, [N]).
getNumberList(Start, End, [Start | Rest]) :-
    Start < End,
    Next is Start + 1,
    getNumberList(Next, End, Rest).

/* For Pair Sorting */

% sort_pairs([], _, _, []).
% sort_pairs([X | Xs], [Y | Ys], [Index | Indices], [X-Index-Y | Rest]) :-
%     sort_pairs(Xs, Ys, Indices, Rest).

% group_pairs_by_key([], []).
% group_pairs_by_key([X-Index-Y | Rest], [X-Group | GroupedRest]) :-
%     group_pairs_by_key(Rest, GroupedRest, X, [Index-Y | Acc], Group),
%     reverse(Acc, Group).

removeElement(X, List, NewList) :-
    select(X, List, NewList).