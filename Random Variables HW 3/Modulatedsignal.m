%%Random Variables and Processes
%% Hendrick Ambroise

%Draw 1000 samples from a uniform distribution with limits -pi to +pi
N = [1000, 1];
r = unifrnd(-pi, pi, N);
figure
histogram(r);
xlabel("Value")
ylabel("Frequency")
title("Uniform distribution with limits -pi to pi")

%Draw 1000 samples from a Gaussian distribution with mean=0 and variance=1
mean(r)

var(r)

g = randn(N);

mean(g)
var(g)
figure
histogram(g)
xlabel("Value")
ylabel("Frequency")
title("Gaussian distribution with mean=0 and variance=1")



%Draw 1000 samples from a Gaussian distribution with mean=0 and variance=1
gg = g*sqrt(5) + 10;

mean(gg)

var(gg)
figure
histogram(gg)
title("Gaussian distribution with mean=10 and variance=5")
xlabel("Value")
ylabel("Frequency")



