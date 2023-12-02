:- dynamic(player/6).
:- dynamic(territory/2).
:- dynamic(additional_troops/2).
:- dynamic(bonus_troops/2).
:- dynamic(currentPlayer/1).

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

% Fakta tentang pemain dan wilayah yang dimiliki
player_territories(p1, [], [], [], [], [], []).
player_territories(p2, [], [], [], [], [], []).
player_territories(p3, [], [], [], [], [], []).
player_territories(p4, [], [], [], [], [], []).

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


% Fungsi untuk menampilkan kondisi pemain
checkPlayerDetail(Player) :-
    player(Player, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCards),
    player_territories(Player, NA, E, A, SA, AU, AF).
    write('Nama                  : '), write(Name), nl,
    write('Benua                 : '), ((count(NA, X1), X1 \= 0, write('Amerika Utara ')), 
                                        (count(E, X2), X2 \= 0, write('Eropa ')),
                                        (count(A, X3), X3 \= 0, write('Asia ')),
                                        (count(SA, X4), X4 \= 0, write('Amerika Selatan ')),
                                        (count(AU, X5), X5 \= 0, write('Australia ')),
                                        (count(AF, X6), X6 \= 0, write('Afrika '))), nl, 
    write('Total Wilayah         : '), countTerritories(Name, Result), write(Result), nl,
    write('Total Tentara Aktif   : '), write(TotalActiveTroops), nl,
    write('Total Tentara Tambahan: '), write(TotalAddTroops), nl.

benuaNA(NA) :-
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
benuaAF(AF) :- count(AF, Value6), Value6 =:= 0.

% Fungsi untuk menampilkan wilayah yang dikuasai oleh pemain
checkPlayerTerritories(Player) :-
    player(Player, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCards),
    player_territories(Player, NA, E, A, SA, AU, AF), 
    write('Nama              : '), write(Name), nl, nl,
    benuaNA(NA), nl,
    benuaE(E), nl,
    benuaA(A), nl,
    benuaSA(SA), nl,
    benuaAU(AU), nl,
    benuaAF(AF), nl.

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
    