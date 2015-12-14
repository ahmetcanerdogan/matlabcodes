function output=extractsinglefile(input,topic)

%Test this
subject = input(1);
casenumber = input(2);
trialnumber = input(3);


name =['Test',num2str(subject),'/Case',num2str(casenumber),'/Trial',num2str(trialnumber),'/csvs'];

topiclist=[];
% Loading file
currentdir = pwd;

folderoffile = [currentdir , '/TestFiles/' , name];



    fid = fopen ([folderoffile ,'/', topic]);
    
    if(fid>0)
        %         Find field names
        allnames = textscan(fid, '%s',1);
        if (length(allnames{1}{1})< 5)
            display(['Something wrong with topic : ' , filename])
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
                % We are creating every column as a string, for the time being
                formatspecs = [formatspecs,'%s'];
            end
            varnames{ j + 1}= repnames(commas(end)+1:end);
            
            
            % Create data cell
            delimiter = ',';
            startRow = 2;
            endRow = inf;
            fid = fopen ([folderoffile ,'/', filename]);
            
            dataArray = textscan(fid, [formatspecs,'%[^\n\r]'], endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
            for block=2:length(startRow)
                frewind(fileID);
                dataArrayBlock = textscan(fileID, [formatspecs,'%[^\n\r]'], endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
                for col=1:length(dataArray)
                    dataArray{col} = [dataArray{col};dataArrayBlock{col}];
                end
            end
            
            
            % Var name is going to be topicname
            topicname = genvarname(filename(1:end-4));
            display(['Completion : %', num2str(i/length(filelist)*100) , ' Done || Populating Topic : ' , topicname , ' with ',num2str(length(varnames)),' subtopics '  ])
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
                    
                % Check first 10 samples and convert them to doubles (otherwise too slow)
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
            
            
            topiclist =[topiclist,' ',topicname];
            %   savestruct.(topicname) = eval(topicname); % Test this
        end
    end
    
% savefilename = [filenamin,'.mat'];
% saveallfilename = [filenamin,'all.mat'];
% eval(['save ',savefilename,' ' , topiclist])
% eval(['save ' saveallfilename ])
