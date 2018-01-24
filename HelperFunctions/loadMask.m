function [mask] = loadMask
    [fn dr] = uigetfile({'*.mat;*.nii;*.hdr'});
%     cd(dr);
    a=strsplit(fn,'.');
    a = a(2);
    if strcmp(a,'mat')
        mask = importdata(fullfile(dr,fn));
    else
        [mask] = getim(fullfile(dr,fn));
    end
end