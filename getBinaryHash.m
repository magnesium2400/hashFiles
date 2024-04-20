function [hash, filename] = getBinaryHash(filename)
%% GETBINARYHASH Use system call to find MD5sum of file, treated as binary data
%% Syntax
%  h = getBinaryHash(filename)
%  [h,f] = getBinaryHash(filename)
%  
% 
%% Description
% `h = getBinaryHash(filename)` returns the MD5sum of the input file, using
% system calls and treating the file as if it were binary data. 
% 
% `[h,f] = getBinaryHash(filename)` also returns the absolute path to the file. 
% 
% 
%% Examples
%   getBinaryHash('getBinaryHash.m')
%   getBinaryHash('getBinaryHash') % expected warning
%   mlreportgen.utils.hash( fscanf(fopen(which('getBinaryHash.m')),'%c') )
%   system(['md5sum "',which('getFileHash'), '"']);
% 
% 
%% Input Arguments
% `filename - file name (string scalar | character vector)`
% 
% 
%% Output Arguments
% `h - MD5sum of file (character vector)`
%
% `f - absolute path to file hashed (character vector)`
% 
% 
%% See Also 
%  SYSTEM, WHICH, getFileHash
% 
%% Authors
% Mehul Gajwani, Monash University, 2024
% 
% 


if exist(filename, 'file') ~= 2; error("Unable to find file"); end
[~,~,a] = fileparts(filename);
if isempty(a)
    filename = which(filename);
    warning('File extension unspcified; hashing %s', filename);
end

switch computer
    case 'GLNXA64'
        [~,tmp] = system(['md5sum ' filename]);
    case 'MACI64'
        [~,tmp] = system(['md5 -r ' filename]);
    case 'PCWIN64'
        [~,tmp] = system(['CertUtil -hashfile ' filename ' MD5']);
    otherwise
        error('Unsupported computer type %s', computer);
end

hash = regexp(tmp, '^\w{32}', 'match', 'once', 'lineanchors');

end
