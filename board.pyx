from pyswip import Prolog
cdef class board:
    cdef public:
        str player
        object prolog
    def __init__(self, player, game_name):
        self.player = player
        self.prolog = Prolog()
        self.prolog.consult(game_name)

    cpdef list get_legal(self):
        cdef list result = list(self.prolog.query('legal(X, Y)')) 
        cdef set p1 = set()
        cdef set p2 = set()
        cdef dict res
        cdef str mv1 
        cdef str mv2

        for res in result:
            if res['X'] == self.player:
                p1.add(f"does({res['X']},{res['Y']})")
            else:
                p2.add(f"does({res['X']},{res['Y']})")

        result = []
        for mv1 in p1:
            for mv2 in p2:
                result.append([mv1, mv2])

        return result        
        
    cpdef bint is_terminate(self):
        if len(list(self.prolog.query('terminal'))):
            return True
        return False

    cpdef int get_reward(self):
        cdef int reward = int(list(self.prolog.query(f'goal({self.player}, X)'))[0]['X'])
        return reward 
    
    cpdef update_move(self, list moves):
        cdef int i
        for i in range(0, len(moves)):
            self.prolog.assertz(moves[i])

    cpdef remove_move(self, list moves):
        cdef int i
        for i in range(0, len(moves)):
            self.prolog.retractall(moves[i])

    cpdef list get_next(self):
        cdef list fact = list(self.prolog.query('next(X)'))
        cdef list result = []
        cdef str nxt
        cdef int i 
        for i in range(len(fact)):
            nxt = fact[i]['X']
            result.append(f'true({nxt})')
        return result

    cpdef list get_init(self):
        cdef list fact = list(self.prolog.query('init(X)'))
        cdef list result = []
        cdef str nxt
        cdef int i 
        for i in range(len(fact)):
            nxt = fact[i]['X']
            result.append(f'true({nxt})')
        return result
