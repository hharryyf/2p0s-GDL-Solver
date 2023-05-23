role(xplayer).
role(oplayer).

init(heap(a, 1)).
init(heap(b, 5)).
init(heap(c, 4)).
init(heap(d, 2)).

init(control(xplayer)).

legal(P, noop) :- true(control(X)), role(P), X \= P.

legal(P, reduce(X, N)) :- true(control(P)), true(heap(X, M)), smaller(N, M).

next(heap(X, N)) :- does(P, reduce(X, N)).

next(heap(X, N)) :- true(heap(X, N)), does(P, reduce(Y, M)), X \= Y.


next(control(P2)) :- true(control(P1)), next_player(P1, P2).

terminal :- true(heap(a, 0)), true(heap(b, 0)), true(heap(c, 0)), true(heap(d, 0)).

goal(P, 0) :- true(control(P)).

goal(P, 100) :- true(control(P1)), next_player(P, P1).

smaller(X, Y) :- succ(X, Y).

smaller(X, Y) :- succ(X, Z), smaller(Z, Y).

next_player(xplayer, oplayer).
next_player(oplayer, xplayer).

succ(0, 1).
succ(1, 2).
succ(2, 3).
succ(3, 4).
succ(4, 5).
succ(5, 6).
succ(6, 7).
succ(7, 8).
succ(8, 9).
succ(9, 10).
succ(10, 11).
succ(11, 12).
succ(12, 13).
succ(13, 14).
succ(14, 15).
succ(15, 16).
succ(16, 17).
succ(17, 18).
succ(18, 19).
succ(19, 20).
succ(20, 21).
succ(21, 22).
succ(22, 23).
succ(23, 24).
succ(24, 25).
succ(25, 26).
succ(26, 27).

