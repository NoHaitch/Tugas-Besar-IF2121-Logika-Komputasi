/* FAKTA */
:- dynamic(numOfMove/1).
:- dynamic(current_player/1).
:- dynamic(totalTentara/2).

/* RULE */
isTerritory(X) :-
    northAmerica(X) ; europe(X) ; asia(X) ; southAmerica(X) ; africa(X) ; australia(X).

move(_, _, _) :-
    numOfMove(N), N >= 3,
    format('Anda telah mencapai batas maksimal pemindahan tentara.~n', []).

move(X1, X2, Y) :-
    \+ isTerritory(X1), \+ isTerritory(X2), format('Wilayah ~w dan ~w tidak valid~nPemindahan dibatalkan', [X1, X2]).

move(X1, X2, Y) :-
    \+ isTerritory(X1), format('Wilayah ~w tidak valid~nPemindahan dibatalkan', [X1]).

move(X1, X2, Y) :-
    \+ isTerritory(X2), format('Wilayah ~w tidak valid~nPemindahan dibatalkan', [X2]).

move(X1, X2, Y) :-
    currentPlayer(PlayerId), player(PlayerId, Name, _, _, _, _), \+ pemilik(X1, Name), \+ pemilik(X2, Name),
    format('~w tidak memiliki wilayah ~w dan ~w.~nPemindahan dibatalkan.~n', [Name ,X1, X2]).

move(X1, X2, Y) :-
    currentPlayer(PlayerId), player(PlayerId, Name, _, _, _, _), \+ pemilik(X1, Name),
    format('~w tidak memiliki wilayah ~w.~nPemindahan dibatalkan.~n', [Name ,X1]).

move(X1, X2, Y) :-
    currentPlayer(PlayerId), player(PlayerId, Name, _, _, _, _), \+ pemilik(X2, Name),
    format('~w tidak memiliki wilayah ~w.~nPemindahan dibatalkan.~n', [Name ,X2]).

move(X1, X2, Y) :-
    totalTroops(X1, Name), Name - Y < 1, format('Tentara tidak mencukupi.~nPemindahan dibatalkan.~n', []).

move(X1, X2, Y) :-
    currentPlayer(PlayerId), player(PlayerId, Name, _, _, _, _), format('~w memindahkan tentara dari ~w ke ~w.~n', [Name, X1, X2]),
    totalTroops(X1, Soldier1), totalTroops(X2, Soldier2),
    NewS1 is Soldier1 - Y, retract(totalTroops(X1, Soldier1)), assertz((totalTroops(X1, NewS1))),
    NewS2 is Soldier2 + Y, retract(totalTroops(X2, Soldier2)), assertz((totalTroops(X2, NewS2))),
    format('Jumlah tentara di ~w: ~w.~n', [X1, NewS1]),
    format('Jumlah tentara di ~w: ~w.~n', [X2, NewS2]),
    numOfMove(N), NewN is N + 1, retract(numOfMove(N)), assertz(numOfMove(NewN)).