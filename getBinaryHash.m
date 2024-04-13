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
