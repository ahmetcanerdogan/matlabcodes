% odom plotter
close all
ara = 50;
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
    quiver(pose(t,1),pose(t,2),rott(t,1) , rott(t,2))
    pause(0.3)

end
