---
layout: default
title: getCode
checksum: 31895a46e1ba2ab9b5101f554502f9a6
---


 
# GETCODE Reads text from code file, excluding comment or whitespace lines
 
# Syntax
```matlab
S = getCode(filename)
```
 
# Description

`S = getCode(filename)` creates a string by concatenating the lines from a script or function file, excluding lines of only whitespace or starting with a `%` character, and trimming whitespace on each line.

 
# Examples
```matlab
getCode('getCode')
```
 
# Input Arguments

`filename - file name (string scalar | character vector)`

 
# Output Arguments

`S - file text (string scalar)`

 
# See Also
```matlab
READLINES, REGEXP, JOIN, getFileHash
```
 
# Authors

Mehul Gajwani, Monash University, 2024

