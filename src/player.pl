:- dynamic(player/6).
:- dynamic(territory/2).
:- dynamic(additional_troops/2).
:- dynamic(bonus_troops/2).
:- dynamic(currentPlayer/1).
:- dynamic(player_territories/7).

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

% Fakta tentang tentara tambahan dari wilayah
additional_troops(p1, TotalAdditionalTroops).
additional_troops(p2, TotalAdditionalTroops).
additional_troops(p3, TotalAdditionalTroops).
additional_troops(p4, TotalAdditionalTroops).


% Fakta tentang tentara bonus dari wilayah
bonus_troops('NA', 3).
bonus_troops('E', 3).
bonus_troops('A', 5).
bonus_troops('SA', 2).
bonus_troops('AU', 1).
bonus_troops('AF', 2).

% Fungsi untuk menghitung banyaknya wilayah pada satu list
count([], 0) :- !.
count([_H|T], Count) :-
    count(T, CurrCount),
    Count is CurrCount + 1.

checkContinent(Player, Areas, Count) :- 
    findall(Area, pemilik(Area, Player), OwnedAreas),
    length(OwnedAreas, Count).
    
checkAreasAvail(Player) :- 
    continent(europe, Areas),
    checkContinent(Player, Areas, Count),
    (Count > 0 -> format('Europe, ', []) ; fail),
    continent(asia, Areas),
    checkContinent(Player, Areas, Count),
    (Count > 0 -> format('Asia, ', []) ; fail),
        continent(northamerica, Areas),
        checkContinent(Player, Areas, Count),
    (Count > 0 -> format('North America, ', []) ; fail),
        continent(southamerica, Areas),
        checkContinent(Player, Areas, Count),
    (Count > 0 -> format('South America, ', []) ; fail),
        continent(africa, Areas),
        checkContinent(Player, Areas, Count),
    (Count > 0 -> format('Africa', []) ; fail),
        continent(australia, Areas),
        checkContinent(Player, Areas, Continent),
    (Count > 0 -> format('Australia', []) ; fail).
        continent(australia, Areas),
        checkContinent(Player, Areas, Continent),


countTerritories(Name, Result) :- 
    findall(Area, pemilik(Area, Name), OwnedAreas),
    length(OwnedAreas, Result).



checkAUOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), australia(Territory), !)
    .
checkNAOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), northAmerica(Territory), !)
    .
checkAFOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), africa(Territory), !)
    .
checkAOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), asia(Territory), !)
    .
checkSAOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), southAmerica(Territory), !)
    .
checkEOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), europe(Territory), !)
    .

calculate_total([], 0). % Base case: Empty list has total troops 0
calculate_total([Entity|Entities], Total) :-
    totalTroops(Entity, Troops),    % Get troops for the current entity
    calculate_total(Entities, Rest), % Recursively get total for remaining entities
    Total is Troops + Rest.

countTotalActive(Player, Hasil) :-
    player(Player, Name, A, B, C, D),
    getAllOwnedTerritory(Player, Res),
    calculate_total(Res, Hasil),
    retract(player(Player, Name, A, B, C, D)),
    assertz(player(Player, Name, A, Hasil, C, D)).


% Fungsi untuk menampilkan kondisi pemain
checkPlayerDetail(Player) :-
    player(Player, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCards),
    player_territories(Name, NA, E, A, SA, AU, AF),
    getAllOwnedTerritory(Player, Result),
    write('Nama                  : '), write(Name), nl,
    write('Benua                 : '), (checkNAOwnershipTest(Player) -> write('Amerika Utara '); write('')),
                                        (checkEOwnershipTest(Player) -> write('Eropa ') ; write('')),
                                        (checkAOwnershipTest(Player) -> write('Asia ') ; write('')),
                                        (checkSAOwnershipTest(Player) -> write('Amerika Selatan ') ; write('')),
                                        (checkAUOwnershipTest(Player) -> write('Australia ') ; write('')),
                                        (checkAFOwnershipTest(Player) -> write('Afrika ') ; write('')), nl,
    write('Total Wilayah         : '), length(Result, Len), write(Len), nl,
    write('Total Tentara Aktif   : '), countTotalActive(Player, Sum), write(Sum), nl,
    write('Total Tentara Tambahan: '), write(TotalAddTroops), nl.

