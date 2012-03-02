function fileExist=checkPrairieFile(filePath)
% check whether Prairie file exists
% ask user to decide what to do if the file does not exist
% user options are "try again" (after fixing problem) or "skip"
% "skip" has different meaning depending on file type

if exist(filePath,'file')
    fileExist=true;
else
    userInput='';
    while ~ismember(userInput,{'skip','try again'})
        if strfind(filePath,'Source.tif') | strfind(filePath,'Reference.tif') % Linescan source or reference image
            userInput=input(['Image file not found at' '\n' ...
                filePath '\n' ...
                'fix the problem and enter "try again"' '\n' ...
                'or enter "skip" to skip adding this image as an epoch resource' '\n'],'s');
        else % prm or dat file
            userInput=input(['File not found at' '\n' ...
                filePath '\n' ...
                'fix the problem and enter "try again"' '\n' ...
                'or enter "skip" to skip importing this Linescan epoch' '\n'],'s');
        end
    end
    if strcmp(userInput,'try again')
        fileExist=checkPrairieFile(filePath);
    elseif strcmp(userInput,'skip')
        fileExist=false;
    end
end
