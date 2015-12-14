input = [1 0 2]

odom=extractsinglefile(input,'_odom.csv');
costmap = extractcostmaptr(input);
ucmd=extractsinglefile(input,'_user_cmd.csv');
footprint = extractsinglefile(input , '_costmap_server_node_system_costmap_obstacles_footprint_footprint_stamped.csv');


findphases

plotodomwcostmap;