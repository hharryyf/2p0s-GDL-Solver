from board import board
import math
import time
class TreeNode:
    def __init__(self, parent, game, prestate=[], premove=[]):
        self.parent = parent
        if parent == None:
            self.exist_node = True
        else:
            self.exist_node = (not self.parent.exist_node) 

        self.children = []
        self.moves = []
        if parent == None:
            self.state = game.get_init()
        else:
            self.state = game.get_next()
        game.remove_move(prestate)
        game.remove_move(premove)
        game.update_move(self.state)
        #print(self.state)
        if game.is_terminate():
            reward = game.get_reward()
            if reward == 100:
                self.pn, self.dn = 0, math.inf
            else:
                # we treat draw as loss as well
                self.pn, self.dn = math.inf, 0
        else:       
            self.moves = game.get_legal()
            if self.exist_node:
                self.pn, self.dn = 1, len(self.moves)
            else:
                self.pn, self.dn = len(self.moves), 1
        #print(self.pn, self.dn, self.exist_node)
        game.remove_move(self.state)
        # print(len(self.moves))

    def best_direction(self):
        if len(self.children) == 0:
            return None
        mx = -1
        if self.exist_node:
            for i in range(0, len(self.children)):
                if self.children[i].solved():
                    continue
                if mx == -1:
                    mx = i
                elif self.children[i].pn < self.children[mx].pn:
                    mx = i
        else:
            for i in range(0, len(self.children)):
                if self.children[i].solved():
                    continue
                if mx == -1:
                    mx = i
                elif self.children[i].dn < self.children[mx].dn:
                    mx = i
        if mx == -1:
            print('bad')
        
        return self.children[mx]
    

    def solved(self):
        if self.pn == math.inf or self.dn == math.inf:
            return True 
        return False

    def expand(self, g:board):
        if self.solved():
            print('try to expand solved node')
            return
        for valid in self.moves:
            g.update_move(self.state)
            g.update_move(valid)
            nxt = TreeNode(self, g, self.state, valid)
            self.children.append(nxt)
        
        

    def update(self):
        if len(self.children) == 0:
            print('update leaf bad!!')
            return
        
        if self.exist_node:
            self.pn = self.children[0].pn
            self.dn = 0
            for child in self.children:
                self.pn = min(self.pn, child.pn)
                self.dn += child.dn
        else:
            self.dn = self.children[0].dn
            self.pn = 0
            for child in self.children:
                self.dn = min(self.dn, child.dn)
                self.pn += child.pn

        if self.solved():
            self.children.clear()

class Solver:
    def __init__(self, player, name, tl):
        self.game = board(player, name)
        self.time_limit = tl

    def solve(self):
        start = time.time()
        self.root = TreeNode(None, self.game)
        curr = self.root 
        iter = 0
        while not self.root.solved():
            iter += 1
            if iter % 100 == 0:
                print('Iteration', iter, 'pn=', self.root.pn, 'dn=', self.root.dn)

            while len(curr.children) != 0:
                nxt = curr.best_direction()
                curr = nxt

            curr.expand(self.game)

            while curr != None:

                pn = curr.pn
                dn = curr.dn
                curr.update()
                if curr.pn == pn and curr.dn == dn:
                    break
                if curr.parent != None:
                    curr = curr.parent
                else:
                    break
            if time.time() - start > self.time_limit:
                break    

        if self.root.pn == 0:
            print('SAT')
        elif self.root.dn == 0:
            print('UNSAT')
        else:
            print('UNKNOWN')


solver = Solver('xplayer', 'game/break-through-4x4.pl', 1800)
solver.solve()