%% Test 1: check getting file from stack
[a,f] = getFileHash(); %#ok<*ASGLU> 
b = getFileHash('getFileHash_test'); 
c = getFileHash('runtests');
d = getFileHash('getFileHash');

% disp(f); 
assert(strcmp(a,b) || strcmp(a,c)); % allows user to run from this script, or from `runtests('getFileHash_test')`
assert(~strcmp(a,d));


%% Test 2: check getting file from stack with options changed
opts = {'codeOnly', true, 'includeDependencies', false};
[a,f] = getFileHash([], opts{:}); % disp(f); 
b = getFileHash('getFileHash_test', opts{:}); 
c = getFileHash('runtests', opts{:});
d = getFileHash('getFileHash', opts{:});

assert(strcmp(a,b) || strcmp(a,c)); % allows user to run from this script, or from `runtests('getFileHash_test')`
assert(~strcmp(a,d));


%% Test 3: check against system & without file processing
a = getFileHash('getFileHash_test.m', 'system', true);
b = getFileHash('getFileHash_test.m', 'codeOnly', false, 'includeDependencies', false);
c = getFileHash('getFileHash_test.m', 'codeOnly', true, 'includeDependencies', false);
d = getFileHash('getFileHash_test.m', 'codeOnly', false, 'includeDependencies', true);
e = getFileHash('getFileHash_test.m', 'codeOnly', true, 'includeDependencies', true);

assert(strcmp(a, b)); 
assert(~strcmp(a, c) && ~strcmp(a,d) && ~strcmp(a,e)); 


%% Test 4: processing of `data` input
a = getFileHash('getFileHash'); 
b = getFileHash('getFileHash', 'data', {'getFileHash.m'}); 
c = getFileHash('getFileHash', 'data', {'getFileHash.m', 'getFileHash.m'}); 

assert(strcmp(a, c)); 
assert(strcmp(b, repmat('0', 1, 32)));

hash2bin = @(h) dec2bin(arrayfun(@(x) hex2dec(x), h),4) == '1';  
d = hash2bin(getFileHash('getFileHash', 'codeOnly', true)); 
e = hash2bin(getFileHash('getFileHash', 'text', true)); 
f = hash2bin(getFileHash('getFileHash', 'codeOnly', true, 'data', {'getFileHash.m'})); 

assert(all(xor(d,e) == f, 'all'));