hitung_territory(PlayerID, ListNA, Jumlah1) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), northAmerica(Territory)), ListNA),
    length(ListNA, Jumlah1),
    Jumlah1 \= 0, write('Benua '), write('Amerika Utara '), write(Jumlah1), write('/5'), nl,
    forall(member(Territory, ListNA), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga),
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara),
    write('Jumlah tentara    : '), write(Tentara))).
hitung_territory(PlayerID, ListNA, Jumlah1) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), northAmerica(Territory)), ListNA),
    length(ListNA, Jumlah1), Jumlah1 =:= 0.

hitung_territory(PlayerID, ListE, Jumlah2) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), europe(Territory)), ListE),
    length(ListE, Jumlah2),
    Jumlah2 \= 0, write('Benua '), write('Eropa '), write(Jumlah2), write('/5'), nl,
    forall(member(Territory, ListE), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga),
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara),
    write('Jumlah tentara    : '), write(Tentara))).
hitung_territory(PlayerID, ListE, Jumlah2) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), europe(Territory)), ListE),
    length(ListE, Jumlah2), Jumlah2 =:= 0.

hitung_territory(PlayerID, ListA, Jumlah3) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), asia(Territory)), ListA),
    length(ListE, Jumlah3),
    Jumlah3 \= 0, write('Benua '), write('Asia '), write(Jumlah3), write('/7'), nl,
    forall(member(Territory, ListA), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga),
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara),
    write('Jumlah tentara    : '), write(Tentara))).
hitung_territory(PlayerID, ListA, Jumlah3) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), asia(Territory)), ListA),
    length(ListE, Jumlah3), Jumlah3 =:= 0.

hitung_territory(PlayerID, ListSA, Jumlah4) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), southAmerica(Territory)), ListSA),
    length(ListE, Jumlah4),
    Jumlah4 \= 0, write('Benua '), write('Amerika Selatan '), write(Jumlah4), write('/3'), nl,
    forall(member(Territory, ListSA), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga),
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara),
    write('Jumlah tentara    : '), write(Tentara))).
hitung_territory(PlayerID, ListSA, Jumlah4) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), southAmerica(Territory)), ListSA),
    length(ListE, Jumlah4), Jumlah4 =:= 0.

hitung_territory(PlayerID, ListAU, Jumlah5) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), australia(Territory)), ListAU),
    length(ListAU, Jumlah2),
    Jumlah5 \= 0, write('Benua '), write('Australia '), write(Jumlah5), write('/2'), nl,
    forall(member(Territory, ListAU), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga),
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara),
    write('Jumlah tentara    : '), write(Tentara))).
hitung_territory(PlayerID, ListAU, Jumlah5) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), australia(Territory)), ListAU),
    length(ListAU, Jumlah5), Jumlah5 =:= 0.

hitung_territory(PlayerID, ListAF, Jumlah6) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), africa(Territory)), ListAF),
    length(ListAF, Jumlah6),
    Jumlah6 \= 0, write('Benua '), write('Afrika '), write(Jumlah6), write('/3'), nl,
    forall(member(Territory, ListAF), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga),
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara),
    write('Jumlah tentara    : '), write(Tentara))).
hitung_territory(PlayerID, ListAF, Jumlah6) :-
    player(PlayerID, PlayerName, _, _, _, _),
    findall(Territory, (pemilik(Territory, PlayerName), africa(Territory)), ListAF),
    length(ListAF, Jumlah6), Jumlah6 =:= 0.

