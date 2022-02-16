%% Takes in raw speed test data,smoothes and aligns around the insertion point
%% Initalising 
clc, clear all, close all

startest = 1; %set the test to start processing 
tests =10; %the test which you wish to finish processing
%startest-tests+1 = number of trials looked at 

meanrange = 10; %range of values which the data is smoothed over 

s =30; %point in raw data for start of insertion alignment 
l =120; %point in raw data for end of insertion alignment
points = 0:1:l+s; %points for graphing insetion alignment graphs 

in = 1; % if there is an insertion time = 1 otherwise 0

maxinf =6; %cap for forces, above which is considered noise

%the range around the insertion point that covers the insertion peak 
intrange = 80; %LOW range around the insertion point that covers the insertion peak 
%intrange = 30; %MEDIUM or HIGH range around the insertion point that covers the insertion peak 

intime = 0:1:intrange; %range for plotting the insertion peak 

%% Data processing 
for i =startest:tests
   %load in data for a test 
   input = append('sdnoGWls/test',int2str(i),'.xlsx'); %open the file, making sure to include the folder in the opening path
   data = readtable(input); %read the file
   smoothed = data.Load_mN_; %save the orignal data values for smoothing
   
   %find the insertion point 
   if in ==1
   indexpoint = round((data.intime(1)+0.1)*10); %from the data take the time of insertion and align with the index value for the timestamp 
   else
       indexpoint = round((length(smoothed)/2));
   end

   %smooth the data 
   %generate values which allow for full smoothing
   rateofchange = diff(smoothed); %use diff to find the rate of change between each point
   force = zeros(length(rateofchange)+1+2*meanrange,1); %array which is padded with zeros for the size of the meanrange to allow for smoothing of the first and last values 
   b = 1;
   for a = meanrange+1:length(rateofchange)+meanrange+1
        force(a) = smoothed(b); %add the data points in the apppropriate location based on padding 
        b = b+1;
   end 

   %remove peaks with values above the cut off point 
   for a = 1:length(smoothed) %for all values 
        if smoothed(a)>maxinf || smoothed(a)<-1 % if too high or too low
            %take the range of values around the rate spike 
            meanval = force(a:a+meanrange-1); %these are the start values
            meanval = [meanval;force(a+meanrange+2:a+meanrange*2)]; %these are the end values 
            smoothed(a)= mean(meanval);%find the mean of the value range  
        end
   end

    %plot the data without the large noisy peaks 
   figure(1)
   hold on
   plot(data.Time_sec__,smoothed);
   if in ==1
   plot(data.Time_sec__(indexpoint),smoothed(indexpoint),'*r');
   plot(data.Time_sec__(indexpoint+intrange),smoothed(indexpoint+intrange),'*g');
   end
   hold off 

   %align and plot the data without the noisy peaks  
   figure(2)
   hold on
   plot(intime,smoothed(indexpoint:indexpoint+intrange));
   if in ==1
   plot(intime(1),smoothed(indexpoint),'*r');
   plot(intime(1+intrange),smoothed(indexpoint+intrange),'*g');
   end
   hold off 
    
   %for generation of the mean, data with high peaks removed 
   insertiongraph(:,i) = smoothed(indexpoint:indexpoint+intrange); 

    %smoothing based on filtering the signal to focus on the peak 
   smoothed = smoothdata(smoothed);

   %save the values around the insertion point to egnerate the smooth mean 
   smoothedinsertiongraphs(:,i) = smoothed(indexpoint-s:indexpoint+l);

   %plot the smoothed data 
   figure(3)
   hold on
   plot(data.Time_sec__,smoothed);
   if in ==1
   plot(data.Time_sec__(indexpoint),smoothed(indexpoint),'*r');
   end
   hold off 
   
   %plot the smoothed data around the insertion point
   figure(4)
   hold on
   plot(points,smoothed(indexpoint-s:indexpoint+l));
   if in ==1
   plot(points(s+1),smoothed(indexpoint),'*r');
   end
   hold off 
end

%label the figures 
figure(1)
title("Partially filtered")
xlabel("Time(s)")
ylabel("Force (mN)")

figure(2)
title("Aligned partially filtered ")
xlabel("Time(100ms)")
ylabel("Force (mN)")

figure(3)
title("Smoothed Change in force into agar showing insertion points")
xlabel("Time(s)")
ylabel("Force (mN)")
legend('test1','test2','test3')

figure(4)
title("Aligned Smoothed Change in force into agar showing insertion points")
xlabel("Time(100ms)")
ylabel("Force (mN)")

%% Plotting the smoothed average over all trials
smoothaverage =  mean(smoothedinsertiongraphs(:,:),2); %get the average from the plotted graphs 
figure(5)
dev = std(smoothedinsertiongraphs(:,:),0,2); %get the standard deviation for the mean points 
err = dev/sqrt(tests); %calcautate the standrard erro of the mean based on the standard deviation 
hold on
errorbar(points,smoothaverage,err) %plot the graph with the error bars using SEM
title("Smoothed Mean Force curve at 15k rpm with 0 being insertion point")
xlabel("Time(100ms)")
ylabel("Force (mN)")

%% Plotting the raw average over all trials 
rawaverage =  mean(insertiongraph(:,:),2); %get the average from the plotted graphs 
figure(6)
rdev = std(insertiongraph(:,:),0,2); %get the standard deviation for the mean points 
rerr = rdev/sqrt(tests); %calcautate the standrard erro of the mean based on the standard deviation 
hold on
errorbar(intime,rawaverage,rerr) %plot the graph with the error bars using SEM
if in ==1
plot(intime(1),rawaverage(1),'*r');
legend("Raw mean",'insertion')
end
title("Raw Mean Force curve value around insertion point")
xlabel("Time(100ms)")
ylabel("Force (mN)")

%% Saving the means to compare to different speeds, uncomment the fileyou wish to save too 
%save("lsmean",'rawaverage','rerr','smoothaverage','err')
%save("msmean",'rawaverage','rerr','smoothaverage','err')
%save("hsmean",'rawaverage','rerr','smoothaverage','err')
