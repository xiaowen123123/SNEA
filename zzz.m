clc;clear;
a = rand(3);
a(1,:) = [1,2,3];
a(2,:) = [2,2,2];
c = cov(a)
d = cov(a')
cd = det(c)
dd = det(d)
