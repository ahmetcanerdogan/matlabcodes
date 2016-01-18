% find phases
close all
[k,l] = min([(ucmd.header.stamp(1)) * 10^-9 , (odom.header.stamp(1)) * 10^-9,(costmap.header.stamp(1)) * 10^-9]);
starttime = k;
ucmd.timeinsec = (ucmd.header.stamp*10^-9-k);
costmap.timeinsec = (costmap.header.stamp*10^-9-k);
odom.timeinsec = (odom.header.stamp*10^-9-k);
footprint.timeinsec = (footprint.header.stamp*10^-9-k);

ucmd.vec = [sqrt(0.5) * ucmd.command.linear.x/ 0.3520 ,sqrt(0.5) * ucmd.command.angular.z/0.4 ,zeros(length(ucmd.command.angular.z),1)]


for i =1: length(costmap.obs(1).x)
for j=1:length(costmap.obs)
   obswithtime{i}(j,:) = [costmap.obs(j).x(i),costmap.obs(j).y(i)];
end
    
end



ara = 10;
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
        ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');
plot(pose(1:ara:end,1),pose(1:ara:end,2))

hold on
for t = 1:ara: length(odom.pose.pose.position.x)
     current_time = odom.timeinsec(t);
    current_quat = quats(t,:);
     invquat = (current_quat);
     
    [minvalu,minindu] = min(abs(ucmd.timeinsec - current_time));
current_vec = ucmd.vec(minindu,:);
    cmd_rot = qvrot( [invquat(2),invquat(3),invquat(4),invquat(1)], current_vec);

    cla;

    figure(1)
    plot(pose(1:ara:end,1),pose(1:ara:end,2))
    hold on
   
    [minvalc,minindc] = min(abs(costmap.timeinsec - current_time));
%     display(['Time is ' , num2str(costmap.timeinsec(minindc(1))),' and ' , num2str(current_time) ])
[minvalf,minindf] = min(abs(footprint.timeinsec - current_time));
current_foot = [footprint.polygon.points0.x(minindf) , footprint.polygon.points0.y(minindf) ...
    ; footprint.polygon.points1.x(minindf) , footprint.polygon.points1.y(minindf)...
    ; footprint.polygon.points2.x(minindf) , footprint.polygon.points2.y(minindf)...
    ;footprint.polygon.points3.x(minindf) , footprint.polygon.points3.y(minindf) ...
    ;footprint.polygon.points4.x(minindf) , footprint.polygon.points4.y(minindf) ];
fill (current_foot(:,1),current_foot(:,2),'r')
    quiver(pose(t,1),pose(t,2),cmd_rot(1) , cmd_rot(2) , 'Linewidth',4)
    plot(obswithtime{minindc(1)}(:,1),obswithtime{minindc(1)}(:,2),'.')
    pause(0.3)

  if ~ishandle(ButtonHandle)
    disp('Loop stopped by user');
    break;
  end
    


end


