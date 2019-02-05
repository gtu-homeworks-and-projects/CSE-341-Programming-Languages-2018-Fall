flight(edirne, erzurum, 5).
flight(erzurum, antalya, 2).
flight(antalya, izmir, 1).
flight(antalya, diyarbakir, 5).
flight(diyarbakir, ankara, 8).
flight(ankara, izmir, 6).
flight(izmir, istanbul, 3).
flight(istanbul, ankara, 2).
flight(istanbul, trabzon, 3).
flight(ankara, trabzon, 6).
flight(ankara, kars, 3).
flight(kars, gaziantep, 3).

route(A, B, C) :- findRoute(A, B, C, []). % Finds if there is any route given A, B, C.

findRoute(X, Y, W, V) :- is_flight(X, Y, W);
                        \+ member(X, V),
                        is_flight(X, Z, W1),
                        findRoute(Z, Y, W2, [X|V]),
                        W is W1 + W2.

is_flight(X, Z, W) :- flight(X, Z, W) ; flight(Z, X, W).