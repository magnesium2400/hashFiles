function S = getCode(filename)
%% GETCODE Reads text from code file, excluding comment or whitespace lines
%% Syntax
%  S = getCode(filename)
% 
% 
%% Description
% `S = getCode(filename)` creates a string by concatenating the lines from a
% script or function file, excluding lines of only whitespace or starting with a
% `%` character, and trimming whitespace on each line. 
% 
% 
%% Examples
%   getCode('getCode')
% 
% 
%% Input Arguments
% `filename - file name (string scalar | character vector)`
% 
% 
%% Output Arguments
% `S - file text (string scalar)`
% 
% 
%% See Also 
%  READLINES, REGEXP, JOIN, getFileHash
% 
% 
%% Authors
% Mehul Gajwani, Monash University, 2024
% 
% 


% get text
filetext = readlines(which(filename), ...
    'WhitespaceRule', 'trim', 'EmptyLineRule', 'skip');

% remove lines that start with '%' character
idx = cell2mat(cellfun(@(x) isempty(x), regexp(filetext, "^\%"),'Uni',0));
S = join(filetext(idx), newline); % return

end