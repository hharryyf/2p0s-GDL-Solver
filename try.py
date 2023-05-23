from pyswip import Prolog

prolog = Prolog()
prolog.consult('game/nim.pl')
    
for i in range(0, 100000):
    nxt = list(prolog.query('init(X)'))
    #print(nxt)
    for valid in nxt:
        prolog.asserta(f"true({valid['X']})")
    
    legal = list(prolog.query('legal(X, Y)'))

    p1 = []
    p2 = []
    
    print(i, len(legal))
    for res in legal:
        if res['X'] == 'xplayer':
            p1.append(f"does({res['X']},{res['Y']})")
        else:
            p2.append(f"does({res['X']},{res['Y']})")

    prolog.asserta(p1[0])
    prolog.asserta(p2[0])

    
    prolog.retractall(p1[0])
    prolog.retractall(p2[0])

    for valid in nxt:
        prolog.retractall(f"true({valid['X']})")
