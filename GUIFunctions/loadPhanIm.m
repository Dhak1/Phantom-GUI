function [volume, cwd, name, fn] = loadPhanIm
% Last edited #stg# 8/1/16
[fn cwd] = uigetfile({'*.nii;*.hdr';'*.img'}); % filename and current working directory
cd(cwd)
if isstr(fn) && isstr(cwd)
    a = find(cwd == '\');
    b = size(a);
    if b(2) == 0
        a = find(cwd == '/');
    end
    a = a(end-1:end);
    name = cwd(a(1)+1:a(2)-1);
    
    volume = getim(fullfile(cwd,fn)); 
    
else
    name = '';
    volume = 0;
end
end