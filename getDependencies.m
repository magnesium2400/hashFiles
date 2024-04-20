function deps = getDependencies(filename)
%% GETDEPENDENCIES Finds dependencies for specified function, file, or folder
%% Syntax
%  deps = getDependencies(filename)
% 
% 
%% Description
% `deps = getDependencies(filename)` returns the dependencies of the script or
% function (or livescript or live function) of the input file. 
% 
% 
%% Examples
%   getDependencies('getDependencies')
%   getDependencies('getFileHash_example')
% 
% 
%% Input Arguments
% `filename - file name (string scalar | character vector)`
% 
% 
%% Output Arguments
% `deps - dependencies (cell array of character vectors)`
% 
% 
%% See Also 
%  getFileHash
% 
% 
%% Authors
% Mehul Gajwani, Monash University, 2024
% 
% 

deps = reshape( matlab.codetools.requiredFilesAndProducts(filename) ,[],1);
end
