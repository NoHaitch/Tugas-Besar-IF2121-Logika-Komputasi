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

/*
groupTerritories(Player) :-
    player_territories(Player, A, B, C, D, E, F),
    retract(player_territories(Player, A, B, C, D, E, F)),
    player(ID, Player, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCards),
    getAllOwnedTerritory(ID, Territories),
    update_territories(Territories, [], [], [], [], [], [], NewNA, NewE, NewA, NewSA, NewAU, NewAF),
    assertz(player_territories(Player, NewA, NewSA, NewAU, NewNA, NewE, NewAF)).

update_territories([], NA, E, A, SA, AU, AF, NA, E, A, SA, AU, AF).
update_territories([Territory|Rest], NA, E, A, SA, AU, AF, NewNA, NewE, NewA, NewSA, NewAU, NewAF) :-
    pemilik(Territory, Player),
    (
        (northAmerica(Territory) -> append(NA, [Territory], TempNA), NewNA = TempNA),
        (asia(Territory) -> append(A, [Territory], TempA), NewA = TempA,
        (europe(Territory) -> append(E, [Territory], TempE), NewE = TempE),
        (australia(Territory) -> append(AU, [Territory], TempAU), NewAU = TempAU ),
        (africa(Territory) -> append(AF, [Territory], TempAF), NewAF = TempAF ),
        (southAmerica(Territory) -> append(SA, [Territory], TempSA), NewSA = TempSA)
    ),
    update_territories(Rest, NewNA, NewE, NewA, NewSA, NewAU, NewAF, NewNA, NewE, NewA, NewSA, NewAU, NewAF). */

    /*
    forall(member(Territory, Territories),
        (forall(
            ((australia(Territory), pemilik(Territory, Player)), append(AU, [Territory], AU))
    );
        forall(
            ((africa(Territory), pemilik(Territory, Player)), append(AF, [Territory], AF))
    );
        forall(
            ((asia(Territory), pemilik(Territory, Player)), append(A, [Territory], A))
    );
    forall(
    ((europe(Territory), pemilik(Territory, Player)), append(E, [Territory], E))
    );
    forall(
    ((northamerica(Territory), pemilik(Territory, Player)), append(NA, [Territory], NA))
    );
    forall(
    ((southamerica(Territory), pemilik(Territory, Player)), append(SA, [Territory], SA))
    ))), */


checkAUOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), australia(Territory), !).

checkNAOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), northAmerica(Territory), !).

checkAFOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), africa(Territory), !).

checkAOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), asia(Territory), !).

checkSAOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), southAmerica(Territory), !).

checkEOwnershipTest(PlayerID) :-
    player(PlayerID, PlayerName, _, _, _, _),
    (pemilik(Territory, PlayerName), europe(Territory), !).


% Fungsi untuk menampilkan kondisi pemain
checkPlayerDetail(Player) :-
    player(Player, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCards),
    player_territories(Name, NA, E, A, SA, AU, AF),
    write('Nama                  : '), write(Name), nl,
    write('Benua                 : '), (checkNAOwnershipTest(Player) -> write('Amerika Utara '); write('')),
                                        (checkEOwnershipTest(Player) -> write('Eropa ') ; write('')),
                                        (checkAOwnershipTest(Player) -> write('Asia ') ; write('')),
                                        (checkSAOwnershipTest(Player) -> write('Amerika Selatan ') ; write('')),
                                        (checkAUOwnershipTest(Player) -> write('Australia ') ; write('')),
                                        (checkAFOwnershipTest(Player) -> write('Afrika ') ; write('')), nl,
    write('Total Wilayah         : '), (countTerritories(Name, Result) -> write(Result) ; write('')), nl,
    write('Total Tentara Aktif   : '), write(TotalActiveTroops), nl,
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
    Jumlah5 \= 0, write('Benua '), write('Australia '), write(Jumlah5), write('/5'), nl,
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
    Jumlah6 \= 0, write('Benua '), write('Afrika '), write(Jumlah6), write('/5'), nl,
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

% Fungsi untuk menampilkan wilayah yang dikuasai oleh pemain
checkPlayerTerritories(Player) :-
    player(PlayerID, PlayerName, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCards),
    player_territories(Player, NA, E, A, SA, AU, AF), 
    write('Nama              : '), write(Name), nl, nl,
    hitung_territory(PlayerID, ListNA, Jumlah1), nl,
    hitung_territory(PlayerID, ListE, Jumlah2), nl,
    hitung_territory(PlayerID, ListA, Jumlah3), nl,
    hitung_territory(PlayerID, ListSA, Jumlah4), nl,
    hitung_territory(PlayerID, ListAU, Jumlah5), nl,
    hitung_territory(PlayerID, ListAF, Jumlah6), nl.

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