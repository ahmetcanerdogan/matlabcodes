clear all
expflag=1;

plotall = 0;
allcases=[0,1,2,3,4];

for numberofsub = 1:2
    for cases = allcases
        for trials = 1:4
            
            input = [numberofsub,cases,trials]
            odom=extractsinglefile(input,'_odom.csv',expflag);
            joy=extractsinglefile(input,'_joy.csv',expflag);
            
            
            if(trials>2)
                joym=extractsinglefile(input,'_joy_asl.csv',expflag);
            else
                joym=extractsinglefile(input,'_joy_mouse.csv',expflag);
                
            end
            costmap = extractcostmaptr(input,expflag);
            ucmd=extractsinglefile(input,'_user_cmd.csv',expflag);
            Cainfo=extractsinglefile(input,'_CAinfo.csv',expflag);
            footprint = extractsinglefile(input , '_costmap_server_node_system_costmap_obstacles_footprint_footprint_stamped.csv',expflag);
            
            if expflag
                findphasespermeter
            else
                
                findphases
            end
            if plotall
                
                plotodomwcostmap;
                
            end
            
            subjectid(numberofsub).data(cases+1,trials).odom = odom;
            subjectid(numberofsub).data(cases+1,trials).joy = joy;
            subjectid(numberofsub).data(cases+1,trials).joym = joym;
            subjectid(numberofsub).data(cases+1,trials).ucmd = ucmd;
            subjectid(numberofsub).data(cases+1,trials).Cainfo = Cainfo;
            subjectid(numberofsub).data(cases+1,trials).footprint = footprint;
            
            subjectid(numberofsub).data(cases+1,trials).indicetimes = indicetimes;
            
            
            
        end
    end
end
