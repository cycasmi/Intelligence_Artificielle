import Logreg
import HiddenLayer


class NN(object):
    def __init__(self, input, n_in, n_hidden, n_out, batch_size):
        self.hidden = HiddenLayer.HiddenLayer()
        self.logreg = Logreg.LogisticRegression()

        self.input = 0
        self.L2 = 0
        self.params = []
        self.NLL = 0
