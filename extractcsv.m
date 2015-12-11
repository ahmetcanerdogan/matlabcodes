% function extractcsv(input)

%Test this
% subject = input(1);
% casenumber = input(2);
% trialnumber = input(3);

subject = 1;
casenumber = 0;
trialnumber = 0;


name =['Test',num2str(subject),'/Case',num2str(casenumber),'/Trial',num2str(trialnumber),'/csvs'];


% Loading file
currentdir = pwd;

folderoffile = [currentdir , '/TestFiles/' , name];
filelist = dir(folderoffile);

for i=3:length(filelist)
    filename = filelist(i).name;
    fid = fopen ([folderoffile ,'/', filename]);
    
    if(fid>0)
        %         Find field names
        allnames = textscan(fid, '%s',1);
        %         remove field.name from field names
        repnames = strrep(allnames{1}{1},'field.' , '');
        repnames = strrep(repnames,'.' , '_');
        
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
        display(['Completion : %', num2str(i/length(filelist)) , ' Done || Populating Topic : ' , topicname , ' with ',num2str(length(varnames)),' subtopics '  ])
        for j = 1: length(varnames)
            % Check first 10 samples and convert them to doubles (otherwise too slow) 
            if isnan(str2double(dataArray{:,j}(1:10)))
                eval([topicname '.(varnames{j})= dataArray{:,j};']);
            else
                eval([topicname '.(varnames{j})= str2double(dataArray{:,j});']);
                
            end
	% if var number in topic is longer than 50, don't let people stare at empty output
	if (mod(j,50) == 0 )
	display([num2str(j) , '/' , num2str(length(varnames)) ])
	end

        end
        
        
    topiclist{i} =topicname;
%   savestruct.(topicname) = topicname; % Test this
    end
    
end


filename = ['S' ,num2str(subject), 'C' ,num2str(casenumber), 'T',num2str(trialnumber),'.mat' ]

% save(filename ,'-S', savesturct)  % Test this

