---
layout: default
title: getFileHash
checksum: 17d1d41751f87be3a8f420d14ac0888e
---


 
# GETFILEHASH Get MD5sum of current function and dependencies
 
# Syntax
```matlab
getFileHash()
getFileHash(filename)
getFileHash(___,Name,Value)
```
```matlab
h = getFileHash(___)
[h,f] = getFileHash(___)
[h,f,p] = getFileHash(___)
[h,f,p,hc,fc] = getFileHash(___)
[h,f,p,hc,fc,hd,fd] = getFileHash(___)
```
 
# Description

`getFileHash` calculates the MD5sum of the script or function from where it is called, as well as its dependencies. This can act as a record of the state of the codebase when the function was run.


`getFileHash(filename)` runs the calculation for the script or function given by `filename`.


`getFileHash(_,Name,Value)` specifies additional properties using one or more name-value arguments, for example, whether to include dependencies, include comments, save a copy of the code file(s), or save a log file.


`h = getFileHash(_)` returns the hash of the script or function as a character vector.


`[h,f] = getFileHash(_)` also returns the filepath of the script or function as a character vector.


`[h,f,p] = getFileHash(_)` also returns the a struct containing the paths of any saved files (such as the script or function called, a log file, or a zip file of dependencies).


`[h,f,p,hc,fc] = getFileHash(_)` also returns the hashes and filepaths of any code dependencies of the script or function as a cell array of character vectors.


`[h,f,p,hc,fc,hd,fd] = getFileHash(_)` returns the hashes and filepaths of any data dependencies of the script or function as a cell array of character vectors.

 
# Examples
```matlab
getFileHash()
getFileHash('getFileHash')
getFileHash('getFileHash', 'codeOnly', true)
getFileHash('getFileHash', 'includeDependencies', false, 'codeOnly', false)
mlreportgen.utils.hash( fscanf(fopen(which('getFileHash')),'%c') )
system(['md5sum "',which('getFileHash'), '"']);
```
 
# Input Arguments

`filename - name or path of script of function to be hashed (string scalar | character vector)` If a filename is not supplied, `getFileHash` will hash the last function in the stack before it was called (as returned by `dbstack`).

 
## Name-Value Arguments

`includeDependencies - whether to include dependencies when computing file hash (true (default) | false)` If set to true, the hash returned will be the logical `xor` of the code file as well as its dependencies, and any binary files included as `data`.


`codeOnly - whether to keep only lines containing code (false (default) | true)` If set to true, lines containing only whitespace or starting with a `%` character will be removed from the computation of the hash. This may be useful if changing comments/layout in a script or function, and you want the hash to remain the same.


`data - additional filepath(s) to be included in the computation of the hash (cell array | string scalar | character vector)` If you want additional files (e.g. input data) to be included in the computation of the file hash, input the filepaths here. Their hash will be computer as binary data using system calls. The filepaths, but not the data itself, will be saved if `saveDependencies` is set to `true`.


`saveCode - whether to save a copy of the script or function (false (default) | true)` If set to true, a copy of the script or function will be saved in the current directory


`saveLog - whether to save a json file with metadata (false (default) | true)` If set to true, a json file containing the hashes of the code file, the dependencies, and the binary data of any `data` files will be saved in the same directory as the code file.


`saveDependencies - whether to save a copy of code and dependencies (false (default) | true)` If set to true, a copy of the code file, the dependencies, and the paths to any files specified in the `data` argument will be saved in the same directory as the code file.


`system - whether to use system calls to hash file as binary data (false (default) | true)` This is equivalent to `getBinaryHash(_)`.


`text - whether to hash file as if it were plaintext (false (default) | true)` This is equivalent to `getFileHash(_,'codeOnly',false,'includeDependencies',false)`.

 
# Output Arguments

`h - XOR of MD5sums of file, dependencies, and data (character vector)`


`f - path to script or function hashed (character vector)`


`p - struct containing paths to output files (struct)` This struct will contain the fields `code`, `dependencies`, and/or `log`, as appropriate.


`hc - hashes of code files and dependencies (cell array of character vectors)`


`fc - paths to code files and dependencies (cell array of character vectors)`


`hc - hashes of data files (cell array of character vectors)`


`fc - paths to data files (cell array of character vectors)`

 
# See Also
```matlab
hash, GETBINARYHASH, GETCODE, GETDEPENDENCIES
```
```matlab
getFileHash_test, getFileHash_example
```
 
# Authors

Mehul Gajwani, Monash University, 2024

