% find phases
close all

firstdoorx = 3;
seconddoory = 0.5;
thirddoory = 2;
fourthdoorx = 4.5;

%if x larger than firstdoorx == time to clear first door. After this...



[k,l] = min([(ucmd.header.stamp(1)) * 10^-9 , (odom.header.stamp(1)) * 10^-9,(costmap.header.stamp(1)) * 10^-9]);
starttime = k;
ucmd.timeinsec = (ucmd.header.stamp*10^-9-k);
joym.timeinsec = (joym.header.stamp*10^-9-k);
joy.timeinsec = (joy.header.stamp*10^-9-k);
costmap.timeinsec = (costmap.header.stamp*10^-9-k);
odom.timeinsec = (odom.header.stamp*10^-9-k);
footprint.timeinsec = (footprint.header.stamp*10^-9-k);
pose = [odom.pose.pose.position.x,odom.pose.pose.position.y,odom.pose.pose.position.z];
ucmd.vec = [sqrt(0.5) * ucmd.command.linear.x/ 0.3520 ,sqrt(0.5) * ucmd.command.angular.z/0.4 ,zeros(length(ucmd.command.angular.z),1)];

% For some reason joy_mouse may start with -1
if max(joym.axes0)>9
    firstcommand = find((abs(joym.axes0) + abs(joym.axes1)) >10 ,1);
else
firstcommand = find((abs(joym.axes0) + abs(joym.axes1)) >0.5 ,1);
end
% time of this index which is same across topics
firstcommandtime = joym.timeinsec(firstcommand);
% index of this tome in ucmd time 
firstcommandt = findindperucmd(firstcommandtime,ucmd);


% first door cleared position
[ind1] = find((abs(pose(:,1) - firstdoorx)<0.1),1);
time1 = odom.timeinsec(ind1);
ind1t = findindperucmd(time1,ucmd);


% starting for second door
[ind2] = find((abs(pose(ind1:end,2) - seconddoory) < 0.1),1);
ind2 = ind1 + ind2;
time2 = odom.timeinsec(ind2);
ind2t = findindperucmd(time2,ucmd);

% first interaction from supervisor
[min3,ind3]=max(joy.buttons3);
time3 = joy.timeinsec(ind3);
ind3t = findindperucmd(time3,ucmd);

% control given back to the user
[min4,ind4]=max(joy.buttons0(ind3:end));
ind4 = ind3 + ind4;
time4 = joy.timeinsec(ind4);
ind4t = findindperucmd(time4,ucmd);
ind4tm = findindperucmd(time4,joym);

% second first command time
if max(joym.axes0)>9
    secondfirstcommand = find((abs(joym.axes0(ind4tm:end)) + abs(joym.axes1(ind4tm:end))) >10 ,1);
else
secondfirstcommand = find((abs(joym.axes0(ind4tm:end)) + abs(joym.axes1(ind4tm:end))) >0.5 ,1);
end
secondfirstcommand = secondfirstcommand + ind4tm;
secondfirstcommandtime = joym.timeinsec(secondfirstcommand);
secondfirstcommandt = findindperucmd(secondfirstcommandtime,ucmd);
secondfirstcommandto = findindperucmd(secondfirstcommandtime,odom);

%cleared third door
[min5, ind5] = min(abs(pose(secondfirstcommandto:end,2) - thirddoory));
ind5 = secondfirstcommandto + ind5;
time5 = odom.timeinsec(ind5);
ind5t = findindperucmd(time5,ucmd);

%stat of fourth door
[min6, ind6] = min(abs(pose(ind5:end,1) - fourthdoorx));
ind6 = ind5 + ind6;
time6 = odom.timeinsec(ind6);
ind6t = findindperucmd(time6,ucmd);
ind6tj = findindperucmd(time6,ucmd);

% second interaction from supervisor
[min7,ind7]=max(joy.buttons3(ind6tj:end));
time7 = joy.timeinsec(ind7 + ind6tj);
ind7t = findindperucmd(time7,ucmd);


indicetimes{1} = firstcommandtime : time1;
indicetimes{2} = time2 : time3;
indicetimes{3} = secondfirstcommandtime : time5;
indicetimes{4} = time6 : time7;


indices{1} = firstcommandt : ind1t;
indices{2} = ind2t : ind3t;
indices{3} = secondfirstcommandt : ind5t;
indices{4} = ind6t : ind7t;

if plotall
plot(pose(:,1),pose(:,2))

hold on
plot(pose(ind1t,1),pose(ind1t,2) , '*r')
plot(pose(ind2t,1),pose(ind2t,2) , '*g')
plot(pose(ind3t,1),pose(ind3t,2) , '*b')
plot(pose(ind4t,1),pose(ind4t,2) , '*k')
plot(pose(ind5t,1),pose(ind5t,2) , '*m')
plot(pose(ind6t,1),pose(ind6t,2) , '*c')

plot(pose(indices{1},1),pose(indices{1},2),'r')
plot(pose(indices{2},1),pose(indices{2},2),'g')
plot(pose(indices{3},1),pose(indices{3},2),'m')
plot(pose(indices{4},1),pose(indices{4},2),'k')


allobs=[0,0];
for i =1: length(costmap.obs(1).x)
for j=1:length(costmap.obs)
   obswithtime{i}(j,:) = [costmap.obs(j).x(i),costmap.obs(j).y(i)];
