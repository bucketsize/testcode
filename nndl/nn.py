import numpy as np

class NN:
    def __init__(self, L):
        # layer and nodes per layer; layer 1 being input 
        self.L = L
   
        # biases for nodes, except layer 1
        self.B = [np.random.randn(y, 1) for y in L[1:]]
        
        # weight pairs for node in Layer [(1, 2), ..., (n-1, n)]     
        self.W = [np.random.randn(y, x) for x,y in zip(L[:-1], L[1:])]

    def dumps(self):
        print("L:", self.L)
        print("W:", list(map(lambda x: x.shape,self.W)))
        print("B:", list(map(lambda x: x.shape,self.B)))

    def cost(self, x):
        for w,b in zip(self.W, self.B):
            x = sigmoid(np.dot(w, x) + b)
        return x

def sigmoid(x):
    return 1.0/(1.0+np.exp(-x))

def to_np(x, size=1):
    if size > 1:
        return np.transpose(np.array(x))
    else:
        return np.transpose(np.array([x]))

nn = NN([2,3,1])
nn.dumps()
print(nn.cost(to_np([.4,.7])))
print(nn.cost(to_np([.5,.3])))
print(nn.cost(to_np([[.4,.7],[.5,.3]], size=2)))
