clear all
close all


subjectspan=1;
expspan = [0,1,2,3];
trialspan = 1:3;
tr1 = zeros(length(trialspan) , length(expspan));
tr2 = zeros(length(trialspan) , length(expspan));
tr3 = zeros(length(trialspan) , length(expspan));
tr4 = zeros(length(trialspan) , length(expspan));

for subject = subjectspan
    count2=1;
    for expcase = expspan
        count1=1;
        for trial = trialspan
           name = ['S' num2str(subject) 'C' num2str(expcase) 'T' num2str(trial),'pr.mat'];
            load(name);
            subname = ['S' , num2str(subject),'_ucmd'];
            varname = genvarname(subname);
            eval([varname,'{count1,count2} = ucmd.vec(:,1:2);'])
          
            count1 = count1+1;
        end
        count2=count2+1;
    end
   
    
end
