from pyswip import Prolog

prolog = Prolog()
prolog.consult('game/break-through-4x4.pl')
    
for i in range(0, 1000):
    nxt = list(prolog.query('init(X)'))
    #print(nxt)
    for valid in nxt:
        prolog.asserta(f"true({valid['X']})")
    
    legal = list(prolog.query('legal(X, Y)'))
    print(len(legal))
    
    for valid in nxt:
        prolog.retractall(f"true({valid['X']})")
