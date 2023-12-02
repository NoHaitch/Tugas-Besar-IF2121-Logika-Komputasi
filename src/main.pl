% Use initialization/1 to run a goal when the program starts.
:- initialization(main).

% Define a main/0 predicate that will be called on program initialization.
main :-     
    consult('list.pl'),
    consult('dice.pl'),
    consult('display.pl'),
    consult('draft.pl'),
    consult('initiating.pl'),
    consult('map.pl'),
    consult('territory.pl'),
    consult('attack.pl'),
    consult('risk.pl'),
    consult('player.pl'),
   consult('attack.pl'),
   consult('move.pl'),
    consult('risk.pl'),
    consult('player.pl'),
    consult('endturn.pl'),
    write('===== Program Loaded ====='), nl,
    displaylogo.

/* Start Game */
startGame :-
    resetGame,
    initiateGame.

/* Reset all facts */
resetGame :-
    retractall(player(_, _, _, _, _, _)), % Player(idx, name)
    retractall(playerAmount(_)),
    retractall(playerOrder(_)),
    retractall(currentPlayer(_)),
    retractall(listTerritory(_)),
    retractall(emptyTerritory(_)),
    retractall(playerTroops(_)).