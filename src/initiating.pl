:- dynamic(player/6).
:- dynamic(currentPlayer/1).

initiateGame :-
    getPlayerAmount,
    getPlayerNames,
    getPlayerOrder,
    initTerritory, !.

takeLocation(Territory):-
    currentPlayer(PlayerId),
    player(PlayerId, Name, TotalTerritories, A, B, C),
    emptyTerritory(EmptyTerritory),
    listTerritory(ListTerritory),
    ( member(Territory, ListTerritory) ->
        ( member(Territory, EmptyTerritory) ->
            locationDetail(Territory, TerritoryName, _, _),
            format('~w mengambil wilayah ~w.~n', [Name, TerritoryName]),
            assertz(pemilik(Territory, Name)),
            % remove the territory from the list
            select(Territory, EmptyTerritory, UpdatedEmptyTerritory),
            retract(player(PlayerId,Name,TotalTerritories,A,B,C)),
            NewTotalTerritory is TotalTerritories + 1,
            assertz(player(PlayerId, Name, NewTotalTerritory, A, B, C)),
            retractall(emptyTerritory(_)),
            endInitialTurn,
            currentPlayer(NewPlayerId),
            player(NewPlayerId, NewName, _, _, _, _),
            (length(UpdatedEmptyTerritory, 0) ->
                write('\nSeluruh wilayah telah diambil pemain.\nMemulai pembagian sisa tentara.\n'),
                format('Giliran ~w untuk meletakkan tentaranya.~n',[NewName]),
                !   
            ;
                format('~nGiliran ~w untuk memilih wilayahnya.~n',[NewName]),
                assertz(emptyTerritory(UpdatedEmptyTerritory)),
                !
            )
        ; 
            write('Wilayah sudah dikuasai. Tidak bisa mengambil.\n'),
            format('~nGiliran ~w untuk memilih wilayahnya.~n',[Name]),
            !
        )
    ;
        format('~w bukan suatu wilayah.~n',[Territory]),
        format('~nGiliran ~w untuk memilih wilayahnya.~n',[Name]),
        !
    ).

placeTroops(Territory, Troops) :-
    currentPlayer(PlayerId),
    player(PlayerId, Name, _, _, _, _),
    listTerritory(ListTerritory),
    ( member(Territory, ListTerritory) ->
        ( pemilik(Territory, Name) ->
            ( playerTroops(PlayerId, TotalTroops), Troops =< TotalTroops ->
                totalTroops(Territory, CurrentTroops),
                NewCurrentTroops is (CurrentTroops + Troops),
                NewTotalTroops is (TotalTroops - Troops),
                retract(playerTroops(PlayerId, TotalTroops)),
                retract(totalTroops(Territory, CurrentTroops)),
                assertz(playerTroops(PlayerId, NewTotalTroops)),
                assertz(totalTroops(Territory, NewCurrentTroops)),
                locationDetail(Territory, TerritoryName, _, _),
                format('~w meletakan ~w tentara di wilayah ~w.~n', [Name, Troops, TerritoryName]),
                ( NewTotalTroops = 0 ->
                    endInitialTurn,
                    format('Seluruh tentara ~w sudah diletakkan.~n',[Name]),
                    (currentPlayer(PlayerIdCek), playerTroops(PlayerIdCek, 0) ->
                        write('\nSeluruh pemain telah meletakkan sisa tentara.\n'),
                        write('\nMemulai Permainan\n\n'),
                        !
                    ;
                        currentPlayer(NewPlayerId),
                        player(NewPlayerId, NewPlayerName, _, _, _, _),
                        format('Giliran ~w untuk meletakkan tentaranya.~n',[NewPlayerName]),
                        !
                    )
                ;
                    !
                )
            ;
                write('Tentara tidak cukup.\n'),
                format('Giliran ~w untuk meletakkan tentaranya.~n',[Name]),
                !
            )
        ;
            write('Wilayah tersebut dimiliki pemain lain .\nSilahkan pilih wilayah lainnya.\n\n'),
            format('Giliran ~w untuk meletakkan tentaranya.~n',[Name]),
            !
        )
    ;
        format('~w bukan suatu wilayah.~n~n',[Territory]),
        format('Giliran ~w untuk meletakkan tentaranya.~n',[Name]),
        !    
    ).

% placeAutomatic :- 
%     currentPlayer(PlayerId),
%     player(PlayerId, Name, _, _, _, _),
%     findall(Territory, (pemilik(Territory, Name), member(Territory, ListTerritory)), OwnedTerritories),
%     placeTroopsAutomatically(OwnedTerritories),
%     format('Automatic troop placement for ~w is done.~n', [Name]),
%     endInitialTurn.
%     !.

/* Input Amount of Player */
getPlayerAmount :-
    nl,
    repeat,
        write('Masukkan jumlah pemain: '),
        read(PlayerAmount),
    (   number(PlayerAmount), PlayerAmount >= 2, PlayerAmount =< 4 
    ->  assertz(playerAmount(PlayerAmount)), nl
    ;   write('Mohon masukkan angka antara 2 - 4.\n'),
        fail
    ).

/* Input Player Names */
getPlayerNames :- 
    playerAmount(PlayerAmount), 
    getPlayerNames(PlayerAmount, 1).

getPlayerNames(PlayerAmount, N) :- 
    N < PlayerAmount, 
    format('Masukkan nama pemain ~w: ', [N]), 
    read(PlayerName), 
    assertz(player(N, PlayerName, 0, 0, 0, 0)), 
    NewN is (N + 1), 
    getPlayerNames(PlayerAmount, NewN).

