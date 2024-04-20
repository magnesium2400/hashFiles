function [h, f, p, hc, fc, hd, fd] = getFileHash(varargin)
%% GETFILEHASH Get MD5sum of current function and dependencies
%% Syntax
%  getFileHash()
%  getFileHash(filename)
%  getFileHash(___,Name,Value)
%
%  h = getFileHash(___)
%  [h,f] = getFileHash(___)
%  [h,f,p] = getFileHash(___)
%  [h,f,p,hc,fc] = getFileHash(___)
%  [h,f,p,hc,fc,hd,fd] = getFileHash(___)
%
%
%% Description
% `getFileHash` calculates the MD5sum of the script or function from where it is
% called, as well as its dependencies. This can act as a record of the state of
% the codebase when the function was run.
%
% `getFileHash(filename)` runs the calculation for the script or function given
% by `filename`.
%
% `getFileHash(___,Name,Value)` specifies additional properties using one or
% more name-value arguments, for example, whether to include dependencies,
% include comments, save a copy of the code file(s), or save a log file.
%
% `h = getFileHash(___)` returns the hash of the script or function as a
% character vector.
%
% `[h,f] = getFileHash(___)` also returns the filepath of the script or function
% as a character vector.
%
% `[h,f,p] = getFileHash(___)` also returns the a struct containing the paths of
% any saved files (such as the script or function called, a log file, or a zip
% file of dependencies).
%
% `[h,f,p,hc,fc] = getFileHash(___)` also returns the hashes and filepaths of
% any code dependencies of the script or function as a cell array of character
% vectors.
%
% `[h,f,p,hc,fc,hd,fd] = getFileHash(___)` returns the hashes and filepaths of
% any data dependencies of the script or function as a cell array of character
% vectors.
%
%
%% Examples
%   getFileHash()
%   getFileHash('getFileHash')
%   getFileHash('getFileHash', 'codeOnly', true)
%   getFileHash('getFileHash', 'includeDependencies', false, 'codeOnly', false)
%   mlreportgen.utils.hash( fscanf(fopen(which('getFileHash')),'%c') )
%   system(['md5sum "',which('getFileHash'), '"']);
%
%
%% Input Arguments
% `filename - name or path of script of function to be hashed (string scalar |
% character vector)` If a filename is not supplied, `getFileHash` will hash the
% last function in the stack before it was called (as returned by `dbstack`).
%
%
%% %% Name-Value Arguments
% `includeDependencies - whether to include dependencies when computing file
% hash (true (default) | false)` If set to true, the hash returned will be the
% logical `xor` of the code file as well as its dependencies, and any binary
% files included as `data`.
% 
% `codeOnly - whether to keep only lines containing code (false (default) |
% true)` If set to true, lines containing only whitespace or starting with a `%`
% character will be removed from the computation of the hash. This may be useful
% if changing comments/layout in a script or function, and you want the hash to
% remain the same. 
%
% `data - additional filepath(s) to be included in the computation of the hash
% (cell array | string scalar | character vector)` If you want additional files
% (e.g. input data) to be included in the computation of the file hash, input
% the filepaths here. Their hash will be computer as binary data using system
% calls. The filepaths, but not the data itself, will be saved if
% `saveDependencies` is set to `true`. 
%
% `saveCode - whether to save a copy of the script or function (false (default)
% | true)` If set to true, a copy of the script or function will be saved in the
% current directory
%
% `saveLog - whether to save a json file with metadata (false (default) | true)`
% If set to true, a json file containing the hashes of the code file, the
% dependencies, and the binary data of any `data` files will be saved in the
% same directory as the code file. 
%
% `saveDependencies - whether to save a copy of code and dependencies (false
% (default) | true)` If set to true, a copy of the code file, the dependencies,
% and the paths to any files specified in the `data` argument will be saved in
% the same directory as the code file. 
%
% `system - whether to use system calls to hash file as binary data (false
% (default) | true)` This is equivalent to `getBinaryHash(___)`.
%
% `text - whether to hash file as if it were plaintext (false (default) | true)`
% This is equivalent to
% `getFileHash(___,'codeOnly',false,'includeDependencies',false)`.
%
%
%% Output Arguments
% `h - XOR of MD5sums of file, dependencies, and data (character vector)`
%
% `f - path to script or function hashed (character vector)`
%
% `p - struct containing paths to output files (struct)` This struct will
% contain the fields `code`, `dependencies`, and/or `log`, as appropriate.  
%
% `hc - hashes of code files and dependencies (cell array of character vectors)`
%
% `fc - paths to code files and dependencies (cell array of character vectors)`
%
% `hc - hashes of data files (cell array of character vectors)`
%
% `fc - paths to data files (cell array of character vectors)`
%
%
%% See Also
%  hash, GETBINARYHASH, GETCODE, GETDEPENDENCIES
% 
%  getFileHash_test, getFileHash_example
%
%
%% Authors
% Mehul Gajwani, Monash University, 2024
%
%


