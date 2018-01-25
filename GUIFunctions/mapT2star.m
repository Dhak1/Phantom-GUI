function [Map] = mapT2star(T2Data,tes)
% mapT2star takes in 4D multi-echo gre t2*-weight images and a list of the
% echo times (tes) to map t2* decay across the brain/phantom

flagMark = 0;
numtes = size(T2Data,4);
if (length(tes)==numtes)
    tes = reshape(tes, numtes, 1);
    numrows = size(T2Data,1);
    numcols = size(T2Data,2);
    numslices = size(T2Data,3);
    
    Map = zeros(numrows,numcols,numslices,2);
    tes = [ones(numtes,1),tes];  % first columns is ones to allow fit of intercept (rho)
    T2Data = abs(T2Data);
    
    if (flagMark ~= 5)
        ydata = reshape(T2Data,[numrows*numcols*numslices,numtes]);
        lfit = tes \ log(double(ydata'));
        Map(:,:,:,1) = reshape(lfit(1,:),[numrows, numcols, numslices]);
        Map(:,:,:,2) = reshape(-1./lfit(2,:),[numrows, numcols, numslices]);
    end    
else
    
    display('Inappropriate number of TE values entered');
    flagMark = 5;
end

end