getPlayerNames(PlayerAmount, N) :- 
    N = PlayerAmount, 
    format('Masukkan nama pemain ~w: ', [N]),
    read(PlayerName), nl,
    assertz(player(N, PlayerName, 0, 0, 0, 0)).

/* Role for all player */
getAllRoles(Roles) :-
    findall(Role, (player(PlayerId, _, _, _, _, _), role2Dice(Role)), OriginalRoles),
    displayRole(OriginalRoles),
    handleReroll(OriginalRoles, Roles),
    !.

/* Handle reroll if two or more players have the highest role */
handleReroll(OriginalRoles, Roles) :-
    max_list(OriginalRoles, MaxRole),
    count_occurrences(OriginalRoles, MaxRole, Count),
    (Count >= 2 ->
        write('Terdapat dua atau lebih pemain dengan roles tertinggi. Rerolling...\n'),
        getAllRoles(Roles) % Reroll
    ;   Roles = OriginalRoles, true
    ).

/* Player Order */
getPlayerOrder :-
    playerAmount(PlayerAmount),
    getAllRoles(Roles), 
    getNumberList(PlayerAmount, InitialOrder),  
    sortPlayerOrder(Roles, InitialOrder, SortedList, PlayerOrder),
    assertz(playerOrder(PlayerOrder)),
    displayPlayerOrder, !.

/* Sort the ID based on the roles */
sortPlayerOrder(List, IdList, SortedList, SortedId) :-
    length(List, Len),
    getNumberList(1, Len, Indices),
    sort_pairs(List, IdList, Indices, SortedPairs),
    keysort(SortedPairs, ReversedPairs),
    reverse(ReversedPairs, FinalSortedPairs),
    extract_sorted_lists(FinalSortedPairs, SortedList, SortedId).

sort_pairs([], _, _, []).
sort_pairs([X | Xs], [Y | Ys], [Index | Indices], [X-Index-Y | Rest]) :-
    sort_pairs(Xs, Ys, Indices, Rest).

extract_sorted_lists([], [], []).
extract_sorted_lists([X-Index-Y | Rest], [X | XRest], [Index | IdRest]) :-
    extract_sorted_lists(Rest, XRest, IdRest).

/* Starting Troops */
addStartTroops :-
    playerAmount(PlayerAmount),
    getStartingTroops(PlayerAmount, StartingTroops),
    forall(
        player(Id, _, _, _, _, _),
        (
            assertz(playerTroops(Id, StartingTroops))
        )
    ),
    format('Setiap pemain mendapatkan ~w tentara.~n~n', [StartingTroops]).

/* Amount of Starting Troops Based on Player Amount */
getStartingTroops(PlayerAmount, StartingTroops) :-
    (
        PlayerAmount = 2 -> StartingTroops = 24
        ; PlayerAmount = 3 -> StartingTroops = 16
        ; StartingTroops = 12
    ).

/* Display role */
displayRole(Roles) :-
    playerAmount(PlayerAmount),
    displayRole(1,PlayerAmount, Roles).
displayRole(N, PlayerAmount, [H | T]) :-
    N < PlayerAmount,
    player(N, Name, _, _, _, _),
    format('~w melempar dadu dan mendapatkan ~w.', [Name, H]), nl,
    NewN is (N + 1),
    displayRole(NewN, PlayerAmount, T).
displayRole(N, PlayerAmount, [H]) :-
    N = PlayerAmount,
    player(N, Name, _, _, _, _),
    format('~w melempar dadu dan mendapatkan ~w.', [Name, H]), nl, nl.

/* Display Player Order */
displayPlayerOrder :-
    playerAmount(PlayerAmount),
    playerOrder(PlayerOrder),
    write('Urutan pemain: '),
    displayPlayerOrder(1, PlayerAmount, PlayerOrder),
    [Head | _] = PlayerOrder, 
    player(Head, Name, _, _, _, _),
    assertz(currentPlayer(Head)),
    format('~w dapat mulai terlebih dahulu.~n~n', [Name]),
    addStartTroops,
    format('Giliran ~w untuk memilih wilayahnya.~n',[Name]),
    !.
displayPlayerOrder(N, PlayerAmount, [H | T]) :-
    N < PlayerAmount,
    player(H, Name, _, _, _, _),
    format('~w - ',[Name]),
    NewN is (N + 1),
    displayPlayerOrder(NewN, PlayerAmount, T).
displayPlayerOrder(N, PlayerAmount, [H]) :-
    N = PlayerAmount,
    player(H, Name, _, _, _, _),
    write(Name), nl.

initTerritory :-
    assertz(listTerritory([na1,na2,na3,na4,na5,sa1,sa2,e1,e2,e3,e4,e5,a1,a2,a3,a4,a5,a6,a7,au1,au2,af1,af2,af3])),
    assertz(emptyTerritory([na1,na2,na3,na4,na5,sa1,sa2,e1,e2,e3,e4,e5,a1,a2,a3,a4,a5,a6,a7,au1,au2,af1,af2,af3])).

endInitialTurn :-
    playerOrder(Order),
    currentPlayer(CurrentPlayer),
    rotate(Order, NewOrder),
    nth0(0, NewOrder, NewPlayer),
    retractall(playerOrder(_)),
    retractall(currentPlayer(_)),
    assertz(playerOrder(NewOrder)),
    assertz(currentPlayer(NewPlayer)).

rotate([X | Rest], Rotated) :- append(Rest, [X], Rotated).
