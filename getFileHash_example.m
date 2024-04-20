%% GETFILEHASH_EXAMPLE Examples of `getFileHash` usage
% `getFileHash` is a function that computes the MD5sum (hash) of files:
% 
% * if it is called without argument, it calculates the hash of the script
% that called it;
% * alternatively, a filepath to an m file can be provided as input.
%
% This script provides some examples of its use. For best results, run this
% script by calling `getFileHash_example` in the command window or by
% selectin `Run` in the `Editor` tab (not by using Ctrl+Enter or F9)

fprintf('\n\n');


%% If called in a script, `getFileHash` returns the hash of that script
% The following are equivalent in this case:

[h, filename] = getFileHash();
fprintf('The hash of %s is %s\n', filename, h);

[h, filename] = getFileHash([]); 
fprintf('The hash of %s is %s\n', filename, h);

[h, filename] = getFileHash('getFileHash_example');
fprintf('The hash of %s is %s\n', filename, h);

fprintf('\n\n');


%% You can ignore the lines that are comments and whitespace - i.e. hash only the code
% This may be useful if you change the comments but not the code

h = getFileHash([], 'codeOnly', true); 
fprintf('The hash of the code in %s is %s\n', filename, h);

fprintf('\n\n');


%% By default, `getFileHash` actually includes all the dependencies in the hash
% The final result is the XOR of the hashes of all the dependencies

f = getDependencies('getFileHash_example');
fprintf('The dependencies of getFileHash_example are:\n');
cellfun(@(x) fprintf([' - ', x,'\n']), f);

% This can be turned off

h = getFileHash([], 'includeDependencies', false, 'codeOnly', true); 
fprintf('The hash of %s without dependencies is %s\n', filename, h);

fprintf('\n\n');


%% You can save a copy of the file with its hash attached to it
% This way, you know exactly the state of the code when it was ran:
% You can compare the hash header in the filename with the system md5sum

getFileHash('getFileHash_example', 'saveCopy', true, 'includeDependencies', false);
getFileHash('getFileHash_example', 'saveCopy', true, 'includeDependencies', false, 'codeOnly', true);


%% You can also save a copy of a script with all its dependencies in a zip file

getFileHash('getFileHash_example', 'saveDependencies', true);
getFileHash('getFileHash_example', 'saveDependencies', true, 'codeOnly', true);


%% And you can save the paths and hashes of data files without saving the contents
% Here, the files in `data` are treated as binary files

getFileHash('getFileHash_example.m', 'saveDependencies', true, 'codeOnly', false, ...
    'data', {'getBinaryHash.m', 'getCode.m'});


