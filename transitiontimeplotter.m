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
            subname = ['S' , num2str(subject),'_tr'];
            varname = genvarname(subname);
            eval([varname,'{1}(count1,count2) = transitiontimes(1);'])
            eval([varname,'{2}(count1,count2) = transitiontimes(2);'])
            eval([varname,'{3}(count1,count2) = transitiontimes(3);'])
            eval([varname,'{4}(count1,count2) = transitiontimes(4);'])
            
            eval([varname,'_st{1}(count1,count2) = transitiontimes(2) - transitiontimes(1);'])
            eval([varname,'_st{2}(count1,count2) =  transitiontimes(3) - transitiontimes(1);'])
            eval([varname,'_st{3}(count1,count2) =  transitiontimes(4) - transitiontimes(1);'])
            
            count1 = count1+1;
        end
        count2=count2+1;
    end
    meanvals=[mean(eval([varname,'_st{1}']));mean(eval([varname,'_st{2}']));mean(eval([varname,'_st{3}']))]
    stdvals=[std(eval([varname,'_st{1}']));std(eval([varname,'_st{2}']));std(eval([varname,'_st{3}']))]
    figure()
    boxplot(eval([varname,'_st{1}']),'labels' ,{'Case0' , 'Case1' , 'Case2' , 'Case3'} )
    title('Stage I Completion Time -- First Doorway Traversal')
    ylabel('Time [Sec]')
     figure()
    boxplot(eval([varname,'_st{2}']),'labels' ,{'Case0' , 'Case1' , 'Case2' , 'Case3'} )
        title('Stage II Completion Time -- Free Drive')
        ylabel('Time [Sec]')
     figure()
    boxplot(eval([varname,'_st{3}']),'labels' ,{'Case0' , 'Case1' , 'Case2' , 'Case3'} )
        title('Stage III Completion Time -- Second Doorway Traversal')
        ylabel('Time [Sec]')

    
end
