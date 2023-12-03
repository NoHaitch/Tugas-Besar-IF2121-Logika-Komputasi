:- dynamic(player/11).
:- dynamic(additional_troops/2).
:- dynamic(bonus_troops/2).
:- dynamic(numOfMove/2).

writeList([]) :-
    write('').

writeList([H]) :-
    write(H).

writeList([H|T]) :-
    write(H),
    writeListTail(T).

writeListTail([]) :-
    write('').

writeListTail([H|T]) :-
    write(', '),
    write(H),
    writeListTail(T).

% Fakta tentang tentara bonus dari wilayah
% bonus_troops('NA', 3).
% bonus_troops('E', 3).
% bonus_troops('A', 5).
% bonus_troops('SA', 2).
% bonus_troops('AU', 1).
% bonus_troops('AF', 2).


/* Fungsi untuk mengakhiri giliran */
endTurn :-
    retractall(numOfMove(_)),
    assertz(numOfMove(0)),
    currentPlayer(CurrentPlayerId),
    player(CurrentPlayerId, OldPlayerName, _, _, _, _),
    endInitialTurn,
    currentPlayer(NextPlayerId),
    player(NextPlayerId, PlayerName, TotalTerritories, TotalActiveTroops, TotalAddTroops, _),
    format('Player ~w mengakhiri giliran.~n~n', [OldPlayerName]),
    format('Sekarang giliran Player ~w!~n', [PlayerName]),
    playerTroops(NextPlayerId, TotalTroops),
    getAdditionalTroops(TotalAdditionalTroops),
    NewTotalTroops is (TotalTroops + TotalAdditionalTroops),
    retract(playerTroops(NextPlayerId, TotalTroops)),
    assertz(playerTroops(NextPlayerId, NewTotalTroops)),
    retract(player(NextPlayerId, PlayerName, TotalTerritories, TotalActiveTroops, TotalAddTroops, Risk)),
    assertz(player(NextPlayerId, PlayerName, TotalTerritories, TotalActiveTroops, NewTotalTroops, Risk)),
    format('Player ~w mendapatkan ~w tentara tambahan.~n~n', [PlayerName, TotalAdditionalTroops]).

getAdditionalTroops(Result) :-
    currentPlayer(PlayerId),
    player(PlayerId, Name, TotalTerritories, _, _, Risk),
    (Risk =:= 6 -> format('Player ~w terdampak SUPPLY CHAIN ISSUE! ~nPlayer ~w tidak akan mendapat tentara tambahan~n', [Name, Name]), Result is 0 ;
        Risk =:= 3 ->
        Result1 is TotalTerritories // 2,
        (checkNAOwnership -> Result2 is Result1 + 3 ; Result2 is Result1),
        (checkEOwnership -> Result3 is Result2 + 3 ; Result3 is Result2),
        (checkAOwnership -> Result4 is Result3 + 5 ; Result4 is Result3),
        (checkSAOwnership -> Result5 is Result4 + 2 ; Result5 is Result4),
        (checkAUOwnership -> Result6 is Result5 + 1 ; Result6 is Result5),
        (checkAFOwnership -> Result7 is Result6 + 2 ; Result7 is Result6),
        Result is Result7 * 2,
        format('Player ~w mendapatkan AUXILIARY TROOPS!~n', [Name])
    ;
    Result1 is TotalTerritories // 2,
    (checkNAOwnership -> Result2 is Result1 + 3 ; Result2 is Result1),
    (checkEOwnership -> Result3 is Result2 + 3 ; Result3 is Result2),
    (checkAOwnership -> Result4 is Result3 + 5 ; Result4 is Result3),
    (checkSAOwnership -> Result5 is Result4 + 2 ; Result5 is Result4),
    (checkAUOwnership -> Result6 is Result5 + 1 ; Result6 is Result5),
    (checkAFOwnership -> Result7 is Result6 + 2 ; Result7 is Result6),
    Result is Result7).

checkAUOwnership:-
    currentPlayer(CurrentPlayer),
    player(CurrentPlayer, PlayerName, _, _, _, _),
    (   
        forall(
            (australia(Territory), pemilik(Territory, Owner), Owner \= PlayerName),
            fail
        )
    ->
        true
    ;
        false
    ).

checkNAOwnership:-
    currentPlayer(CurrentPlayer),
    player(CurrentPlayer, PlayerName, _, _, _, _),
    (   
        forall(
            (northAmerica(Territory), pemilik(Territory, Owner), Owner \= PlayerName),
            fail
        )
    ->
        true
    ;
        false
    ).

checkAOwnership:-
    currentPlayer(CurrentPlayer),
    player(CurrentPlayer, PlayerName, _, _, _, _),
    (   
        forall(
            (asia(Territory), pemilik(Territory, Owner), Owner \= PlayerName),
            fail
        )
    ->
        true
    ;
        false
    ).

checkSAOwnership:-
    currentPlayer(CurrentPlayer),
    player(CurrentPlayer, PlayerName, _, _, _, _),
    (   
        forall(
            (southAmerica(Territory), pemilik(Territory, Owner), Owner \= PlayerName),
            fail
        )
    ->
        true
    ;
        false
    ).

checkEOwnership:-
    currentPlayer(CurrentPlayer),
    player(CurrentPlayer, PlayerName, _, _, _, _),
    (   
        forall(
            (europe(Territory), pemilik(Territory, Owner), Owner \= PlayerName),
            fail
        )
    ->
        true
    ;
        false
    ).

checkAFOwnership :-
    currentPlayer(CurrentPlayer),
    player(CurrentPlayer, PlayerName, _, _, _, _),
    (   
        forall(
            (africa(Territory), pemilik(Territory, Owner), Owner \= PlayerName),
            fail
        )
    ->
        true
    ;
        false
    ).