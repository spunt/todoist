function todoist(content, duedate, notes)
% TODOIST Add a task to Todoist
%
%  USAGE: todoist(content, duedate, notes)
% ________________________________________________________________________________________
%  content
%   task description (can include labels, e.g. 'Purchase laptop @finances @work')
% ________________________________________________________________________________________
%  duedate (optional, default = 'today')
%   Human:      today, tomorrow, friday, next friday, tom at 16:30, fri at 2pm
%   Normal:     May 29, 5/29, 10/29/15, 10-29-15, 10.29.15
%   Relative:   +5 (5 days from now)
% ________________________________________________________________________________________
%  notes (optional, default is to add no notes)
%   notes to add to the added task. if CHAR, it will be added as a single note. 
%   if CELL array of strings, each cell will be added as a separate note. 
% 

% ----------------------------- Copyright (C) 2015 Bob Spunt -----------------------------
%	Created:  2015-09-18
%	Email:     spunt@caltech.edu
% ________________________________________________________________________________________
% ________________________________________________________________________________________
% -------------------------------------- API TOKEN ---------------------------------------
token='YOUR-API-TOKEN';
% ________________________________________________________________________________________
if strcmpi(token, 'YOUR-API-TOKEN')
    fprintf('\nFor this to work you need add your Todoist API Token');
end
if nargin < 1, mfile_showhelp; return;  end
if nargin < 2, duedate = 'Today';       end
if nargin < 3, notes = [];              end
url    ='https://api.todoist.com/API/addItem';
cmd    = sprintf(['QUERY="%s"; DUEDATE="%s"; '  ...
       'curl --request POST ''%s'' --data '     ...
       '"content=$QUERY&date_string=$DUEDATE&date_lang=en&token=%s"'], ...
        content, duedate, url, token); 
fprintf('\nTODOIST\nAttempting to add task: '); 
[sts, result]   = system(cmd);
if sts
    fprintf('FAILED\n'); 
    disp(wraptext(result, 100));     
    return; 
else
    fprintf('SUCCEEDED');  
end
if ~isempty(notes)
    if ischar(notes), notes = cellstr(notes); end
    tmp     = regexp(result, ',', 'split');
    itemid  = regexprep(tmp{~cellfun('isempty', regexp(tmp, '"id"'))}, '"id":', '');
    for i = 1:length(notes)
        url  ='https://api.todoist.com/API/addNote';
        cmd  = sprintf('QUERY="%s"; curl --request POST ''%s'' --data "item_id=%s&content=$QUERY&token=%s"', notes{i}, url, itemid, token);
        fprintf('\n  - Adding note %d of %d: ', i, length(notes)); 
        [sts, result]   = system(cmd);
        if sts
            fprintf('FAILED\n');  
            disp(wraptext(result, 100));     
            return; 
        else
            fprintf('SUCCEEDED');  
        end
    end
end
fprintf('\n\n');
end
% ========================================================================================
%
% ------------------------------------- SUBFUNCTIONS -------------------------------------
%
% ========================================================================================
function mfile_showhelp(varargin)
% MFILE_SHOWHELP
ST = dbstack('-completenames');
if isempty(ST), fprintf('\nYou must call this within a function\n\n'); return; end
eval(sprintf('help %s', ST(2).file));
end
function stringOut = wraptext(stringIn, nOfColumns)
%TEXTWRAP2  Wrap text string.
%		OUT = TEXTWRAP2(IN, COL) wraps the given text string IN to fit into COL
%		columns. The results is a string with line breaks '\n' inserted.
%
%		OUT = TEXTWRAP2(IN) uses a default number of 75 columns.
%
%		Note: This function uses the Matlab-function TEXTWRAP which returns a
%		cell array with each cell containing one line of text.
%
%		Example:
%		disp(textwrap2(myString, 75));
%
%		Markus Buehren
%		Last modified 21.04.2008
%
%		See also TEXTWRAP.

stringOut = '';
if nargin < 2
	nOfColumns = 75;
end
if ischar(stringIn)
	stringIn = {stringIn}; % function textwrap requires a cell array as input
end
stringOutCell = textwrap(stringIn, nOfColumns);
for k=1:length(stringOutCell)
	stringOut = [stringOut, stringOutCell{k}, sprintf('\n')]; %#ok
end
stringOut(end) = ''; % remove last line break
end
