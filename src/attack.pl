/* FAKTA */
neighbors(na1, [na2, na3], ['na2', 'na3']).
neighbors(na2, [na1, na4, na5], ['na1', 'na4', 'na5']).
neighbors(na3, [sa1, na4], ['sa1', 'na4']).
neighbors(na4, [na2, na5], ['na2', 'na5']).
neighbors(na5, [na2, na4, e1], ['na2', 'na4', 'e1']).

neighbors(sa1, [na3, sa2], ['na3', 'sa2']).
neighbors(sa2, [sa1, af1], ['sa1', 'af1']).

neighbors(e1, [na5, e2, e3], ['na5', 'e2', 'e3']).
neighbors(e2, [e1, e4, a1], ['e1', 'e4', 'a1']).
neighbors(e3, [e1, e4, af1], ['e1', 'e4', 'af1']).
neighbors(e4, [e2, e3, af2, e5], ['e2', 'e3', 'af2', 'e5']).
neighbors(e5, [e4, af2, a4], ['e4', 'af2', 'a4']).

neighbors(a1, [a4, e2], ['a4', 'e2']).
neighbors(a2, [a4, a5, a6], ['a4', 'a5', 'a6']).
neighbors(a3, [a5], ['a5']).
neighbors(a4, [e5, a1, a2, a5, a6], ['e5', 'a1', 'a2', 'a5', 'a6']).
neighbors(a5, [a3, a4, a6], ['a3', 'a4', 'a6']).
neighbors(a6, [a2, a4, a5, a7, au1], ['a2', 'a4', 'a5', 'a7', 'au1']).
neighbors(a7, [a6], ['a6']).

neighbors(au1, [au2, a6], ['au2', 'a6']).
neighbors(au2, [a1], ['a1']).

neighbors(af1, [e3, af2, af3, sa2], ['e3', 'af2', 'af3', 'sa2']).
neighbors(af2, [e4, e5, af1, af3], ['e4', 'e5', 'af1', 'af3']).
neighbors(af3, [af1, af2], ['af1', 'af2']).

:- dynamic(totalTentara/2).
totalTentara('na1', 0).
totalTentara('na2', 0).
totalTentara('na3', 0).
totalTentara('na4', 0).
totalTentara('na5', 0).
totalTentara('e1', 0).
totalTentara('e2', 0).
totalTentara('e3', 0).
totalTentara('e4', 0).
totalTentara('e5', 0).
totalTentara('a1', 0).
totalTentara('a2', 0).
totalTentara('a3', 0).
totalTentara('a4', 0).
totalTentara('a5', 0).
totalTentara('a6', 0).
totalTentara('a7', 0).
totalTentara('au1', 0).
totalTentara('au2', 0).
totalTentara('af1', 0).
totalTentara('af2', 0).
totalTentara('af3', 0).
totalTentara('sa1', 0).
totalTentara('sa2', 0).

printList([], _) :- nl.
printList([H | T], I) :- 
    write(I), write('. '), write(H), nl, I1 is I + 1,
    printList(T, I1).

count([], 0).
count([_|List], Count):- count(List, C1), Count is (C1+1).

checkAttackableTerritory(X) :-
    neighbors(X, List, ListString), 
    printList(ListString, 1).

battle(IDPlayer, AttackerTerritory, DefenderTerritory, NumAttacker, NumDefender, Defender) :-
    player(IDPlayer, Attacker, _, _, _, RiskCardAttacker),
    player(_, Defender, _, _, _, RiskCardDefender),

    throwDice(NumAttacker, AttackerDice, Attacker),
    (
        RiskCardAttacker =:= 2 ->
        write('Player '), write(Attacker), write(' memiliki risk card DISEASE.Semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1.'), nl,
        retract(player(IDPlayer, Attacker, _, _, _, RiskCard)), asserta(player(_, Attacker, _, _, _, 0))
    ;
        RiskCardAttacker =:= 5 ->
        write('Player '), write(Attacker), write(' memiliki risk card SUPER SOLDIER SERUM. Semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.'), nl,
        retract(player(IDPlayer, Attacker, _, _, _, RiskCard)), asserta(player(_, Attacker, _, _, _, 0))
    ;
        write('')
    ),
    
    write('Player '), write(Attacker), nl,
    printDice(AttackerDice, 1),
    sumList(AttackerDice, AttackerTotal),
    write('Total: '), write(AttackerTotal), nl,

    throwDice(NumDefender, DefenderDice, Defender),
    (
        RiskCardDefender =:= 5 ->
        write('Player '), write(Defender), write(' memiliki risk card DISEASE. Semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1.'), nl,
        retract(player(_, Defender, _, _, _, RiskCardAttacker)), asserta(player(_, Defender, _, _, _, 0))
    ;
        RiskCardDefender =:= 2 ->
        write('Player '), write(Defender), write(' memiliki risk card SUPER SOLDIER SERUM. Semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.'), nl,
        retract(player(_, Defender, _, _, _, RiskCardDefender)), asserta(player(_, Defender, _, _, _, 0))
    ;
        write('')
    ),
    write('Player '), write(Defender), nl,
    printDice(DefenderDice, 1),
    sumList(DefenderDice, DefenderTotal),
    write('Total: '), write(DefenderTotal), nl,

    (AttackerTotal > DefenderTotal ->
        format('Player ~w menang! Wilayah ~w sekarang dikuasai oleh Player ~w.~n', [Attacker, DefenderTerritory, Attacker]),
        write('Silahkan tentukan banyaknya tentara yang menetap di wilayah '), write(DefenderTerritory), write(': '), read(NewArmies),
        NewArmies > 1, 
        NewArmies =< NumAttacker,
        moveArmies(AttackerTerritory, DefenderTerritory, Attacker, Defender, NewArmies),
        write('Tentara di wilayah '), write(AttackerTerritory), write(': '), write(AttackerArmies - NewArmies), nl,
        write('Tentara di wilayah '), write(DefenderTerritory), write(': '), write(NewArmies), nl
    ;
        format('Player ~w kalah! Sayang sekali penyerangan Anda gagal. Seluruh tentara yang dikirim hangus.~n', [Attacker]), 
        retract(totalTroops(AttackerTerritory, NumArmy)),
        NewNumArmy is NumArmy - NumAttacker,
        asserta(totalTroops(AttackerTerritory, NewNumArmy)),
        write('Tentara di wilayah '), write(AttackerTerritory), write(': '), write(NewNumArmy), nl,
        write('Tentara di wilayah '), write(DefenderTerritory), write(': '), write(NumDefender), nl
    ).

