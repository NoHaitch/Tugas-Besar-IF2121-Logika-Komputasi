/*Fakta*/
northAmerica(na1).
northAmerica(na2).
northAmerica(na3).
northAmerica(na4).
northAmerica(na5).
europe(e1).
europe(e2).
europe(e3).
europe(e4).
europe(e5).
asia(a1).
asia(a2).
asia(a3).
asia(a4).
asia(a5).
asia(a6).
asia(a7).
southAmerica(sa1).
southAmerica(sa2).
africa(af1).
africa(af2).
africa(af3).
australia(au1).
australia(au2).

:- dynamic(totalTroops/2).

/*Rule*/
displayMap :-
    totalTroops(na1, X1),
    totalTroops(na2, X2),
    totalTroops(na3, X3),
    totalTroops(na4, X4),
    totalTroops(na5, X5),
    totalTroops(e1, X6),
    totalTroops(e2, X7),
    totalTroops(e3, X8),
    totalTroops(e4, X9),
    totalTroops(e5, X10),
    totalTroops(a1, X11),
    totalTroops(a2, X12),
    totalTroops(a3, X13),
    totalTroops(a4, X14),
    totalTroops(a5, X15),
    totalTroops(a6, X16),
    totalTroops(a7, X17),
    totalTroops(au1, X18),
    totalTroops(au2, X19),
    totalTroops(af1, X20),
    totalTroops(af2, X21),
    totalTroops(af3, X22),
    totalTroops(sa1, X23),
    totalTroops(sa2, X24),
    format('#################################################################################################\n', []),
    format('#         North America         #        Europe            #                 Asia               #\n', []),
    format('#                               #                          #                                    #\n', []),
    format('#       [NA1(~w)]-[NA2(~w)]       #                          #                                    #\n', [X1, X2]),
    format('-----------|       |----[NA5(~w)]----[E1(~w)]-[E2(~w)]----------[A1(~w)] [A2(~w)] [A3(~w)]--------\n', [X5, X6, X7, X11, X12, X13]),
    format('#       [NA3(~w)]-[NA4(~w)]       #       |       |          #        |       |       |           #\n', [X3, X4]),
    format('#          |                    #    [E3(~w)]-[E4(~w)]    ####     |       |       |              #\n', [X8, X9]),
    format('###########|#####################       |       |-[E5(~w)]-----[A4(~w)]----+----[A5(~w)]           #\n', [X10, X14, X15]),
    format('#          |                    ########|#######|###########             |                      #\n', []),
    format('#       [SA1(~w)]                #       |       |          #             |                      #\n', [X23]),
    format('#          |                    #       |    [AF2(~w)]      #          [A6(~w)]---[A7(~w)]         #\n', [X21, X16, X17]),
    format('#   |---[SA2(~w)]---------------------[AF1(~w)]---|          #             |                      #\n', [X24, X20]),
    format('#   |                           #               |          ##############|#######################\n', []),
    format('#   |                           #            [AF3(~w)]      #             |                      #\n', [X22]),
    format('----|                           #                          #          [AU1(~w)]---[AU2(~w)]-------\n', [X18, X19]),
    format('#                               #                          #                                    #\n', []),
    format('#       South America           #         Africa           #          Australia                 #\n', []),
    format('#################################################################################################\n', []).