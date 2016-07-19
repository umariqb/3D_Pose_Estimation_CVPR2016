close all;
clear all;

[data] = textread('angles.txt','','delimiter',' ');

nsamples = size(data,1);
nchannels = size(data,2);

%avg = mean(data);
%data = data-repmat(avg,nsamples,1);

%data = data(:,2:nchannels);
%nchannels = nchannels - 1;

frametime = 0.0333333;

ch1 = 15; i1 = 3*(ch1-1)+1; %left hip = 15
ch2 = 18; i2 = 3*(ch2-1)+1; %right hip = 18
ch3 = 16; i3 = 3*(ch3-1)+2; %left knee = 16
ch4 = 19; i4 = 3*(ch4-1)+2; %right knee = 19
ch5 = 17; i5 = 3*(ch5-1)+2; % left ankle = 17
ch6 = 20; i6 = 3*(ch6-1)+2; % right ankle = 20

subplot(6,1,1); plot([0:frametime:(nsamples-1)*frametime],data(:,i1),'black');
subplot(6,1,2); plot([0:frametime:(nsamples-1)*frametime],data(:,i2),'black');
subplot(6,1,3); plot([0:frametime:(nsamples-1)*frametime],data(:,i3),'black');
subplot(6,1,4); plot([0:frametime:(nsamples-1)*frametime],data(:,i4),'black');
subplot(6,1,5); plot([0:frametime:(nsamples-1)*frametime],data(:,i5),'black');
subplot(6,1,6); plot([0:frametime:(nsamples-1)*frametime],data(:,i6),'black');

%figure;
%plot3(data(:,i1),data(:,i1+1),data(:,i1+2));
%plot3(data(:,i2),data(:,i2+1),data(:,i2+2),'red');