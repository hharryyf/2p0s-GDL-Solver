from board import board
import math
import time

cdef float R = 0.5

cdef class TreeNode:
    
    cdef public:
        TreeNode parent 
        float pn
        float dn
        float deep 
        int depth
        list children 
        list moves 
        list state
        bint exist_node
    def __cinit__(self, TreeNode parent, object game, list prestate=[], list premove=[], int d=1):
        #print('start create node')
        self.parent = parent
        if parent == None:
            self.exist_node = True
        else:
            self.exist_node = (not self.parent.exist_node) 

        self.depth = d
        self.deep = 1.0 / self.depth
        self.children = []
        self.moves = []
        if parent == None:
            self.state = game.get_init()
        else:
            self.state = game.get_next()
        #print(len(prestate), len(premove), len(self.state))
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
        #print('finish create node')

    cpdef float dpn(self):
        if self.exist_node:
            return (1.0 - 1.0 / self.dn) * R + self.deep * (1.0 - R)
        else:
            return (1.0 - 1.0 / self.pn) * R + self.deep * (1.0 - R)

    cpdef TreeNode best_direction(self):
        cdef int mx = -1
        cdef int i
        if len(self.children) == 0:
            return None
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
                elif self.children[i].dpn() < self.children[mx].dpn():
                    mx = i
        
        return self.children[mx]
    

    cpdef bint solved(self):
        if self.pn == math.inf or self.dn == math.inf:
            return True 
        return False

    cpdef expand(self, object g):
        cdef list valid
        cdef TreeNode nxt
        #print('start expand')
        for valid in self.moves:
            g.update_move(self.state)
            g.update_move(valid)
            nxt = TreeNode(self, g, self.state, valid, self.depth + 1)
            self.children.append(nxt)
        #print('end expand')
        

    cpdef update(self):
        cdef TreeNode child
        cdef TreeNode c = None
        if self.exist_node:
            self.pn = self.children[0].pn
            self.dn = 0
            mx = -1
            for child in self.children:
                self.pn = min(self.pn, child.pn)
                self.dn += child.dn
                if child.solved() == False:
                    if c == None:
                        c = child 
                    elif c.dpn() > child.dpn():
                        c = child

        else:
            self.dn = self.children[0].dn
            self.pn = 0
            for child in self.children:
                self.dn = min(self.dn, child.dn)
                self.pn += child.pn
                if child.solved() == False:
                    if child.solved() == False:
                        if c == None:
                            c = child 
                        elif c.dpn() > child.dpn():
                            c = child

        if c != None:
            self.deep = c.deep
        
        if self.solved():
            self.children.clear()
        


cdef class Solver:
    cdef public:
        TreeNode root
        object game
        int time_limit
    def __cinit__(self, str player, str name, int tl):
        self.game = board(player, name)
        self.time_limit = tl
        self.root = TreeNode(None, self.game)

    cpdef solve(self):
        cdef float start = time.perf_counter()
        cdef TreeNode curr = self.root 
        cdef int iter = 0
        cdef float pn 
        cdef float dn
        cdef TreeNode nxt
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
                d = curr.deep
                curr.update()
                if curr.pn == pn and curr.dn == dn and curr.deep == d:
                    break
                if curr.parent != None:
                    curr = curr.parent
                else:
                    break
            if time.perf_counter() - start > self.time_limit:
                break    

        print('Time consumed', (time.perf_counter() - start))
        if self.root.dn == math.inf:
            print('SAT')
        elif self.root.pn == math.inf:
            print('UNSAT')
        else:
            print('UNKNOWN')


# solver = Solver('red', 'game/connect-4-5x5.pl', 1800)
# solver.solve()
