import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
keras = tf.keras


f = lambda x:x**2*np.sin(6*np.pi*x)+ 0.2*x*np.cos(30*x)

a,b = 0,1
n_train = 150
x_train = np.linspace(a,b,n_train)
y_train = f(x_train)

print("x_train ndim =", x_train.ndim, " | shape =", x_train.shape)

#--------------------------------------------------

model = keras.Sequential()
model.add(keras.layers.Dense(100, activation="relu", input_shape=(1,)))
model.add(keras.layers.Dense(100, activation="relu"))
model.add(keras.layers.Dense(100, activation="relu"))
model.add(keras.layers.Dense(1, activation=None))

print(model.summary())

#--------------------------------------------------

# model.compile(loss="categorical_crossentropy", optimizer=["sgd"], metrics=["acc] racy"])
model.compile(loss="mse", optimizer="adam")
model.fit(x_train, y_train, epochs=500)

n_test = 51
x_test = np.linspace(a, b, n_test)
y_test = model.predict(x_test)
print("p =", "error =", np.abs(f(x_test)-y_test))


do_plot = True
if do_plot:
    plt.grid()
    plt.plot(x_train, y_train, 'o')
    plt.plot(x_test, y_test, "d-")
    plt.show()
