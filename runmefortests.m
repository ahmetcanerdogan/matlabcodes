clear all
input = [1 3 3ll]

odom=extractsinglefile(input,'_odom.csv');
costmap = extractcostmaptr(input);
ucmd=extractsinglefile(input,'_user_cmd.csv');
Cainfo=extractsinglefile(input,'_CAinfo.csv');
footprint = extractsinglefile(input , '_costmap_server_node_system_costmap_obstacles_footprint_footprint_stamped.csv');


findphases

plotodomwcostmap;