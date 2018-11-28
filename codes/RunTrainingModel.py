import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, LSTM, CuDNNLSTM
import numpy as np
from sklearn.utils import shuffle

from scipy.io import loadmat
x = loadmat('save_dataset_train1.mat')
x_train = x['data']
y = loadmat('save_label_train1.mat')
y_train = y['label']

x = loadmat('save_dataset_test1.mat')
x_test = x['data']
y = loadmat('save_label_test1.mat')
y_test = y['label']
size = y_test.shape 

# print(x_train.shape)
# print(x_test.shape)
# print(y_train.shape)
# print(y_test)

model = Sequential()

# IF you are running with a GPU, try out the CuDNNLSTM layer type instead (don't pass an activation, tanh is required)
model.add(LSTM(64, input_shape=(x_train.shape[1:]), activation='relu', return_sequences=True))
model.add(Dropout(0.3))

model.add(LSTM(64, activation='relu'))
model.add(Dropout(0.3))

model.add(Dense(32, activation='relu'))
model.add(Dropout(0.3))

model.add(Dense(10, activation='softmax'))

opt = tf.keras.optimizers.RMSprop(lr=0.001, rho=0.9, epsilon=None, decay=0.0)#Adam(lr=0.001, decay=1e-6)

# Compile model
model.compile(
    loss='sparse_categorical_crossentropy',
    optimizer=opt,
    metrics=['accuracy'],
)

model.fit(x_train,
          y_train,
          epochs=250,
          validation_data=(x_test, y_test))



yhat_train = model.predict(x_train, verbose=0)
# print(yhat_train)

yhat_test = model.predict(x_test, verbose=0)
# print(yhat_test)



# printing test data confusion matrix
conf = np.zeros(shape=(10,10), dtype=int)
for i in range(19):
    x = np.where(yhat_test[i] == max(yhat_test[i]))
    conf[y_test[i][0]][x[0][0]] += 1

print("\n\n-------------------------Testing Data Confusion Matrix------------------------------------\n")
type_list = ["BEND ", "JACK ", "PJUMP", "WAVE1" ,"WAVE2", "RUN  ", "WALK ", "SIDE ", "SKIP ", "JUMP "]
print("==========================================================================================")
print("| Pred-> | BEND  | JACK  | PJUMP | WAVE1 | WAVE2 | RUN   | WALK  | SIDE  | SKIP  | JUMP  |")
print("| True   |       |       |       |       |       |       |       |       |       |       |")
print("|========================================================================================|")
for i in range(10):
    print("| ",type_list[i],"|", end="")
    for j in range(10):
        print("  ", conf[i][j], end="\t |")

    print("\n|========================================================================================|")




# printing test data confusion matrix
conf_tr = np.zeros(shape=(10,10), dtype=int)
for i in range(70):
    x = np.where(yhat_train[i] == max(yhat_train[i]))
    conf_tr[y_train[i][0]][x[0][0]] += 1

print("\n\n--------------------------Training Data Confusion Matrix----------------------------------\n")
# type_list = ["BEND ", "JACK ", "PJUMP", "WAVE1" ,"WAVE2", "RUN  ", "WALK ", "SIDE ", "SKIP ", "JUMP "]
print("==========================================================================================")
print("| Pred-> | BEND  | JACK  | PJUMP | WAVE1 | WAVE2 | RUN   | WALK  | SIDE  | SKIP  | JUMP  |")
print("| True   |       |       |       |       |       |       |       |       |       |       |")
print("|========================================================================================|")
for i in range(10):
    print("| ",type_list[i],"|", end="")
    for j in range(10):
        print("  ", conf_tr[i][j], end="\t |")

    print("\n|========================================================================================|")