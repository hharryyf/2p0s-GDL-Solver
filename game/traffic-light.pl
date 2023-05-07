role(xplayer).
role(oplayer).

init(cell(1, 1, blank)).
init(cell(1, 2, blank)).
init(cell(1, 3, blank)).
init(cell(2, 1, blank)).
init(cell(2, 2, blank)).
init(cell(2, 3, blank)).
init(cell(3, 1, blank)).
init(cell(3, 2, blank)).
init(cell(3, 3, blank)).
init(control(xplayer)).

next(cell(M, N, red)) :- does(P, mark(M, N, red)), true(cell(M, N, blank)).
next(cell(M, N, yellow)) :- does(P, mark(M, N, yellow)), true(cell(M, N, red)).
next(cell(M, N, green)) :- does(P, mark(M, N, green)), true(cell(M, N, yellow)).
next(cell(M, N, C0)) :- does(P, mark(J, K, C1)), true(cell(M, N, C0)), M \= J.
next(cell(M, N, C0)) :- does(P, mark(J, K, C1)), true(cell(M, N, C0)), N \= K.
next(control(xplayer)) :- true(control(oplayer)).
next(control(oplayer)) :- true(control(xplayer)).

legal(W, mark(X, Y, red)) :- true(cell(X, Y, blank)), true(control(W)).
legal(W, mark(X, Y, yellow)) :- true(cell(X, Y, red)), true(control(W)).
legal(W, mark(X, Y, green)) :- true(cell(X, Y, yellow)), true(control(W)).
legal(xplayer, noop) :- true(control(oplayer)).
legal(oplayer, noop) :- true(control(xplayer)).

terminal :- aline.
terminal :- not open.

goal(xplayer, 100) :- aline, true(control(oplayer)).

goal(xplayer, 50) :- not aline, not open.

goal(xplayer, 0) :- aline, true(control(xplayer)).

goal(oplayer, 100) :- aline, true(control(xplayer)).

goal(oplayer, 50) :- not aline, not open.

goal(oplayer, 0) :- aline, true(control(oplayer)).

row(M, X) :- true(cell(M, 1, X)), true(cell(M, 2, X)), true(cell(M, 3, X)).

column(N, X) :- true(cell(1, N, X)), true(cell(2, N, X)), true(cell(3, N, X)).

diagonal(X) :- true(cell(1, 1, X)), true(cell(2, 2, X)), true(cell(3, 3, X)).

diagonal(X) :- true(cell(1, 3, X)), true(cell(2, 2, X)), true(cell(3, 1, X)).

line(X) :- row(M, X).
line(X) :- column(M, X).
line(X) :- diagonal(X).

aline :- line(red).
aline :- line(yellow).
aline :- line(green).

open :- true(cell(M, N, blank)).

open :- true(cell(M, N, red)).

open :- true(cell(M, N, yellow)).
