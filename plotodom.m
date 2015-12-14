% odom plotter
close all
ara = 50;
pose = [x_odom.pose_pose_position_x,x_odom.pose_pose_position_y,x_odom.pose_pose_position_z];
quats = [x_odom.pose_pose_orientation_w , x_odom.pose_pose_orientation_x , x_odom.pose_pose_orientation_y, x_odom.pose_pose_orientation_z];
xvector = [1,0,0];

for t = 1: length(x_odom.pose_pose_position_x)
    current_pose = pose(t,:);
    current_quat = quats(t,:);
    rott(t,:) = quatrotate(quatinv(current_quat) , xvector);
     [yaw(t), pitch(t), roll(t)] = quat2angle(quatinv(current_quat));
end

plot(pose(1:ara:end,1),pose(1:ara:end,2))

hold on

for t = 1:ara: length(x_odom.pose_pose_position_x)
    quiver(pose(t,1),pose(t,2),rott(t,1) , rott(t,2))
    pause(0.3)

end
