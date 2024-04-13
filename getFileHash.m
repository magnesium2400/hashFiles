function [hOut, filename, hashesCode, filesCode, hashesData, filesData] = ...
    getFileHash(varargin)
%% GETFILEHASH Get MD5sum of current function and dependencies
%% Examples
%   getFileHash()
%   getFileHash('getFileHash')
%   getFileHash('getFileHash', 'codeOnly', true)
%   getFileHash('getFileHash', 'includeDependencies', false, 'codeOnly', false)
%   mlreportgen.utils.hash(join(readlines(which('getFileHash')),newline))
%   system(['md5sum "',which('getFileHash'), '"']);
%
%
%% TODO
% * docs
%
%
%% Authors
% Mehul Gajwani, Monash University, 2024
%
%


%% Prelims
ip = inputParser;
ip.addOptional('filename', [], @(x) isStringScalar(x) || ischar(x) || isempty(x));
ip.addParameter('includeDependencies', true, @islogical);
ip.addParameter('data', {}, @(x) isStringScalar(x) || ischar(x) || iscell(x));
ip.addParameter('codeOnly', false, @islogical);
ip.addParameter('saveCopy', false, @islogical);
ip.addParameter('saveDependencies', false);
ip.addParameter('system', false, @islogical);
ip.addParameter('text', false, @islogical);

ip.parse(varargin{:}); ipr = ip.Results;

if ~isempty(ipr.filename); filename = which(ipr.filename);
else;    temp = dbstack(); filename = which(temp(end).file);           end
if isempty(filename); error("Unable to find file"); end

if ipr.system; [hOut, filename] = getBinaryHash(ipr.filename); return; end
if ipr.text; ipr.includeDependencies = false; ipr.codeOnly = false;    end

if ipr.includeDependencies; filesCode = getDependencies(filename);
else;                       filesCode = {filename};                    end
if isempty(filesCode); filesCode = {filename}; end

if ipr.codeOnly; getText = @(x) getCode(x);
else;            getText = @(x) fscanf(fopen(x),'%c');                 end

if ~isempty(ipr.data); filesData = reshape(ipr.data, [], 1); 
else;                  filesData = {};                                 end
if isStringScalar(ipr.data)||ischar(ipr.data); filesData = {ipr.data}; end


%% Computations
hashText = @(t) char(mlreportgen.utils.hash(t));     % text to MD5 (in hex)
hash2bin = @(h) dec2bin(arrayfun(@(x) hex2dec(x), h),4) == '1';   % hex2bin
bin2hash = @(b) lower(arrayfun(@dec2hex, bin2dec(char(b+'0')))'); % bin2hex

hashesCode = cellfun( @(x) hashText(getText(x)), filesCode, 'Uni', 0);     % hex
hashesData = cellfun( @(x) getBinaryHash(x), filesData, 'Uni', 0);
hashesBin = cellfun( @(x) hash2bin(x), [hashesCode; hashesData], 'Uni',0); % bin
hOut = bin2hash(rexor(hashesBin{:}));                                      % hex


%% Save
if ipr.saveCopy
    [a,b,c] = fileparts(filename);
    fid = fopen(fullfile(a, [b,'_',hOut(1:4),c]), 'w+');
    fprintf(fid, '%c', char(getText(filename)));
end

if ipr.saveDependencies
    % collate information
    t.timestamp = string(datetime('now'));    t.parameters = ipr;
    t.filename = filename;                    t.hash = hOut;
    t.code = filesCode;                       t.codeHashes = hashesCode;
    t.data = filesData;                       t.dataHashes = hashesData; 

    % zip and save results
    [a,b,c] = fileparts(filename);
    logname = fullfile(a, [b,'_',hOut(1:4), c, '.json']);
    zipname = fullfile(a, [b,'_',hOut(1:4), c, '.zip']);
    writelines(jsonencode(t,'PrettyPrint',true), logname);
    zip(zipname, [filesCode; {logname}]);
    delete(logname);
end

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