%% Prelims
ip = inputParser;
ip.addOptional('filename', [],  @(x) isStringScalar(x) || ischar(x) || isempty(x));
ip.addParameter('data', {},     @(x) isStringScalar(x) || ischar(x) || iscell(x));
ip.addParameter('includeDependencies',      true,  @islogical);
ip.addParameter('codeOnly',                 false, @islogical);
ip.addParameter('saveCode',                 false, @islogical);
ip.addParameter('saveDependencies',         false, @islogical);
ip.addParameter('saveLog',                  false, @islogical);
ip.addParameter('system',                   false, @islogical);
ip.addParameter('text',                     false, @islogical);

ip.parse(varargin{:}); ipr = ip.Results;

if ~isempty(ipr.filename); f = which(ipr.filename);
else;    temp = dbstack(); f = which(temp(end).file);                  end
if isempty(f); error("Unable to find file");                           end

if contains(f, 'LiveEditorEvaluationHelper')
    warning('getFileHash is not recommended when running from the Editor');
end

if ipr.system; [h, f] = getBinaryHash(f);       return;                end
if ipr.text;   ipr.includeDependencies = false; ipr.codeOnly = false;  end

if ipr.includeDependencies; fc = getDependencies(f);
else;                       fc = {f};                                  end
if isempty(fc);             fc = {f};                                  end

if ipr.codeOnly; getText = @(x) getCode(x);
else;            getText = @(x) fscanf(fopen(x),'%c');                 end

if ~isempty(ipr.data); fd = reshape(ipr.data, [], 1);
else;                  fd = {};                                        end
if isStringScalar(ipr.data)||ischar(ipr.data); fd = {ipr.data};        end


%% Computations
hashText = @(t) char(mlreportgen.utils.hash(t));     % text to MD5 (in hex)
hash2bin = @(h) dec2bin(arrayfun(@(x) hex2dec(x), h),4) == '1';   % hex2bin
bin2hash = @(b) lower(arrayfun(@dec2hex, bin2dec(char(b+'0')))'); % bin2hex

hc = cellfun( @(x) hashText(getText(x)), fc, 'Uni', 0);    % hex
hd = cellfun( @(x) getBinaryHash(x), fd, 'Uni', 0);
hashesBin = cellfun( @(x) hash2bin(x), [hc; hd], 'Uni',0); % bin
h = bin2hash(rexor(hashesBin{:}));                         % hex


%% Save
[a,b,c] = fileparts(f);
outname = fullfile(a, [b,'_',h(1:4)]);
p = struct(); 

if ipr.saveCode
    p.code = [outname '.txt'];
    fid = fopen(p.code, 'w+');
    fprintf(fid, '%c', char(getText(f)));
    fclose(fid);
end

if ipr.saveDependencies || ipr.saveLog
    % collate information
    t.filename = f;               t.timestamp = string(datetime('now'));
    t.parameters = ipr;           t.hash = h;
    t.code = fc;                  t.codeHashes = hc;
    t.data = fd;                  t.dataHashes = hd;

    % saveLog
    if ipr.saveLog
        % logname = fullfile(a, [b,'_',h(1:4), c, '.json']);
        logname = [outname '.json'];
        p.log = logname;
    else
        logname = fullfile(tempdir, [b,'_',h(1:4), c, '.json']);
    end
    writelines(jsonencode(t,'PrettyPrint',true), logname);

    % saveDependencies
    if ipr.saveDependencies
        % zipname = fullfile(a, [b,'_',h(1:4), c, '.zip']);
        zipname = [outname '.zip'];
        zip(zipname, [fc; {logname}]);
        p.dependencies = zipname;
    end
end

% p.code = [p.code '.txt'];
fclose('all');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helpers - put all in here to reduce dependencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rexor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = rexor(varargin) % recursive xor for many entries
if nargin < 1
    error("Not enough arguments in recursive XOR");
elseif nargin == 1
    out = varargin{1};
elseif nargin == 2
    out = xor(varargin{1}, varargin{2});
else
    out = xor(varargin{1}, rexor(varargin{2:end}));
end

end

% getCode %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = getCode(filename)
filetext = readlines(which(filename), ...
    'WhitespaceRule', 'trim', 'EmptyLineRule', 'skip');
idx = cell2mat(cellfun(@(x) isempty(x), regexp(filetext, "^\%"),'Uni',0));
out = join(filetext(idx), newline);
end

% getDependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = getDependencies(filename)
out = reshape( matlab.codetools.requiredFilesAndProducts(filename) ,[],1);
end

% getBinaryHash %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hash, filename] = getBinaryHash(filename)

if exist(filename, 'file') ~= 2; error("Unable to find file"); end
[~,~,a] = fileparts(filename);
if isempty(a)
    filename = which(filename);
    warning('File extension unspecified; hashing %s', filename);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
