clear;
clc;
close all force;
pd = makedist('poisson', 4);
r = random(pd,1,1);
histogram(r,100)