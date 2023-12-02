/* */
roleNDice(N, Result) :-
    roleNDice(1, N, Result).
roleNDice(I, N, Result) :-
    I < N,
    NewI is (I + 1),
    random(1, 7, OneDice),
    roleNDice(NewI, N, RestResult),
    Result is OneDice + RestResult.
roleNDice(I, N, Result) :-
    I = N,
    random(1, 7, Result).

/* Player Role */
role2Dice(PlayerRole) :- 
    roleNDice(2,PlayerRole).