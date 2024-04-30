function S = combineDependencies(filename, varargin)
%% COMBINEDEPENDENCIES Combine dependencies into one file
%% Syntax
%  combineDependencies(filename)
%  combineDependencies(filename,Name,Value)
%  S = combineDependencies(___)
% 
% 
%% Description
% `combineDependencies(filename)` appends the dependencies of a MATLAB(R) script
% or function file to the end of that file.
% 
% `combineDependencies(filename,Name,Value)` appends the dependencies with
% additional options specified by one or more name-value pair arguments. For
% example, changing the output file or the text formatting. 
% 
% `S = combineDependencies(___)` returns a string array of the text in the
% original file first, and then the text of each dependency. 
% 
% 
%% Examples
%   combineDependencies('combineDependencies', 'outputFile', tempname('.')); 
%   S = combineDependencies('combineDependencies', 'outputFile', tempname('.'), 'concise', true); 
%   combineDependencies('combineDependencies', 'outputFile', tempname('.'), 'conciseDeps', true); 
%   combineDependencies('combineDependencies', 'outputFile', tempname('.'), 'conciseOrig', true); 
%
%
%% Input Arguments
% `filename - file name (string scalar | character vector)`
% 
% 
%% %% Name-value Arguments
% `outputFile - file path of output (string scalar | character vector)` If this
% is not input or is empty, the input file will be overwritten. Otherwise, this
% will overwrite the file supplied as input. 
% 
% `sep - separating text between files (string scalar | character vector)` By
% default, there will be a line of `=` between each file.
% 
% `concise - whether to remove lines of comments and whitespace (false (default)
% | true)` If set to true, the text output will have whitespace trimmed, lines
% of whitespace removed, and lines starting with '%' removed. If set to false,
% the text output will be the same as the text input. 
% 
% `conciseDeps - whether to reformat dependencies (false (default) | true)` If
% set to true, only the text from the dependencies will be reformatted as per
% `concise`.
% 
% `conciseOrig - whether to reformat original file (false (default) | true)` If
% set to true, only the text from the original file will be reformatted as per
% `concise`.
% 
% 
%% Output Arguments
% `S - file text (string array)` A string array where the first element is the
% text of the input code file, and the subsequent elements are the text from the
% dependencies (if any).
% 
% 
%% Authors
% Mehul Gajwani, Monash University, 2024
% 
% 
%% See Also 
%  GETCODE, GETDEPENDENCIES
% 
% 


%% Prelims
ip = inputParser; 
ip.addRequired('filename', @(s) isStringScalar(s) || ischar(s));
ip.addParameter('outputFile', [], @(s) isStringScalar(s) || ischar(s));
ip.addParameter('concise',     false, @islogical); 
ip.addParameter('conciseOrig', false, @islogical); 
ip.addParameter('conciseDeps', false, @islogical); 
ip.addParameter('sep', [newline, '%%% ', repmat('=', 1, 76),  newline], @(s) isStringScalar(s) || ischar(s));

ip.parse(filename, varargin{:}); 
ipr = ip.Results;

filename = which(ipr.filename);

if ipr.concise || ipr.conciseOrig;  getOrig = @(x) getCode(x);
else;                               getOrig = @(x) fscanf(fopen(x),'%c');  end

if ipr.concise || ipr.conciseDeps;  getDeps = @(x) getCode(x);
else;                               getDeps = @(x) fscanf(fopen(x),'%c');  end

outfile = ipr.outputFile;
if isempty(outfile); outfile = filename; end


%% Read and combine
origText = getOrig(filename); 

deps = setdiff(getDependencies(filename), filename);
depsText = cellfun(getDeps, deps, 'Uni', 0); 

writelines(origText, outfile); 
cellfun(@(x) writelines([ipr.sep,x],outfile,'WriteMode','append'), depsText);

S = [{string(origText)}; string(depsText)];


end
