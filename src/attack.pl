/* FAKTA */
neighbors(NA1, [NA2, NA3], ['NA2', 'NA3']).
neighbors(NA2, [NA1, NA4, NA5], ['NA1', 'NA4', 'NA5']).
neighbors(NA3, [SA1, NA4], ['SA1', 'NA4']).
neighbors(NA4, [NA2, NA5], ['NA2', 'NA5']).
neighbors(NA5, [NA2, NA4, E1], ['NA2', 'NA4', 'E1']).

neighbors(SA1, [NA3, SA2], ['NA3', 'SA2']).
neighbors(SA2, [SA1, AF1], ['SA1', 'AF1']).

neighbors(E1, [NA5, E2, E3], ['NA5', 'E2', 'E3']).
neighbors(E2, [E1, E4, A1], ['E1', 'E4', 'A1']).
neighbors(E3, [E1, E4, AF1], ['E1', 'E4', 'AF1']).
neighbors(E4, [E2, E3, AF2, E5], ['E2', 'E3', 'AF2', 'E5']).
neighbors(E5, [E4, AF2, A4], ['E4', 'AF2', 'A4']).

neighbors(A1, [A4, E2], ['A4', 'E2']).
neighbors(A2, [A4, A5, A6], ['A4', 'A5', 'A6']).
neighbors(A3, [A5], ['A5']).
neighbors(A4, [E5, A1, A2, A5, A6], ['E5', 'A1', 'A2', 'A5', 'A6']).
neighbors(A5, [A3, A4, A6], ['A3', 'A4', 'A6']).
neighbors(A6, [A2, A4, A5, A7, AU1], ['A2', 'A4', 'A5', 'A7', 'AU1']).
neighbors(A7, [A6], ['A6']).

neighbors(AU1, [AU2, A6], ['AU2', 'A6']).
neighbors(AU2, [A1], ['A1']).

neighbors(AF1, [E3, AF2, AF3, SA2], ['E3', 'AF2', 'AF3', 'SA2']).
neighbors(AF2, [E4, E5, AF1, AF3], ['E4', 'E5', 'AF1', 'AF3']).
neighbors(AF3, [AF1, AF2], ['AF1', 'AF2']).

:- dynamic(pemilik/2). /*
pemilik('NA1', ' ').
pemilik('NA2', ' ').
pemilik('NA3', ' ').
pemilik('NA4', ' ').
pemilik('NA5', ' ').
pemilik('E1', ' ').
pemilik('E2', ' ').
pemilik('E3', ' ').
pemilik('E4', ' ').
pemilik('E5', ' ').
pemilik('A1', ' ').
pemilik('A2', ' ').
pemilik('A3', ' ').
pemilik('A4', ' ').
pemilik('A5', ' ').
pemilik('A6', ' ').
pemilik('A7', ' ').
pemilik('AU1', ' ').
pemilik('AU2', ' ').
pemilik('AF1', ' ').
pemilik('AF2', ' ').
pemilik('AF3', ' ').
pemilik('SA1', ' ').
pemilik('SA2', ' '). */

:- dynamic(totalTroops/2).
totalTroops('NA1', 0).
totalTroops('NA2', 0).
totalTroops('NA3', 0).
totalTroops('NA4', 0).
totalTroops('NA5', 0).
totalTroops('E1', 0).
totalTroops('E2', 0).
totalTroops('E3', 0).
totalTroops('E4', 0).
totalTroops('E5', 0).
totalTroops('A1', 0).
totalTroops('A2', 0).
totalTroops('A3', 0).
totalTroops('A4', 0).
totalTroops('A5', 0).
totalTroops('A6', 0).
totalTroops('A7', 0).
totalTroops('AU1', 0).
totalTroops('AU2', 0).
totalTroops('AF1', 0).
totalTroops('AF2', 0).
totalTroops('AF3', 0).
totalTroops('SA1', 0).
totalTroops('SA2', 0).

printList([], _) :- nl.
printList([H | T], I) :- 
    write(I), write('. '), write(H), nl, I1 is I + 1,
    printList(T, I1).

count([], 0).
count([_|List], Count):- count(List, C1), Count is (C1+1).

checkAttackableTerritory(X) :-
    neighbors(X, List, ListString), 
    printList(ListString, 1).

