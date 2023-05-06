from pyswip import Prolog
class board:
    def __init__(self, player, game_name):
        self.player = player
        self.prolog = Prolog()
        self.prolog.consult(game_name)

    def get_legal(self):
        result = list(self.prolog.query('legal(X, Y)')) 
        p1 = set()
        p2 = set()
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
        
    def is_terminate(self):
        if len(list(self.prolog.query('terminal'))):
            return True
        return False

    def get_reward(self):
        reward = int(list(self.prolog.query(f'goal({self.player}, X)'))[0]['X'])
        return reward 
    
    def update_move(self, moves):
        for mv in moves:
            self.prolog.assertz(mv)

    def remove_move(self, moves):
        for mv in moves:
            self.prolog.retractall(mv)

    def get_next(self):
        fact = list(self.prolog.query('next(X)'))
        result = []
        for l in fact:
            nxt = l['X']
            result.append(f'true({nxt})')
        return result

    def get_init(self):
        fact = list(self.prolog.query('init(X)'))
        result = []
        for l in fact:
            nxt = l['X']
            result.append(f'true({nxt})')
        return result
