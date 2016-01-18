function output = extractsinglefile(input,topic,expflag)

%Test this
subject = input(1);
casenumber = input(2);
trialnumber = input(3);
topiclist=[];

% If experiment data is analyzed.
if expflag

% Name strings for experiments (lab data is with name, exp data will be identifiers.    
switch input(1)
    case 1 
        nameofsubject = 'alex';
 case 2 
        nameofsubject = 'mahdieh';
        
end

% If trial number is higher than 2, then it is a head array experiment
if trialnumber>2
    trialname = [num2str(trialnumber-2),'_ASL'];
else
    trialname = num2str(trialnumber);
end

name =[nameofsubject,'_C',num2str(casenumber),'_',trialname,'_2016*'];

% Loading file
% Test data is always put to an adjacent folder of matlabcodes
folderoffile = [fileparts(pwd),'/TestFiles/', name];
% Automatically fill rest of the message
fullnameoffile=dir(folderoffile);
fullnameoffile=[fileparts(pwd),'/TestFiles/',fullnameoffile.name];
else
    % For testing the code, this uses the sample data in the this folder
    % it may give error in joym, though.
currentdir = pwd;
name =['Test',num2str(subject),'/Case',num2str(casenumber),'/Trial',num2str(trialnumber),'/csvs'];

topiclist=[];
% Loading file
currentdir = pwd;



    
    folderoffile = [currentdir , '/TestFiles/' , name];
    fullnameoffile = folderoffile;
end


    fid = fopen([fullnameoffile ,'/', topic]);
    
    if(fid>0)
        %         Find field names
        allnames = textscan(fid, '%s',1);
        if (length(allnames{1}{1})< 5)
            display(['Something wrong with topic : ' , filename])
              output = -1;
        else
            %         remove field.name from field names
            repnames = strrep(allnames{1}{1},'field.' , '');
%             repnames = strrep(repnames,'.' , '_');
            
            % Find names that are in-between commas
            commas=find(repnames == ',');
            clear varnames
            count = 1;
            formatspecs = ['%s'];
            
            for j = 1:length(commas)
                
                if j == 1
                    varnames{j} = repnames(2:commas(j)-1);
                else
                    varnames{j} = repnames(commas(j-1)+1:commas(j)-1);
                end
                count = count + 1 ;
                % We are creating every column as a string for the time being
                formatspecs = [formatspecs,'%s'];
            end
            varnames{ j + 1}= repnames(commas(end)+1:end);
            
            
            % Create data cell
            delimiter = ',';
            startRow = 2;
            endRow = inf;
            fid = fopen ([fullnameoffile ,'/', topic]);
            
            dataArray = textscan(fid, [formatspecs,'%[^\n\r]'], endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
            for block=2:length(startRow)
                frewind(fileID);
                dataArrayBlock = textscan(fileID, [formatspecs,'%[^\n\r]'], endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
                for col=1:length(dataArray)
                    dataArray{col} = [dataArray{col};dataArrayBlock{col}];
                end
            end
            
            
            % Var name is going to be topicname
            topicname = genvarname(topic(1:end-4));
            display([' Populating Topic : ' , topicname , ' with ',num2str(length(varnames)),' subtopics '  ])
            for j = 1: length(varnames)
                noofdots= find(varnames{j}=='.');
                
                if ~isempty(noofdots)
                    namesegs = ['( varnames{j}(1:noofdots(1)-1)).'];
                    for k=1:length(noofdots)-1
                    namesegs = [namesegs,'(varnames{j}(noofdots(' num2str(k) ' )+1:noofdots(' num2str(k+1) ' )-1)).'];
                    end
                    namesegs = [namesegs,'( varnames{j}(noofdots(' num2str(k+1) ')+1:end))'];
                else
                    namesegs = ['(varnames{j})'];
                end
                    
                % Check first 10 samples and convert them to doubles (checking whole msg was too slow)
                if isnan(str2double(dataArray{:,j}(1:min(length(dataArray{:,j}),10))))
                    eval(['output.' namesegs '= dataArray{:,j};']);
                else
                    eval(['output.' namesegs '= str2double(dataArray{:,j});']);
                    
                end
                % if var number in topic is longer than 50, don't let people stare at empty output
                if (mod(j,50) == 0 )
                    display([num2str(j) , '/' , num2str(length(varnames)) ])
                end
                
            end
          
            
            
            %   savestruct.(topicname) = eval(topicname); % Test this
        end
    else
          output = -1;
          display(['Could not open file: ' ,  folderoffile ,'/', topic])
    end
fclose all;
    
% savefilename = [filenamin,'.mat'];
% saveallfilename = [filenamin,'all.mat'];
% eval(['save ',savefilename,' ' , topiclist])
% eval(['save ' saveallfilename ])
