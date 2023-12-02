:- dynamic(player/11).
:- dynamic(additional_troops/2).
:- dynamic(bonus_troops/2).

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
bonus_troops('NA', 3).
bonus_troops('E', 3).
bonus_troops('A', 5).
bonus_troops('SA', 2).
bonus_troops('AU', 1).
bonus_troops('AF', 2).

/* Fungsi untuk mengakhiri giliran */
endTurn :-
    currentPlayer(CurrentPlayerId),
    player(CurrentPlayerId, OldPlayerName, _, _, _, _),
    endInitialTurn,
    currentPlayer(NextPlayerId),
    player(NextPlayerId, PlayerName, TotalTerritories, TotalActiveTroops, TotalAddTroops, _),
    format('Player ~w mengakhiri giliran.~n~n', [OldPlayerName]),
    format('Sekarang giliran Player ~w!~n~n', [PlayerName]),
    playerTroops(NextPlayerId, TotalTroops),
    TotalAdditionalTroops is (TotalTerritories // 2),
    NewTotalTroops = (TotalTroops - TotalAdditionalTroops),
    retract(playerTroops(PlayerId, TotalTroops)),
    assertz(playerTroops(PlayerId, NewTotalTroops)),
    TotalAdd = (TotalBonusTroops + TotalAdditionalTroops),
    format('Player ~w mendapatkan ~w tentara tambahan.~n', [PlayerName, TotalAdditionalTroops]).