/*benuaNA(NA) :-
    count(NA, Value1),
    Value1 \= 0, write('Benua '), write('Amerika Utara '), write(Value1), write('/5'), nl,
    forall(member(Territory, NA), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga), 
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara), 
    write('Jumlah tentara    : '), write(Tentara))).
benuaNA(NA) :- count(NA, Value1), Value1 =:= 0.

benuaE(E) :-
    count(E, Value2), nl,
    Value2 \= 0, write('Benua '), write('Eropa '), write(Value2), write('/5'), nl,
    forall(member(Territory, E), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga), 
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara), 
    write('Jumlah tentara    : '), write(Tentara))).
benuaE(E) :- count(E, Value2), Value2 =:= 0.

benuaA(A) :-
    count(A, Value3), nl,
    Value3 \= 0, write('Benua '), write('Asia '), write(Value3), write('/7'), nl,
    forall(member(Territory, A), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga), 
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara), 
    write('Jumlah tentara    : '), write(Tentara))).
benuaA(A) :- count(A, Value3), Value3 =:= 0.

benuaSA(SA) :-
    count(SA, Value4),
    Value4 \= 0, write('Benua '), write('Amerika Selatan '), write(Value4), write('/3'), nl,
    forall(member(Territory, SA), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga), 
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara), 
    write('Jumlah tentara    : '), write(Tentara))).
benuaSA(SA) :- count(SA, Value4), Value4 =:= 0.

benuaAU(AU) :-
    count(AU, Value5),
    Value5 \= 0, write('Benua '), write('Australia '), write(Value5), write('/2'), nl,
    forall(member(Territory, AU), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga), 
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara), 
    write('Jumlah tentara    : '), write(Tentara))).
benuaAU(AU) :- count(AU, Value5), Value5 =:= 0.

benuaAF(AF) :-
    count(AF, Value6),
    Value6 \= 0, write('Benua '), write('Afrika '), write(Value6), write('/3'), nl,
    forall(member(Territory, AF), (write(Territory), nl, locationDetail(X, Territory, NameWilayah, Tetangga), 
    write('Nama              : '), write(NameWilayah), nl, totalTentara(Territory, Tentara), 
    write('Jumlah tentara    : '), write(Tentara))).
benuaAF(AF) :- count(AF, Value6), Value6 =:= 0. */


appendContinent(Player) :-
    player(Player, PlayerName, A, B, C, D),
    player_territories(PlayerName, U, V, W, X, Y, Z),
    getAllOwnedTerritory(Player, Result),
    processTerritories(Result, U, V, W, X, Y, Z, NewU, NewV, NewW, NewX, NewY, NewZ),
    retract(player_territories(PlayerName, U, V, W, X, Y, Z)),
    assertz(player_territories(PlayerName, NewU, NewV, NewW, NewX, NewY, NewZ)).

processTerritories([], U, V, W, X, Y, Z, U, V, W, X, Y, Z).
processTerritories([Terr|Rest], U, V, W, X, Y, Z, FinalU, FinalV, FinalW, FinalX, FinalY, FinalZ) :-
    (   (   member(Terr, ['na1', 'na2', 'na3', 'na4', 'na5']) ->
            append(U, [Terr], NewU)
        ;   NewU = U
    )),
    (   (   member(Terr, ['a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7']) ->
            append(W, [Terr], NewW)
        ;   NewW = W
    )),
    (   (   member(Terr, ['e1', 'e2', 'e3', 'e4', 'e5']) ->
            append(V, [Terr], NewV)
        ;   NewV = V
    )),
    (   (   member(Terr, ['sa1', 'sa2']) ->
            append(X, [Terr], NewX)
        ;   NewX = X
    )),
    (   (   member(Terr, ['au1', 'au2']) ->
            append(Y, [Terr], NewY)
        ;   NewY = Y
    )),
    (   (   member(Terr, ['af1', 'af2', 'af3']) ->
            append(Z, [Terr], NewZ)
        ;   NewZ = Z
    )),
    processTerritories(Rest, NewU, NewV, NewW, NewX, NewY, NewZ, FinalU, FinalV, FinalW, FinalX, FinalY, FinalZ).

funcCheckTerr(Player, Array) :-
    forall(member(Terr, Array),
    (
        (locationDetail(Terr, Code, NameWilayah, Tetangga),
        write(Code), nl,
        format('Nama              : ~w', [NameWilayah]), nl,
        totalTroops(Terr, Tentara),
        format('Jumlah tentara    : ~w', [Tentara]), nl)
    )).

