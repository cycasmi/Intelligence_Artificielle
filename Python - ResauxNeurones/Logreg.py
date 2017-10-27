import theano
import theano.tensor as T
import numpy as np

class LogisticRegression(object):

    def __init__(self, input, n_in, n_out, batch_size):
        #initialisation des paramtres
        self.W = theano.shared(
            value=np.ones((n_in, n_out),dtype=theano.config.floatX),
            name='W',
            borrow=True
        )
        self.b = theano.shared(
            value=np.ones((n_out,),dtype=theano.config.floatX),
            name='b',
            borrow=True
        )
        #TODO
        self.p_y_given_x = T.nnet.softmax(T.dot(self.W, input)+self.b)
        #calcul de l'output
        self.y_pred = T.argmax(self.p_y_given_x, axis=1)
        self.params = [self.W,self.b]
        self.input = input

#******************************************
    #calcul de la NLL
    def loss(self, y):
        return -T.mean(T.log(self.p_y_given_x)[T.arange(y.shape[0]), y.shape[0]])

    #calcul de l'erreur
    def errors(self, y):
        #TODO
        return T.mean(T.neq(self.y_pred, y))
