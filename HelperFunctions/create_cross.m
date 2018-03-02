function [ cross_mat ] = create_cross( center, radius ,mat, dtheta)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%% Make sharp spokes with the above derived center and radius; given the number of segments 
% ideal map to be later registered to edgeMap
% [x,y] = meshgrid(1:size(edgeMap,1), 1:size(edgeMap,1));
if nargin<4 
    dtheta=0.1;
end
xstart = center(1);ystart = center(2);
iSpoke = 100;
theta0=0:dtheta:(pi/2-dtheta);
l=length(theta0);
cross_mat = zeros([size(mat),l]);
s=size(mat);
for ii=1:l
    spokes_img = zeros(size(mat));
    for jj=0:3
    [xend,yend] = pol2cart(theta0(ii)+pi/2*jj,radius);
    xline = [xstart xstart+xend];
    yline = [ystart ystart+yend];
    p = polyfit(xline,yline,1);
    if abs(xline(1) - xline(2))<1e-7
        yvals = linspace(yline(1),yline(2));
        xvals = xline(1)*ones(size(yvals));
       % fprintf('xline equal \n')
    else 
        xvals = linspace(xline(1),xline(2));
        yvals = polyval(p,xvals);
        %fprintf('xline unequal \n')
    end
    indices = sub2ind(size(mat),ceil(xvals),ceil(yvals));
    spokes_img(indices) = iSpoke;
    cross_mat(:,:,ii)=spokes_img;
   % iSpoke=iSpoke+1;
    end
end
%spokes_img(xstart-1:xstart+1,ystart-1:ystart+1)=iSpoke;

end