battle(AttackerTerritory, DefenderTerritory, NumAttacker, Defender) :-
    totalTroops(DefenderTerritory, NumDefender), nl,
    currentPlayer(IDPlayer), player(IDPlayer, Attacker, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard),
    (   
        RiskCard =:= 2 -> 
        write('Player '), write(Defender), write(' memiliki risk card DISEASE.~nSemua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1.~n'), nl
    ),

    (   
        RiskCard =:= 5 ->
        write('Player '), write(Attacker), write(' memiliki risk card SUPER SOLDIER SERUM.~nSemua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.~n'), nl   
    ),

    throwDice(NumAttacker, AttackerDice),
    (
        RiskCard =:= 2 ; RiskCard =:= 5 ->
        retract(player(IDPlayer, Attacker, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard)), asserta(player(IDPlayer, Attacker, NA, E, A, SA, AU, AF, TotalTerritories, TotalActiveTroops, TotalAddTroops, 0))
    ),
    
    pemilik(AttackerTerritory, Attacker),
    write('Player '), write(Attacker), nl,
    printDice(AttackerDice, 1),
    sumList(AttackerDice, AttackerTotal),
    write('Total: '), write(AttackerTotal), nl,

    throwDice(NumDefender, DefenderDice),
    write('Player '), write(Defender), nl,
    printDice(DefenderDice, 1),
    sumList(DefenderDice, DefenderTotal),
    write('Total: '), write(DefenderTotal), nl,

    (AttackerTotal > DefenderTotal ->
        format('Player ~w menang! Wilayah ~w sekarang dikuasai oleh Player ~w.~n', [Attacker, DefenderTerritory, Attacker]),
        write('Silahkan tentukan banyaknya tentara yang menetap di wilayah ', DefenderTerritory, ': '), read(NewArmies),
        moveArmies(AttackerTerritory, DefenderTerritory, NewArmies)
    ;
    format('Player ~w kalah! Sayang sekali penyerangan Anda gagal. Seluruh tentara yang dikirim hangus.~n', [Attacker])).

throwDice(0, []).
throwDice(N, [Result | Rest]) :-
    currentPlayer(IDPlayer), player(IDPlayer, Attacker, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard),
    (
        RiskCard =:= 2 ->
        Result is 6
    ),

    (
        RiskCard =:= 5 ->
        Result is 1
    ),

    random(1, 7, Result),
    N1 is N - 1,
    throwDice(N1, Rest).

printDice([], _) :- nl.
printDice([H | T], I) :-
    write('Dadu '), write(I), write(': '), write(H), nl, I1 is I + 1, 
    printDice(T, I1).

sumList([], 0).
sumList([X], X).
sumList([X|List], Sum):- sumList(List, S1), Sum is (S1+X).

moveArmies(AttackerTerritory, DefenderTerritory, NumArmies, Attacker, Defender) :-
    retract(pemilik(DefenderTerritory, Defender)),
    retract(totalTroops(AttackerTerritory, AttackerArmies)),
    retract(totalTroops(DefenderTerritory, DefenderArmies)),
    
    NewAttackerArmies is AttackerArmies - NumArmies,
    NewDefenderArmies is NumArmies,
    
    asserta(pemilik(DefenderTerritory, Attacker)),
    asserta(totalTroops(AttackerTerritory, NewAttackerArmies)),
    asserta(totalTroops(DefenderTerritory, NewDefenderArmies)).

:-dynamic(currentPlayer/1).

count([], 0).
count([_|List], Count):- count(List, C1), Count is (C1+1).

validTerritory(AttackerTerritory, List) :-
    repeat,
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(Input),
    (   \+ nonmember(Input, List) ->
        AttackerTerritory is Input, nl
    ;   write('Daerah tidak valid. Silahkan input kembali.'), nl,
        fail
    ).

validArmy(NumAttacker, NumArmy) :-
    repeat,
    write('Masukkan banyak tentara yang akan bertempur: '),
    read(Input),
    (   number(Input), Input >= 1, Input < NumArmy ->
        NumAttacker is Input, nl
    ;   write('Banyak tentara tidak valid. Silahkan input kembali.'), nl,
        fail
    ).

validOption(Pilihan, List) :-
    repeat,
    write('Pilih: '),
    read(Input),
    count(List, Count),
    (   number(Input), Input >= 1, Input =< Count ->
        Pilihan is Input, nl
    ;   write('Input tidak valid. Silahkan input kembali.'), nl,
        fail
    ).

attack :- 
    currentPlayer(IDPlayer), player(IDPlayer, Attacker, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard),
    write('Sekarang giliran Player '), write(Attacker), write('untuk menyerang.'), nl,
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '), read(AttackerTerritory), 
    totalTroops(AttackerTerritory, NumArmy), NumArmy > 1, 
    write('Dalam daerah '), write(AttackerTerritory), write(', Anda memiliki sebanyak '), write(NumArmy), write(' tentara.'),

    validArmy(NumAttacker, NumArmy),

    write('Pilihlah daerah yang ingin Anda serang: \n'),
    checkAttackableTerritory(AttackerTerritory),
    neighbors(AttackerTerritory, List, ListString),
    validOption(Pilihan, List),
    nth1(Pilihan, ListString, DefenderTerritory),

    write('Perang telah dimulai.'),
    battle(AttackerTerritory, DefenderTerritory, NumAttacker).