---
layout: default
title: getDependencies
checksum: 995dad7fc8b226e245d1ff53beeaf52d
---


 
# GETDEPENDENCIES Finds dependencies for specified function, file, or folder
 
# Syntax
```matlab
deps = getDependencies(filename)
```
 
# Description

`deps = getDependencies(filename)` returns the dependencies of the script or function (or livescript or live function) of the input file.

 
# Examples
```matlab
getDependencies('getDependencies')
getDependencies('getFileHash_example')
```
 
# Input Arguments

`filename - file name (string scalar | character vector)`

 
# Output Arguments

`deps - dependencies (cell array of character vectors)`

 
# See Also
```matlab
getFileHash
```
 
# Authors

Mehul Gajwani, Monash University, 2024

