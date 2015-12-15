% find phases
close all
[k,l] = min([(ucmd.header.stamp(1)) * 10^-9 , (odom.header.stamp(1)) * 10^-9,(costmap.header.stamp(1)) * 10^-9]);
starttime = k;
ucmd.timeinsec = (ucmd.header.stamp*10^-9-k);
costmap.timeinsec = (costmap.header.stamp*10^-9-k);
odom.timeinsec = (odom.header.stamp*10^-9-k);
footprint.timeinsec = (footprint.header.stamp*10^-9-k);
ara = 10;
pose = [odom.pose.pose.position.x,odom.pose.pose.position.y,odom.pose.pose.position.z];
ucmd.vec = [sqrt(0.5) * ucmd.command.linear.x/ 0.3520 ,sqrt(0.5) * ucmd.command.angular.z/0.4 ,zeros(length(ucmd.command.angular.z),1)]

firstcommandtime = ucmd.timeinsec(find(ucmd.command.linear.x + ucmd.command.angular.z ,1));

[valmaxy, indmaxy ]  = max(pose(:,2));

arr1 = 1:indmaxy;
arr2= indmaxy:length(pose(:,2));

allobs=[0,0];
for i =1: length(costmap.obs(1).x)
for j=1:length(costmap.obs)
   obswithtime{i}(j,:) = [costmap.obs(j).x(i),costmap.obs(j).y(i)];
end

   allobs=[allobs ;obswithtime{i} ];
end

plot(pose(arr1,1),pose(arr1,2))

hold on

plot(pose(arr2,1),pose(arr2,2) , 'r')


plot(allobs(:,1) , allobs(:,2),'.')
[selectedx,selectedy] = ginput(4);

line1 = [selectedx(1:2) , selectedy(1:2)];

a = selectedy(1);
b = selectedy(2);
c = selectedx(1);
d = selectedx(2);

udoor = [c-d a-b 0 ] / sqrt((c-d)^2 + (a-b)^2);
ndoor = cross(udoor,[0 0 1]) ;

c1=1;
x = c:(0.001)*sign(d-c):d;
l1 = -(a*d - b*c - a.*x + b.*x)/(c - d);

plot(x,l1,'r','LineWidth',3)

middle =  [(d+c)/2 (-(a*d - b*c - a.*((d+c)/2 ) + b.*((d+c)/2 ))/(c - d))];


safepass1 = [middle(1)+ ndoor(1) * sign(ndoor(2)),middle(2)+ndoor(2) * sign(ndoor(2))];
plot(safepass1(1),safepass1(2),'*g')

a = selectedy(3);
b = selectedy(4);
c = selectedx(3);
d = selectedx(4);

udoor2 = [c-d a-b 0 ] / sqrt((c-d)^2 + (a-b)^2);
ndoor2 = cross(udoor2,[0 0 1]) ;
x = c:(0.001)*sign(d-c):d;
l2 = -(a*d - b*c - a.*x + b.*x)/(c - d);
plot(x,l2,'r','LineWidth',3)

middle2 =  [(d+c)/2 (-(a*d - b*c - a.*((d+c)/2 ) + b.*((d+c)/2 ))/(c - d))];

safepass2 = [middle2(1) - 3*ndoor2(1) * sign(ndoor2(2)),middle2(2) - 3 * ndoor2(2) * sign(ndoor2(2))];
plot(safepass2(1),safepass2(2),'*g')




dist1 = sqrt((pose(arr1,1) - safepass1(1)) .* (pose(arr1,1) - safepass1(1)) + (pose(arr1,2) - safepass1(2)) .* (pose(arr1,2) - safepass1(2))) ;
dist2 = sqrt((pose(arr1,1) - safepass2(1)) .* (pose(arr1,1) - safepass2(1)) + (pose(arr1,2) - safepass2(2)) .* (pose(arr1,2) - safepass2(2))) ;

[val1,ind1] = min(dist1);
[val2,ind2] = min(dist2);

quats = [odom.pose.pose.orientation.w , odom.pose.pose.orientation.x , odom.pose.pose.orientation.y, odom.pose.pose.orientation.z];
xvector = [1,0,0];

for t = 1: length(odom.pose.pose.position.x)
    current_pose = pose(t,:);
    current_quat = quats(t,:);
    
    invquat = (current_quat);
    rott(t,:) = qvrot( [invquat(2),invquat(3),invquat(4),invquat(1)], xvector);
%      [yaw(t), pitch(t), roll(t)] = quat2angle(quatinv(current_quat));
end

for t = [ind1,ind2]
     current_time = odom.timeinsec(t);

 current_quat = quats(t,:);
     invquat = (current_quat);

     
    [minvalu,minindu] = min(abs(ucmd.timeinsec - current_time));
current_vec = ucmd.vec(minindu,:);
    cmd_rot = qvrot( [invquat(2),invquat(3),invquat(4),invquat(1)], current_vec);


   
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
    

end

savename = ['S' num2str(input(1)) 'C' num2str(input(2)) 'T' num2str(input(3)),'pr.mat'];
transitiontimes = [firstcommandtime , odom.timeinsec(ind1), odom.timeinsec(ind2) , odom.timeinsec(arr1(end))]

save(savename,'ucmd','costmap','odom','footprint','transitiontimes', 'safepass1','safepass2','obswithtime','Cainfo')