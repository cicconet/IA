function list = listfiles(folderpath, fileextension)
% returns a cell array with the full filepaths of files ending with 'fileextension' in folder 'folderpath'
% fileextension examples: '.tif', '.png', '.txt'
listing = dir(folderpath);
index = 0;
for i = 1:size(listing,1)
    s = listing(i).name;
    if ~isempty(strfind(s,fileextension))
        index = index+1;
        list{index} = [folderpath filesep s];
    end
end