% Fungsi untuk menampilkan wilayah yang dikuasai oleh pemain
checkPlayerTerritories(Player) :-
    player(Player, PlayerName, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCards),
    appendContinent(Player),
    player_territories(PlayerName, ListNA, ListE, ListA, ListSA, ListAU, ListAF),
    write('Nama              : '), write(PlayerName), nl, nl,
    length(ListNA, Len), (Len \= 0 -> format('Benua Amerika Utara (~w/5)', [ Len]), nl, funcCheckTerr(Player, ListNA), nl ; write('')),
    length(ListE, Len2), (Len2 \= 0 -> format('Benua Eropa (~w/5)', [ Len2]), nl, funcCheckTerr(Player, ListE), nl ; write('')),
   length(ListA, Len3), (Len3 \= 0 -> format('Benua Asia (~w/7)', [Len3]), nl, funcCheckTerr(Player, ListA), nl ; write('')),
    length(ListSA, Len4), (Len4 \= 0 -> format('Benua Afrika (~w/3)', [ Len4]), nl, funcCheckTerr(Player, ListSA), nl ; write('')),
    length(ListAU, Len5), (Len5 \= 0 -> format('Benua Australia (~w/2)', [Len5]), nl, funcCheckTerr(Player, ListAU), nl ; write('')),
    length(ListAF, Len6), (Len6 \= 0 -> format('Benua Afrika (~w/3)', [Len6]), nl, funcCheckTerr(Player, ListAF), nl ; write('')).

% Fungsi untuk menampilkan jumlah tentara tambahan pada giliran selanjutnya
checkIncomingTroops(Player) :-
    player(Player, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, Risk),
    player_territories(Player, NA, E, A, SA, AU, AF),
    findall(BonusTroops,
            (additional_troops(Player, Continent, Bonus),
             countPlayerTerritories(Player, Continent, PlayerTerritories),
             BonusTroops is PlayerTerritories // 3 + Bonus),
            BonusTroopsList),
    sum_list(BonusTroopsList, TotalBonusTroops),
    write('Nama                                    : '), write(Name), nl,
    write('Total wilayah                           : '), write(TotalTerritories), nl,
    write('Jumlah tentara tambahan dari wilayah    : '), write(TotalAdditionalTroops), nl,
    (count(NA, 5), 
    write('Bonus Benua Amerika Utara               : '), write('3'), nl ; true),
    (count(E, 5), 
    write('Bonus Benua Eropa                       : '), write('3'), nl ; true),
    (count(A, 7), 
    write('Bonus Benua Asia                        : '), write('5'), nl ; true),
    (count(SA, 3), 
    write('Bonus Benua Amerika Selatan             : '), write('2'), nl ; true),
    (count(AU, 2), 
    write('Bonus Benua Australia                   : '), write('1'), nl ; true),
    (count(AF, 3), 
    write('Bonus Benua Afrika                      : '), write('2'), nl ; true), 
    write('Total Tentara Tambahan                  : '), write(TotalAddTroops).

% Fungsi untuk menghitung jumlah wilayah pemain di suatu benua
countPlayerTerritories(Player, Continent, Count) :-
    findall(Territory, (player_territory(Player, Territory), territory(Territory, _, _, _)), Territories),
    findall(Territory, (member(Territory, Territories), member(Continent, TerritoryContinents), Continent == Continent), FilteredTerritories),
    length(FilteredTerritories, Count).

hitungWilayah(Player, Count) :-
    findall(_, pemilik(_, Player), Territories),
    length(Territories, Count).

hitungPlayer(Count) :-
    findall(_, player(_, _, _, _, _, _), S),
    length(S, Count).

% Fungsi untuk mengeksekusi serangan
kalah(PlayerAttacker, PlayerDefender, TerritoryAttacker, TroopsAttacker, TerritoryDefender, TroopsDefender) :-
    hitungWilayah(PlayerDefender, Count),
    (Count =:= 0 -> write('Jumlah wilayah Player '), write(PlayerDefender), write(' 0.'), nl,
    write('Player '), write(PlayerDefender), write(' keluar dari permainan!'), nl, 
    player(ID, PlayerDefender, A, B, C, D),
    retract(player(ID, PlayerDefender, A, B, C, D)) ; write('')
    ),
    hitungPlayer(Banyak),
    (Banyak =:= 1 -> write('******************************'), nl,
    write('*Player '), write(PlayerAttacker), write(' telah menguasai dunia*'), nl,
    write('******************************'), nl ; write('')
    ).
    