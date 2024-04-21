
# `hashFiles`: track your codebase whenever you run your code

Simply download or clone the repo (from [here](https://github.com/magnesium2400/hashFiles/tree/main)), add it to your path, and then add then the line `getFileHash('saveCode', true);` to a script or function. This will save a copy of the code file at the time you ran it - as well as a checksum of the code file and its dependencies so you can verify it later.

You can also try `getFileHash('saveLog', true);` or `getFileHash('saveDependencies', true);` to save even more information about the script or function you are running. 

Note that `getFileHash` automatically hashes the current code file, as well as its dependencies. You can control this behaviour easily: 
- If you want to hash a different file, use it as the first argument: `getFileHash(filename);`
- If you don't want to include dependencies, specify this using name-value syntax: `getFileHash(___, 'includeDependencies', false);`
- If you don't want to track changes to comments or whitespace: `getFileHash(___, 'codeOnly', true);`
- If you want to include additional files when the hash is computed, specify these as additional arguments to `data`: `getFileHash(___, 'data', {filename1, filename2});`
- If you just want the hash of the current code, and not to save a copy: `h = getFileHash();`

For more information see the [full documentation](https://magnesium2400.github.io/hashFiles/getFileHash.html) of the `getFileHash` function or the provided [example script](https://github.com/magnesium2400/hashFiles/blob/main/getFileHash_example.m). 


