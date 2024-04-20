---
layout: default
title: getBinaryHash
checksum: eeb75ea4e101b70c87c11dc542aa623f
---


 
# GETBINARYHASH Use system call to find MD5sum of file, treated as binary data
 
# Syntax
```matlab
h = getBinaryHash(filename)
[h,f] = getBinaryHash(filename)
```
 
# Description

`h = getBinaryHash(filename)` returns the MD5sum of the input file, using system calls and treating the file as if it were binary data.


`[h,f] = getBinaryHash(filename)` also returns the absolute path to the file.

 
# Examples
```matlab
getBinaryHash('getBinaryHash.m')
getBinaryHash('getBinaryHash') % expected warning
mlreportgen.utils.hash( fscanf(fopen(which('getBinaryHash.m')),'%c') )
system(['md5sum "',which('getFileHash'), '"']);
```
 
# Input Arguments

`filename - file name (string scalar | character vector)`

 
# Output Arguments

`h - MD5sum of file (character vector)`


`f - absolute path to file hashed (character vector)`

 
# See Also
```matlab
SYSTEM, WHICH, getFileHash
```
 
# Authors

Mehul Gajwani, Monash University, 2024