throwDice(0, [], Owner).
throwDice(N, [Result | Rest], Owner) :-
    player(_, Owner, _, _, _, RiskCard),
    (   
        RiskCard =:= 5 -> 
        Result is 1
    ;
        RiskCard =:= 2 ->
        Result is 6
    ;
        random(1, 7, Hasil),
        Result is Hasil
    ),
    N1 is N - 1,
    throwDice(N1, Rest, Owner).

printDice([], _) :- nl.
printDice([H | T], I) :-
    write('Dadu '), write(I), write(': '), write(H), nl, I1 is I + 1, 
    printDice(T, I1).

sumList([], 0).
sumList([X], X).
sumList([X|List], Sum):- sumList(List, S1), Sum is (S1+X).

moveArmies(AttackerTerritory, DefenderTerritory, Attacker, Defender, NewArmies) :-
    retract(pemilik(DefenderTerritory, Defender)),
    retract(totalTroops(AttackerTerritory, AttackerArmies)),
    retract(totalTroops(DefenderTerritory, DefenderArmies)),
    
    NewAttackerArmies is AttackerArmies - NewArmies,
    NewDefenderArmies is NewArmies,
    
    asserta(pemilik(DefenderTerritory, Attacker)),
    asserta(totalTroops(AttackerTerritory, NewAttackerArmies)),
    asserta(totalTroops(DefenderTerritory, NewDefenderArmies)).

:-dynamic(currentPlayer/1).

count([], 0).
count([_|List], Count):- count(List, C1), Count is (C1+1).

validArmy(NumAttacker, NumArmy) :-
    repeat,
    write('Masukkan banyak tentara yang akan bertempur: '),
    read(Input),
    (   number(Input), Input >= 1, Input < NumArmy ->
        NumAttacker is Input, nl
    ;   write('Banyak tentara tidak valid. Silahkan input kembali.'), nl,
        fail
    ).

attack :- 
    currentPlayer(IDPlayer), player(IDPlayer, Attacker, TotalTerritories, TotalActiveTroops, TotalAddTroops, RiskCard),
    write('Sekarang giliran Player '), write(Attacker), write(' untuk menyerang.'), nl,
    displayMap,
    repeat,
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(AttackerTerritory),
    pemilik(AttackerTerritory, Owner),
    (   Owner \== Attacker ->
        write('Daerah tidak valid. Silahkan input kembali.'), nl,
        fail
    ;
        write('')
    ),
    totalTroops(AttackerTerritory, NumArmy), NumArmy > 1, 
    write('Dalam daerah '), write(AttackerTerritory), write(', Anda memiliki sebanyak '), write(NumArmy), write(' tentara.'), nl,

    validArmy(NumAttacker, NumArmy),
    write('Player '), write(Attacker), write(' mengirim sebanyak '), write(NumAttacker), write(' tentara untuk berperang.'), nl,

    displayMap,
    write('Pilihlah daerah yang ingin Anda serang: \n'),
    checkAttackableTerritory(AttackerTerritory),
    neighbors(AttackerTerritory, List, ListString),
    repeat,
    write('Pilih: '),
    read(Input),
    count(ListString, Count),
    (
        number(Input), Input >= 1, Input =< Count ->
        nth1(Input, ListString, Territory),
        pemilik(Territory, Owner1),
        player(_, Owner1, _, _, _, A),
        (
            Owner1 \== Attacker ->
            (
                A =:= 1 ->
                write('Tidak bisa menyerang! Wilayah ini dalam pengaruh CEASEFIRE ORDER.'), nl,
                retract(player(_, Owner1, _, _, _, A)), asserta(player(_, Owner1, _, _, _, 0)),
                fail
            ;
                Pilihan is Input, nl, !
            )
        ;
            write('Anda Tidak Bisa Menyerang Diri Sendiri.'), nl,
            fail
        )
    ;
        write('Input tidak valid. Silahkan input kembali.'), nl,
        fail
    ),
    nth1(Pilihan, ListString, DefenderTerritory),
    pemilik(Territory, Defender),
    totalTroops(DefenderTerritory, NumDefender),

    write('Perang telah dimulai.'), nl,
    battle(IDPlayer, AttackerTerritory, DefenderTerritory, NumAttacker, NumDefender, Defender),
    endTurn.