function out = getCode(filename)

% get text
filetext = readlines(which(filename), ...
    'WhitespaceRule', 'trim', 'EmptyLineRule', 'skip');

% remove lines that start with '%' character
idx = cell2mat(cellfun(@(x) isempty(x), regexp(filetext, "^\%"),'Uni',0));
out = join(filetext(idx), newline);

end