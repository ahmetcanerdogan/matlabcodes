function output = extractcostmaptr(input)

%Test this
subject = input(1);
casenumber = input(2);
trialnumber = input(3);

topic  = '_costmap_translator_obstacles.csv'
name =['Test',num2str(subject),'/Case',num2str(casenumber),'/Trial',num2str(trialnumber),'/csvs'];

topiclist=[];
% Loading file
currentdir = pwd;

folderoffile = [currentdir , '/TestFiles/' , name];



    fid = fopen ([folderoffile ,'/', topic]);
    
    if(fid>0)
        %         Find field names
        allnames = textscan(fid, '%s',5);
        newallnames = allnames{1}(5,:);
        repnames = newallnames{1};
            
            % Find names that are in-between commas
            allcommas=find(repnames == ',');
            commas = allcommas(7:end);
            clear varnames
            count = 1;
            formatspecs = ['%s%s%s%s%s%s%s'];
            
            for j = 1:length(commas)+1
                
                if (mod(j,3) == 1)
                    varnames{j} = ['obs(',num2str(count),').x'];
                elseif (mod(j,3) == 2)
                   varnames{j} = ['obs(',num2str(count),').y'];
                else
                    varnames{j} = ['obs(',num2str(count),').z'];
                     count = count + 1 ;
                end
               
                % We are creating every column as a string, for the time being
                formatspecs = [formatspecs,'%s'];
            end
            
            
            % Create data cell
            delimiter = ',';
            startRow = 2;
            endRow = inf;
            fid = fopen ([folderoffile ,'/', topic]);
            
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
            display([ ' opulating Topic : ' , topicname , ' with ',num2str(length(varnames)),' subtopics '  ])
            for j = 1: length(varnames)
                
               
                    
                % Check first 10 samples and convert them to doubles (otherwise too slow)
                if isnan(str2double(dataArray{:,j+6}(1:min(length(dataArray{:,j+6}),10))))
                    eval(['output.' varnames{j} '= dataArray{:,j+6};']);
                else
                    eval(['output.' varnames{j} '= str2double(dataArray{:,j+6});']);
                    
                end
                % if var number in topic is longer than 50, don't let people stare at empty output
                 if (mod(j,50) == 0 )
                    display([num2str(j) , '/' , num2str(length(varnames)) ])
                 end
                
            end
            
            output.time = str2double(dataArray{:,1});
            output.header.stamp = str2double(dataArray{:,3});
            
            
            
            %   savestruct.(topicname) = eval(topicname); % Test this
        end
    end
    
% savefilename = [filenamin,'.mat'];
% saveallfilename = [filenamin,'all.mat'];
% eval(['save ',savefilename,' ' , topiclist])
% eval(['save ' saveallfilename ])
