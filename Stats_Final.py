import math
from scipy import stats
import numpy
sample_data = [11, 15, 17, 27, 20, 17, 13, 22, 17]
mean = numpy.mean(sample_data)
median = numpy.median(sample_data)
mode = stats.mode(sample_data)
data_range = numpy.ptp(sample_data, axis=0)
sum_squared = sum(sample_data)**2
sum_of_squares = sum([i**2 for i in sample_data])
stdev = numpy.std(sample_data)

n = 12.0
sum_of_y = 305.0
sum_of_x = 112.0
sum_of_ysq = 9988.0
sum_of_xsq = 1424.0
sum_of_xy = 3452.0
x_bar = sum_of_x/n
y_bar = sum_of_y/n
b1 = sum_of_xy/sum_of_xsq
b0 = y_bar - x_bar * b1
corrcoef = ((n * sum_of_xy) - (sum_of_x * sum_of_y))/(math.sqrt((n * sum_of_xsq - (sum_of_x**2))*(n * sum_of_ysq - (sum_of_y**2))))
print("The average X value is: " + str(x_bar))
print("The average Y value is: " + str(y_bar))
print("The regression model intercept is: " + str(b0))
print("The slope of the regression model is: " + str(b1))
print("The correlation coefficient is: "+str(corrcoef))
x_input = float(input("Enter X Value: "))
regression = x_input * b1 + b0
print("The best predicted value of Y given an X of " + str(x_input) +" is: "+str(regression))

# given with a normal distribution
import math
bicycle_price_mean = 140.00
bicycle_price_variance = 324.00
bicycle_price_stdev = math.sqrt(bicycle_price_variance)
print("The standard deviation is: " + str(bicycle_price_stdev))
lower_bound = 115.00
upper_bound = 135.00
zlower = (lower_bound - bicycle_price_mean)/bicycle_price_stdev
zupper = (upper_bound - bicycle_price_mean)/bicycle_price_stdev
print(zlower, zupper)
probability = round((100 * (stats.norm.cdf(zlower) - stats.norm.cdf(zupper))), 4)
print("The probability of attaining a bicycle between " + str(lower_bound) + " and " + str(upper_bound) + " is: "+str(probability) + "%")
z_new = (150.00 - bicycle_price_mean)/bicycle_price_stdev
prob2 = round((100 * (1-stats.norm.cdf(z_new))), 4)
print("The probability that the mean of bicycle prices will be over 150 is: " + str(prob2) + "%")

x = numpy.array([3.0, 5.0, 7.0, 9.0, 11.0], dtype=float)
P_of_X = numpy.array([0.5, 0.1, 0.2, 0.1, 0.1], dtype=float)
expected_x = x * P_of_X
mean = sum(expected_x)
variance = sum(x**2 * P_of_X) - mean**2
stdev = variance**0.5
print(mean, variance, stdev)

import scipy
invoices_paid = 0.85
invoices_not_paid = 0.15
n = 9
chosen7 = 7
combinations7 = scipy.special.comb(n, chosen7)
prb_of_7 = round(100 * combinations7 * (invoices_paid**chosen7) * (invoices_not_paid**(n-chosen7)), 4)
print("The probability of exactly 7 invoices being paid with a random sample of 9 is " + str(prb_of_7) + "%")
prb_of_fewer_than_2 = sum(numpy.array([100 * scipy.special.comb(n, x) * (invoices_paid**x) * (invoices_not_paid**(n-x)) for x in range(2)]))
print("The probability of fewer than 2 invoices being paid with a random sample of 9 is " + str(prb_of_fewer_than_2) + "%")


mean = 55.0
stdev = 4.2
problem1 = 50.0
problem2 = 52.0
problem3 = 65.0
zpa = (problem1-mean)/stdev
zpb = (problem2-mean)/stdev
zpc = (problem3-mean)/stdev
prb_a = round(100*(0.5-stats.norm.cdf(zpa)), 4)
prb_b = round(100*(0.5+stats.norm.cdf(zpb)), 4)
prb_c = round(100*(stats.norm.cdf(zpc)), 4)
print("With a mean of " + str(mean) + " and a standard deviation of " + str(stdev) + ":\n")
print("The probability of a mean less than " + str(problem1) + " is: " + str(prb_a) + "%\n")
print("The probability of a mean greater than " + str(problem2) + " is: " + str(prb_b) + "%\n")
print("The probability of a mean less than " + str(problem3) + " is: " + str(prb_c) + "%\n")

import math
from scipy import stats
n = 81.0
mean = 88.0
stdev = 12.2
confidence_interval = 0.924
alpha = (1-confidence_interval)/2.
print(stats.norm.interval(confidence_interval,loc=mean,scale=stdev/math.sqrt(n)))

import math
from scipy import stats
import numpy
small_sample = numpy.array([8.2, 10.4, 7.8, 7.5, 8.1, 6.8, 7.2])
confidence_interval = 0.9
mean = sum(small_sample)/len(small_sample)
stdev = numpy.std(small_sample)
print(stats.norm.interval(confidence_interval,loc=mean,scale=stdev/math.sqrt(len(small_sample))))

import random
def rollDie(number):
    counts = [0] * 6
    for i in range(number):
        roll = random.randint(1,6)
        counts[roll - 1] += 1
    return counts

print(rollDie(6))

odd_total = 0
five_or_eight = 0
less_than_8 = 0

for i in range(100):
    d1, d2 = rollDie(1)
    if (d1 + d2) % 2 == 0:
        odd_total += 1
    if d1 + d2 == 5 or d1 + d2 == 8:
        five_or_eight += 1
    if d1 + d2 < 8:
        less_than_8 += 1

print(odd_total,five_or_eight,less_than_8)



