%% Takes in the saved values from previous porcessing and plots them together 
%% initalising
clc, clear all, close all

%load saved data from averages of trials
ls = load("lsmean.mat");
ms = load("msmean.mat");
hs = load("hsmean.mat");
vb = load("vbmean.mat");
vbls = load("vblsmean.mat");

%set up ranges to plot the loaded data
points = 0:1:30;
pointsvb = 0:1:65;
smoothpoints = 0:0.1:8;
smoothpointsvib = 0:0.1:8;

%save the mazes from the loaded data to display with the graphs 
[maxls,maxlsi] = max(ls.smoothaverage);
[maxhs,maxhsi] = max(hs.smoothaverage);
[maxms,maxmsi] = max(ms.smoothaverage);
[maxvb,maxvbi] = max(vb.smoothaverage);
[maxlsvb,maxlsvbi] = max(vbls.smoothaverage);

%% Plotting
%plotting the raw average over all trials for speed 
figure(1) 
hold on
errorbar(points,ls.rawaverage(49:79),ls.rerr(49:79),'LineWidth',2) %plot the graph with the error bars using SEM
errorbar(points,ms.rawaverage,ms.rerr,'LineWidth',2) %plot the graph with the error bars using SEM
errorbar(points,hs.rawaverage,hs.rerr,'LineWidth',2) %plot the graph with the error bars using SEM

legend({'0.1 mm/s','0.5 mm/s','0.75 mm/s'},'FontSize',12)

title("Raw Mean Force for all speeds")
xlabel("Time(100ms)")
ylabel("Force (mN)")

% plotting the smoothed average for all means for speed
figure(2)
hold on
errorbar(smoothpoints,ls.smoothaverage(41:121),ls.err(41:121),'LineWidth',2) %plot the graph with the error bars using SEM

errorbar(smoothpoints,ms.smoothaverage,ms.err,'LineWidth',2) %plot the graph with the error bars using SEM

errorbar(smoothpoints,hs.smoothaverage,hs.err,'LineWidth',2) %plot the graph with the error bars using SEM

%plot the max points on the same graph
plot(smoothpoints(maxlsi-41),maxls,'k*','LineWidth',2)
plot(smoothpoints(maxhsi),maxhs,'k*','LineWidth',2)
plot(smoothpoints(maxmsi),maxms,'k*','LineWidth',2)

legend({'0.1 mm/s','0.5 mm/s','0.75 mm/s','Max Force'},'FontSize',12)

title("Smoothed Mean Force curve for all speeds",'FontSize',14)
xlabel("Time (s)",'FontSize',14)
ylabel("Force (mN)",'FontSize',14)

hold off

% plotting the raw average for all means for vibration
figure(3)
hold on
errorbar(pointsvb,vbls.rawaverage,vbls.rerr) %plot the graph with the error bars using SEM
errorbar(pointsvb,vb.rawaverage(6:end),vb.rerr(6:end)) %plot the graph with the error bars using SEM

legend({'no vibration','167 Hz'},'FontSize',12)

title("Raw Mean Force curve with and without vibration")
xlabel("Time (s)")
ylabel("Force (mN)")

hold off

% plotting the smoothed average for all means for vibration
figure(4)
hold on
errorbar(smoothpointsvib,vbls.smoothaverage(21:101),vbls.err(21:101),'LineWidth',2) %plot the graph with the error bars using SEM
errorbar(smoothpointsvib,vb.smoothaverage(21:101),vb.err(21:101),'LineWidth',2) %plot the graph with the error bars using SEM

plot(smoothpointsvib(maxlsvbi-21),maxlsvb,'k*','LineWidth',2)
plot(smoothpointsvib(maxvbi-21),maxvb,'k*','LineWidth',2)

legend({'no vibration','167 Hz','Max Force'},'FontSize',12)

title("Smoothed Mean Force curve with and without vibration",'FontSize',14)
xlabel("Time(s)",'FontSize',14)
ylabel("Force (mN)",'FontSize',14)

hold off

% plotting the low speed no vibration tests for both trials, speed and
% vibration 
figure(5)
hold on
errorbar(pointsvb,vbls.rawaverage,vbls.rerr) %plot the graph with the error bars using SEM
errorbar(pointsvb,ls.rawaverage(1:66),ls.rerr(1:66)) %plot the graph with the error bars using SEM

legend({'no vibration low speed','low speed trial'},'FontSize',12)

title("Comparing low speed trials")
xlabel("Time (s)")
ylabel("Force (mN)")

hold off

%plotting speed maxes 
%save the speed range and the max values for comparative plotting 
speed = [0.1,0.5,0.75];
maxs = [maxls,maxms,maxhs];

figure(6)
plot(speed,maxs,'LineWidth',2)
title("Relationship of max force for all speeds")
xlabel("Speed (mm/s)")
ylabel("Force (mN)")