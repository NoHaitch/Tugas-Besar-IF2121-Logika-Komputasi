initTerritory :-
    assertz(listTerritory([na1,na2,na3,na4,na5,sa1,sa2,e1,e2,e3,e4,e5,a1,a2,a3,a4,a5,a6,a7,au1,au2,af1,af2,af3])),
    assertz(emptyTerritory([na1,na2,na3,na4,na5,sa1,sa2,e1,e2,e3,e4,e5,a1,a2,a3,a4,a5,a6,a7,au1,au2,af1,af2,af3])).

/* FAKTA */
locationDetail(na1, 'NA1', 'Greenland', ['Amerika Serikat', 'Mexico']).
locationDetail(na2, 'NA2', 'Amerika Serikat', ['Greenland', 'Canada', 'Cuba']).
locationDetail(na3, 'NA3', 'Mexico', ['Brazil', 'Canada']).
locationDetail(na4, 'NA4', 'Canada', ['Amerika Serikat', 'Cuba']).
locationDetail(na5, 'NA5', 'Cuba', ['Amerika Serikat', 'Canada', 'Austria']).

locationDetail(sa1, 'SA1', 'Brazil', ['Mexico', 'Argentina']).
locationDetail(sa2, 'SA2', 'Argentina', ['Brazil', 'Nigeria']).

locationDetail(e1, 'E1', 'Austria', ['Cuba', 'Denmark', 'Germany']).
locationDetail(e2, 'E2', 'Denmark', ['Austria', 'Poland', 'Indonesia']).
locationDetail(e3, 'E3', 'Germany', ['Austria', 'Poland', 'Nigeria']).
locationDetail(e4, 'E4', 'Poland', ['Denmark', 'Germany', 'Kenya', 'France']).
locationDetail(e5, 'E5', 'France', ['Poland', 'Kenya', 'India']).

locationDetail(a1, 'A1', 'Indonesia', ['India', 'Denmark']).
locationDetail(a2, 'A2', 'South Korea', ['India', 'Thailand', 'Philippines']).
locationDetail(a3, 'A3', 'Japan', ['Thailand']).
locationDetail(a4, 'A4', 'India', ['France', 'Indonesia', 'South Korea', 'Thailand', 'Philippines']).
locationDetail(a5, 'A5', 'Thailand', ['Japan', 'India', 'Philippines']).
locationDetail(a6, 'A6', 'Philippines', ['South Korea', 'India', 'Thailand', 'Vietnam', 'Australia']).
locationDetail(a7, 'A7', 'Vietnam', ['Philippines']).

locationDetail(au1, 'AU1', 'Australia', ['New Zealand', 'Philippines']).
locationDetail(au2, 'AU2', 'New Zealand', ['Australia']).

locationDetail(af1, 'AF1', 'Nigeria', ['Germany', 'Kenya', 'Morocco', 'Argentina']).
locationDetail(af2, 'AF2', 'Kenya', ['Poland', 'France', 'Nigeria', 'Morocco']).
locationDetail(af3, 'AF3', 'Morocco', ['Nigeria', 'Kenya']).

continent(northamerica, [na1, na2, na3, na4, na5]).
continent(southamerica, [sa1, sa2]).
continent(europe, [e1, e2, e3, e4, e5]).
continent(asia, [a1, a2, a3, a4, a5, a6, a7]).
continent(australia, [au1, au2]).
continent(africa, [af1, af2]).

:- dynamic(pemilik/2).

:- dynamic(totalTroops/2).
totalTroops(na1, 0).
totalTroops(na2, 0).
totalTroops(na3, 0).
totalTroops(na4, 0).
totalTroops(na5, 0).
totalTroops(e1, 0).
totalTroops(e2, 0).
totalTroops(e3, 0).
totalTroops(e4, 0).
totalTroops(e5, 0).
totalTroops(a1, 0).
totalTroops(a2, 0).
totalTroops(a3, 0).
totalTroops(a4, 0).
totalTroops(a5, 0).
totalTroops(a6, 0).
totalTroops(a7, 0).
totalTroops(au1, 0).
totalTroops(au2, 0).
totalTroops(af1, 0).
totalTroops(af2, 0).
totalTroops(af3, 0).
totalTroops(sa1, 0).
totalTroops(sa2, 0).

/* RULE */
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

checkLocationDetail(X) :-
    locationDetail(X,Code,Name,Tetangga),
    write('Kode                 : '), write(Code), nl,
    write('Nama                 : '), write(Name), nl,
    write('Pemilik              : '), pemilik(X, Pemilik), write(Pemilik), nl,
    write('Total Tentara        : '), totalTroops(Code, Tentara), write(Tentara), nl,
    write('Tetangga             : '), writeList(Tetangga), nl.