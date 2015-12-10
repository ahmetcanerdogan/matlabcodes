% function alldata = extractcsv(input)

% name = input.name;


name ='Test1/Case0/csvs';


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
        
        
        % Lets try to convert them to doubles (plz)
        topicname = genvarname(filename(1:end-4));
        display(['Populating Topic : ' , topicname , ' with ',num2str(length(varnames)),' subtopics ||| ' 'Completion %' , num2str(i/length(filelist)) ])
        for j = 1: length(varnames)
            if isnan(str2double(dataArray{:,j}))
                eval([topicname '.(varnames{j})= dataArray{:,j};']);
            else
                eval([topicname '.(varnames{j})= str2double(dataArray{:,j});']);
                
            end
        end
        
        
        
    end
end

