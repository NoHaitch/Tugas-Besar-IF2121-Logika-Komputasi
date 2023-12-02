card(0, cease).
card(1, ss).
card(2, aux).
card(3, rebel).
card(4, dis).
card(5, sup).


% Untuk data card yang dimiliki player merupakan array berisi 6 integer
% player(p1, '', TotalTerritories, TotalActiveTroops, TotalAddTroops, [false, false, false, false, false, false]).
% array paling terakhir berisi kartu risk yang dimiliki oleh pengguna
% indeks 0: ceasefire, 1: super soldier, 2: auxiliary, 3: rebelion, 4: disease, 5: supply chain
risk :-
    random(0, 6, N),
    currentPlayer(IDPlayer),
    player(IDPlayer, NamePlayer, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard),
    card(N, Card),
    riskCard(Card, IDPlayer).


riskCard(cease, Player) :- ceasefire(Player).
riskCard(ss, Player) :- superSoldier(Player).
riskCard(aux, Player) :- auxiliary(Player).
riskCard(rebel, Player) :- rebelion(Player).
riskCard(dis, Player) :- disease(Player).
riskCard(sup, Player) :- supplychain(Player).


ceasefire(P) :-
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [Bool, _, _, _, _, _])),
    Bool is 1,
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [Bool, _, _, _, _, _])),
    format('Player ~w mendapatkan risk card CEASEFIRE ORDER.~nHingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.~n', [Name]).
     /* Player menjadi kebal untuk satu putaran */

/* Semua hasil lemparan dadu player untuk turn selanjutnya selalu 6*/
superSoldier(P) :- 
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, Bool, _, _, _, _])),
    Bool is 1,
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, Bool, _, _, _, _])),
    format('Player ~w mendapatkan risk card SUPER SOLDIER SERUM.~nHingga giliran berikutnya, semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.~n', [Name]).

/* Jumlah tentara yang ditambahkan menjadi 2x kali lipatnya */
auxiliary(P) :- 
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, Bool, _, _, _])),
    Bool is 1,
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, Bool, _, _, _])),
    format('Player ~w mendapatkan risk card AUXILIARY TROOPS.~nPada giliran berikutnya, tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.~n', [Name]).

/* Salah satu wilayah yang dikuasai akan menjadi milik lawan (acak) */
rebelion(P) :- 
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, _, Bool, _, _])),
    Bool is 1,
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, _, Bool, _, _])),
    format('Player ~w mendapatkan risk card REBELION.~nSalah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.~n', [Name]).

/* Semua hasil lemparan dadu player untuk turn selanjutnya akan selalu bernilai 1 */
disease(P) :- 
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, _, _, Bool, _])),
    Bool is 1,
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, _, _, Bool, _])),
    format('Player ~w mendapatkan risk card SUPER SOLDIER SERUM.~nHingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.~n', [Name]).

/* Jumlah tentara tambahan akan 0 di turn selanjutnya */
supplychain(P) :- 
    retract(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, _, _, _, Bool])),
    Bool is 1,
    assertz(player(ID, Name, TotalTerritories, TotalActiveTroops, TotalAddTroops, [_, _, _, _, _, Bool])),
    format('Player ~w mendapatkan risk card SUPER SOLDIER SERUM.~nHingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.~n', [Name]).
