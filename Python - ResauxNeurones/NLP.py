import matplotlib.pyplot as plt
import numpy as np
import theano
import theano.tensor as T

import NeuralNet
import Load_data


def test_mlp(learning_rate, L2_reg, n_epochs, batch_size, n_hidden1):
    datasets = Load_data.load_data()

    train_x, train_y = datasets[0]
    valid_x, valid_y = datasets[1]
    test_x, test_y = datasets[2]

    # compute number of minibatches for training, validation and testing
    n_train_batches = train_x.get_value(borrow=True).shape[0] // batch_size
    n_valid_batches = valid_x.get_value(borrow=True).shape[0] // batch_size
    n_test_batches = test_x.get_value(borrow=True).shape[0] // batch_size

    n_in = 28 * 28
    n_out = 10

    index = T.lscalar()
    x = T.matrix('x')
    y = T.ivector('y')

    NNet = NeuralNet.NN(x, n_in, n_hidden1, n_out, batch_size)
    cost = NNet.NLL(y) + L2_reg * NNet.L2

    test_model = theano.function(
        inputs=[index],
        outputs=NNet.logreg.errors(y),
        givens={
            x: test_x[index * batch_size:(index + 1) * batch_size],
            y: test_y[index * batch_size:(index + 1) * batch_size]
        }
    )
    validate_model = theano.function(
        inputs=[index],
        outputs=NNet.logreg.errors(y),
        givens={
            x: valid_x[index * batch_size:(index + 1) * batch_size],
            y: valid_y[index * batch_size:(index + 1) * batch_size]
        }
    )

    updates = [
        (param, param - learning_rate * T.grad(cost, param))
        for param in NNet.params
        ]
    train_model = theano.function(
        inputs=[index],
        outputs=cost,
        updates=updates,
        givens={
            x: train_x[index * batch_size: (index + 1) * batch_size],
            y: train_y[index * batch_size: (index + 1) * batch_size]
        }
    )

    best_validation_loss = np.inf
    best_iter = 0
    test_score = 0.
    epoch = 0
    done_looping = False
    err = 1;
    thr = 0.001
    ndiv = 0
    valErr = []
    testErr = []
    testind = []

    print('training....')

    while ((not done_looping) and (epoch < n_epochs)):
        epoch = epoch + 1
        for minibatch in range(n_train_batches):
            minibatch_avg_cost = train_model(minibatch)

        validation_losses = [validate_model(i) for i in range(n_valid_batches)]
        this_validation_loss = np.mean(validation_losses)
        print('epoch %i, validation error %f %%' %
              (epoch, this_validation_loss * 100.)
              )
        # valErr.append(this_validation_loss)
        if this_validation_loss < best_validation_loss:
            best_validation_loss = this_validation_loss
            # test it on the test set
            test_losses = [test_model(i) for i in range(n_test_batches)]
            test_score = np.mean(test_losses)

            print(('     epoch %i, test error of best model %f %%') %
                  (epoch, test_score * 100.))
            testErr.append(test_score)
            testind.append(epoch)
        if (err - this_validation_loss < thr):
            if ndiv > 2:
                done_looping = True
                break
            else:
                ndiv = ndiv + 1
                thr = thr / 10.0
                learning_rate = learning_rate / 5.0
        err = (10 * err + this_validation_loss) / 11.0
    test_losses = [test_model(i) for i in range(n_test_batches)]
    test_score = np.mean(test_losses)

    # print(('     epoch %i, test error of best model %f %%') %
    #              (epoch, test_score * 100.))
    testErr.append(test_score)
    testind.append(epoch)
    print(('Optimization complete. Best validation score of %f %% '
           ' with test performance %f %%') %
          (best_validation_loss * 100., test_score * 100.))
    plt.plot(range(0, len(valErr)), valErr)
    plt.plot(testind, testErr)
    plt.show()
