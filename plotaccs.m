clear all
close all
input = [1 0 1]

odom=extractsinglefile(input,'_odom.csv');

k=(odom.header.stamp(1)*10^-9);
starttime = k;

odom.timeinsec = (odom.header.stamp*10^-9 - k);

linvel = odom.twist.twist.linear.x;

angvel = odom.twist.twist.angular.z;

stepsize = 10;
linacc = zeros(stepsize,1);
angacc = zeros(stepsize,1);

for t=stepsize+1:length(linvel)
    linacc(t) = (linvel(t) - linvel(t-stepsize)) / (odom.timeinsec(t) - odom.timeinsec(t-stepsize));
    angacc(t) = (angvel(t) - angvel(t-stepsize)) / (odom.timeinsec(t) - odom.timeinsec(t-stepsize));
    
end

plot(odom.timeinsec,linvel) , hold on,
plot(odom.timeinsec,linacc , 'r')

figure()

plot(odom.timeinsec,angvel) , hold on,
plot(odom.timeinsec,angacc , 'r')
