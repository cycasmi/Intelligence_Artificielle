import numpy as np
import theano
import theano.tensor as T

class HiddenLayer(object):
    def __init__(self, input, n_in, n_out):
        W_values = np.asarray(
            np.random.uniform(low=-np.sqrt(6. / (n_in + n_out)),high=np.sqrt(6. / (n_in + n_out)),size=(n_in, n_out)),
            dtype=theano.config.floatX
        )
        self.W = theano.shared(value=W_values, name='Wh', borrow=True)
        b_values = np.zeros((n_out,), dtype=theano.config.floatX)
        self.b = theano.shared(value=b_values, name='bh', borrow=True)
        self.input = 0
        self.output = 0
        self.params = []