end

   allobs=[allobs ;obswithtime{i} ];
end





plot(allobs(:,1) , allobs(:,2),'.')

end

% 
% [selectedx,selectedy] = ginput(4);
% 
% line1 = [selectedx(1:2) , selectedy(1:2)];
% 
% a = selectedy(1);
% b = selectedy(2);
% c = selectedx(1);
% d = selectedx(2);
% 
% udoor = [c-d a-b 0 ] / sqrt((c-d)^2 + (a-b)^2);
% ndoor = cross(udoor,[0 0 1]) ;
% 
% c1=1;
% x = c:(0.001)*sign(d-c):d;
% l1 = -(a*d - b*c - a.*x + b.*x)/(c - d);
% 
% plot(x,l1,'r','LineWidth',3)
% 
% middle =  [(d+c)/2 (-(a*d - b*c - a.*((d+c)/2 ) + b.*((d+c)/2 ))/(c - d))];
% 
% 
% safepass1 = [middle(1)+ ndoor(1) * sign(ndoor(2)),middle(2)+ndoor(2) * sign(ndoor(2))];
% plot(safepass1(1),safepass1(2),'*g')
% 
% a = selectedy(3);
% b = selectedy(4);
% c = selectedx(3);
% d = selectedx(4);
% 
% udoor2 = [c-d a-b 0 ] / sqrt((c-d)^2 + (a-b)^2);
% ndoor2 = cross(udoor2,[0 0 1]) ;
% x = c:(0.001)*sign(d-c):d;
% l2 = -(a*d - b*c - a.*x + b.*x)/(c - d);
% plot(x,l2,'r','LineWidth',3)
% 
% middle2 =  [(d+c)/2 (-(a*d - b*c - a.*((d+c)/2 ) + b.*((d+c)/2 ))/(c - d))];
% 
% safepass2 = [middle2(1) - 3*ndoor2(1) * sign(ndoor2(2)),middle2(2) - 3 * ndoor2(2) * sign(ndoor2(2))];
% plot(safepass2(1),safepass2(2),'*g')
% 
% 
% 
% 
% dist1 = sqrt((pose(arr1,1) - safepass1(1)) .* (pose(arr1,1) - safepass1(1)) + (pose(arr1,2) - safepass1(2)) .* (pose(arr1,2) - safepass1(2))) ;
% dist2 = sqrt((pose(arr1,1) - safepass2(1)) .* (pose(arr1,1) - safepass2(1)) + (pose(arr1,2) - safepass2(2)) .* (pose(arr1,2) - safepass2(2))) ;
% 
% [val1,ind1] = min(dist1);
% [val2,ind2] = min(dist2);
% 
% quats = [odom.pose.pose.orientation.w , odom.pose.pose.orientation.x , odom.pose.pose.orientation.y, odom.pose.pose.orientation.z];
% xvector = [1,0,0];
% 
% for t = 1: length(odom.pose.pose.position.x)
%     current_pose = pose(t,:);
%     current_quat = quats(t,:);
%     
%     invquat = (current_quat);
%     rott(t,:) = qvrot( [invquat(2),invquat(3),invquat(4),invquat(1)], xvector);
% %      [yaw(t), pitch(t), roll(t)] = quat2angle(quatinv(current_quat));
% end
% 
% for t = [ind1,ind2]
%      current_time = odom.timeinsec(t);
% 
%  current_quat = quats(t,:);
%      invquat = (current_quat);
% 
%      
%     [minvalu,minindu] = min(abs(ucmd.timeinsec - current_time));
% current_vec = ucmd.vec(minindu,:);
%     cmd_rot = qvrot( [invquat(2),invquat(3),invquat(4),invquat(1)], current_vec);
% 
% 
%    
%     [minvalc,minindc] = min(abs(costmap.timeinsec - current_time));
% %     display(['Time is ' , num2str(costmap.timeinsec(minindc(1))),' and ' , num2str(current_time) ])
% [minvalf,minindf] = min(abs(footprint.timeinsec - current_time));
% current_foot = [footprint.polygon.points0.x(minindf) , footprint.polygon.points0.y(minindf) ...
%     ; footprint.polygon.points1.x(minindf) , footprint.polygon.points1.y(minindf)...
%     ; footprint.polygon.points2.x(minindf) , footprint.polygon.points2.y(minindf)...
%     ;footprint.polygon.points3.x(minindf) , footprint.polygon.points3.y(minindf) ...
%     ;footprint.polygon.points4.x(minindf) , footprint.polygon.points4.y(minindf) ];
% fill (current_foot(:,1),current_foot(:,2),'r')
%     quiver(pose(t,1),pose(t,2),cmd_rot(1) , cmd_rot(2) , 'Linewidth',4)
%     plot(obswithtime{minindc(1)}(:,1),obswithtime{minindc(1)}(:,2),'.')
%     
%   
%     pause(0.3)
%     
% 
% end
% 
% savename = ['S' num2str(input(1)) 'C' num2str(input(2)) 'T' num2str(input(3)),'pr.mat'];
% transitiontimes = [firstcommandtime , odom.timeinsec(ind1), odom.timeinsec(ind2) , odom.timeinsec(arr1(end))]
% 
% save(savename,'ucmd','costmap','odom','footprint','transitiontimes', 'safepass1','safepass2','obswithtime','Cainfo')