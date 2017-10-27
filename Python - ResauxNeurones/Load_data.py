import theano
import numpy as np
import theano.tensor as T
import matplotlib
import matplotlib.pyplot as plt

def load_data():
    #TODO : load the data set and so it can be easily used
    #use np.load to load the data

    dataset = ( np.load('dataX.npy'), np.load('dataY.npy') )

    train_set, valid_set, test_set = (dataset, dataset, dataset)

    print ('... loading data')

    def shared_dataset(data_xy, borrow=True):
        data_x, data_y = data_xy
        shared_x = theano.shared(np.asarray(data_x, dtype=theano.config.floatX), borrow=borrow)
        shared_y = theano.shared(np.asarray(data_y, dtype=theano.config.floatX), borrow=borrow)
        return shared_x, T.cast(shared_y, 'int32')

    test_set_x, test_set_y = shared_dataset(test_set)
    valid_set_x, valid_set_y = shared_dataset(valid_set)
    train_set_x, train_set_y = shared_dataset(train_set)

    rval = [(train_set_x, train_set_y), (valid_set_x, valid_set_y),
            (test_set_x, test_set_y)]
    return rval


'''
if __name__ == '__main__':
    dataset = (np.load('dataX.npy'), np.load('dataY.npy'))
    print dataset[0].shape
    print dataset[1].shape

    print dataset.shape
'''
