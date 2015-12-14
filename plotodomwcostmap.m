% costmap plotter
close all
[k,l] = min([(ucmd.time(1)) * 10^-9 , (odom.time(1)) * 10^-9,(costmap.time(1)) * 10^-9]);
starttime = k;
ucmd.timeinsec = (ucmd.time*10^-9-k);
costmap.timeinsec = (costmap.time*10^-9-k);
odom.timeinsec = (odom.time*10^-9-k);

for i =1: length(costmap.obs(1).x)
for j=1:length(costmap.obs)
   obswithtime{i}(j,:) = [costmap.obs(j).x(i),costmap.obs(j).y(i)];
end
    
end



ara = 20;
pose = [odom.pose.pose.position.x,odom.pose.pose.position.y,odom.pose.pose.position.z];
quats = [odom.pose.pose.orientation.w , odom.pose.pose.orientation.x , odom.pose.pose.orientation.y, odom.pose.pose.orientation.z];
xvector = [1,0,0];

for t = 1: length(odom.pose.pose.position.x)
    current_pose = pose(t,:);
    current_quat = quats(t,:);
    
    invquat = (current_quat);
    rott(t,:) = qvrot( [invquat(2),invquat(3),invquat(4),invquat(1)], xvector);
%      [yaw(t), pitch(t), roll(t)] = quat2angle(quatinv(current_quat));
end

plot(pose(1:ara:end,1),pose(1:ara:end,2))

hold on

for t = 1:ara: length(odom.pose.pose.position.x)
    clf;
    
    plot(pose(1:ara:end,1),pose(1:ara:end,2))
    hold on
    current_time = odom.timeinsec(t);
    [minval,minind] = min(abs(costmap.timeinsec - current_time));
    display(['Time is ' , num2str(costmap.timeinsec(minind(1))),' and ' , num2str(current_time) ])
    quiver(pose(t,1),pose(t,2),rott(t,1) , rott(t,2) , 'Linewidth',4)
    plot(obswithtime{minind(1)}(:,1),obswithtime{minind(1)}(:,2),'.')
    pause(0.3)

end
