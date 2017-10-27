import theano
import theano.tensor as T
import Logreg
import Load_data
import numpy as np



def sgd_optimization(learning_rate=0.13, n_epochs=1000,
                           batch_size=300):
    datasets = Load_data.load_data()

    train_set_x, train_set_y = datasets[0]
    valid_set_x, valid_set_y = datasets[1]
    test_set_x, test_set_y = datasets[2]

    # TODO : compute number of minibatches for training, validation and testing from the size of a minibatch
    n_train_batches = train_set_x.get_value(borrow=True).shape[0] #batch_size
    n_valid_batches = valid_set_x.get_value(borrow=True).shape[0]
    n_test_batches = test_set_x.get_value(borrow=True).shape[0]

    #TODO : 1.3.1
    index = theano.tensor.lscalar()
    x = T.matrix('x')
    y = T.vector('y',dtype='int32')

    logreg = Logreg.LogisticRegression(input=x, n_in=32*32, n_out=10, batch_size=batch_size)
    cost = logreg.loss

    test_model = theano.function(
        #TODO
        inputs=[index],
        outputs=logreg.errors(y),
        givens={
            x: test_set_x[index*batch_size: (index + 1)*batch_size],
            y: test_set_y[index*batch_size: (index + 1)*batch_size]
        }

    )
    validate_model = theano.function(
        #TODO
        inputs=[index],
        outputs=logreg.errors(y),
        givens={
            x: valid_set_x[index*batch_size: (index + 1)*batch_size],
            y: valid_set_y[index*batch_size: (index + 1)*batch_size]
        }
    )

    g_W = T.grad(cost, logreg.W)#TODO
    g_b = T.grad(cost, logreg.b)#TODO

    updates = [(logreg.W, logreg.W - learning_rate * g_W),
               (logreg.b, logreg.b - learning_rate * g_b)]
    train_model = theano.function(
        #TODO
        inputs=[index],
        outputs= cost,
        givens={
            x: train_set_x[index*batch_size: (index + 1)*batch_size],
            y: train_set_y[index*batch_size: (index + 1)*batch_size]
        }
    )
    #TODO : 1.3.2
    examples = 4000
    improvement = 0.995
    more_examples = 2
    valid_freq = min(n_train_batches, examples/2)
    best_params = None
    best_valid_error = np.inf
    test_result = 0
    epoch = 0

    while epoch < n_epochs:
        epoch = epoch + 1
        for minibatch_index in range(n_train_batches):
            # TODO train model
            train_average_cost = train_model(minibatch_index)

            iterator = (epoch - 1) * n_train_batches + minibatch_index

            # TODO : valid model, print error
            if (iterator + 1) % valid_freq == 0:
                valid_errors = [validate_model(i)
                              for i in range (n_valid_batches)]
                valid_error = np.mean(valid_errors)

                print "The validation error until now:", valid_error

                if valid_error < best_valid_error*improvement:
                    examples = max(examples, iterator * more_examples)

                best_valid_error = valid_error

                # TODO : test model, print result
                test_errors = [test_model(i)
                                  for i in range (n_test_batches)]
                test_result = np.mean(test_errors)
                print "The best result: ", test_result

    print "The best validation error: ", best_valid_error
    print "The test result: ", test_result

    #TODO : plot with matplotlib the train NLL and the error on test for each minibatch/epoch
    from mpl_toolkits.mplot3d import Axes3D


if __name__ == '__main__':
    n_epochs=0;batch_size=0;learning_rate=0
    sgd_optimization(n_epochs,batch_size, learning_rate)
