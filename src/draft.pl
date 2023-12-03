/*
:- dynamic(totalTroops/2).
:- dynamic(player/12).

% (REMOVABLE) Example facts of ownership of the Territorys
pemilik(NA1, 'John').
pemilik(NA2, 'Pucky').
player(p1, 'John', [], [], [], [], [], [], 1, 12, 10, [false, false, false, false, false, false]).
currentPlayer(p1).
locationDetail(na1, 'NA1', 'Greenland', ['Amerika Serikat', 'Mexico']).
totalTroops(NA1, 5).
*/


countTerritory([], 0).
countTerritory([_ | Tail], X) :- countTerritory(Tail, Temp),
                        X is Temp + 1.

draft(CodeTerritory, Value) :- currentPlayer(IDPlayer),
        player(IDPlayer, Name, TotalTerr, TotalActive, TotalAdditional, Risk),
        locationDetail(CodeTerritory, Code, NamaDaerah, Tetangga),
        (pemilik(CodeTerritory, Name) ->
                format('Player ~w meletakkan ~w tentara tambahan di ~w ~n', [Name, Value, Code]),
                (Value < TotalAdditional -> 
                        retract(totalTroops(CodeTerritory, OldValue)),
                        retract(player(IDPlayer, Name, TotalTerr, TotalActive, TotalAdditional, Risk)),
                        NewValue is OldValue + Value,
                        NewAdditionalTroops is TotalAdditional - Value,
                        assertz(totalTroops(CodeTerritory, NewValue)),
                        assertz(player(IDPlayer, Name, TotalTerr, TotalActive, NewAdditionalTroops, Risk)),
                        format('Tentara total di ~w: ~w ~n', [Code, NewValue]),
                        format('Jumlah Pasukan Tambahan Player ~w: ~w ~n', [Name, Value])
                        ; format('Pasukan tidak mencukupi~n', []),
                        format('Jumlah Pasukan Tambahan Player ~w: ~w ~n', [Name, TotalAdditional]),
                        format('draft dibatalkan~n', []), fail)
                ;format('Player ~w tidak memiliki wilayah ~w ~n', [Name, Code]),
                fail
                ).

