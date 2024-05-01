---
layout: default
title: combineDependencies
checksum: 8c02d18aeec352b95f0f64fbb13557c7
---


 
# COMBINEDEPENDENCIES Combine dependencies into one file
 
# Syntax
```matlab
combineDependencies(filename)
combineDependencies(filename,Name,Value)
S = combineDependencies(___)
```
 
# Description

`combineDependencies(filename)` appends the dependencies of a MATLAB® script or function file to the end of that file.


`combineDependencies(filename,Name,Value)` appends the dependencies with additional options specified by one or more name-value pair arguments. For example, changing the output file or the text formatting.


`S = combineDependencies(_)` returns a string array of the text in the original file first, and then the text of each dependency.

 
# Examples
```matlab
combineDependencies('combineDependencies', 'outputFile', tempname('.'));
S = combineDependencies('combineDependencies', 'outputFile', tempname('.'), 'concise', true);
combineDependencies('combineDependencies', 'outputFile', tempname('.'), 'conciseDeps', true);
combineDependencies('combineDependencies', 'outputFile', tempname('.'), 'conciseOrig', true);
```
 
# Input Arguments

`filename - file name (string scalar | character vector)`

 
## Name-value Arguments

`outputFile - file path of output (string scalar | character vector)` If this is not input or is empty, the input file will be overwritten. Otherwise, this will overwrite the file supplied as input.


`sep - separating text between files (string scalar | character vector)` By default, there will be a line of `=` between each file.


`concise - whether to remove lines of comments and whitespace (false (default) | true)` If set to true, the text output will have whitespace trimmed, lines of whitespace removed, and lines starting with '%' removed. If set to false, the text output will be the same as the text input.


`conciseDeps - whether to reformat dependencies (false (default) | true)` If set to true, only the text from the dependencies will be reformatted as per `concise`.


`conciseOrig - whether to reformat original file (false (default) | true)` If set to true, only the text from the original file will be reformatted as per `concise`.

 
# Output Arguments

`S - file text (string array)` A string array where the first element is the text of the input code file, and the subsequent elements are the text from the dependencies (if any).

 
# Authors

Mehul Gajwani, Monash University, 2024

 
# See Also
```matlab
GETCODE, GETDEPENDENCIES
```
