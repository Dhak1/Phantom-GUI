function [t2star_s,cross_mask,angDeg,center,radius] = registerSpokesT2s( t2starmap , sliceNum, radii ,ifplot)
%find the angle of the cartridge with 4 quadrantsr

if nargin < 3
    inrad =15;
    outrad = 25;
else
    inrad = radii(1);
    outrad = radii(2);
end

if nargin < 4
    ifplot=0;
end


[innerCylinder, outerCylinder, center, radius] = gen3_get_i_cylinder(t2starmap(:,:,sliceNum,1),[inrad outrad]);
% figure; imshowpair(innerCylinder,outerCylinder) %ensure the segmentations are accurate

% Get inner cylinder T2* maps
t2star_ic = t2starmap(:,:,sliceNum,end);
t2star_ic(innerCylinder==0)=0;

% Get edges (segment?)
edgeMap = double(edge(t2star_ic,'Canny',0.01));
%edgeMap = double(edge(t2star_ic,'Sobel',2));
s=floor(size(edgeMap)/2);
%indc=(s-floor(radius*1.3):s+floor(radius*1.3));




% figure(1);
% %imagesc(t2star_ic(indc),[0 80]);maskOverlay_simple(edgeMap(indc));
% imagesc(t2star_ic,[0 80]);maskOverlay_simple(edgeMap);

%% Make sharp spokes with the above derived center and radius; given the number of segments 
xstart = center(2);ystart = center(1);
[ spokes_img ] = create_cross( [xstart ystart], floor(radius),edgeMap,0.02);
%figure(2);imshow(edgeMap);maskOverlay_simple(spokes_img(:,:,1));

%% Register spokes with derived edgemap to get exact outlines.
[ind,vals] = register_imgs( edgeMap,spokes_img,0);
angDeg=(ind-1)*0.02*180/pi;

cross_img=create_cross( s, floor(radius),edgeMap,pi/2);
spokes_registered=imrotate(cross_img,angDeg,'nearest','crop');
spokes_registered=imtranslate(spokes_registered,center-[s(2) s(1)]);
cross_mask=spokes_registered;
%figure(3);imshow(t2star_ic,[0 80]);maskOverlay_simple(im2bw(spokes_registered));


%% Threshold impossible values from T2* map (in seconds)
if size(t2starmap,4)>1
    t2star_s = squeeze(t2starmap(:,:,:,2));
    t2star_s(t2star_s<0)=0;
    t2star_s(t2star_s>80)=0;
else
        t2star_s = t2starmap;
end

if ifplot
    figure(1);imshowpair(t2star_s(:,:,sliceNum),[0 80]);maskOverlay_simple(im2bw(cross_mask));
end

end

