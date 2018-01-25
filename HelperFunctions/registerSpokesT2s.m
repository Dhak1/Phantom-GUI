function [angDeg,t2star_s,center,radius] = registerSpokesT2s( fname , TEs ,sliceVec)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%img = MRIread(fname); % FreeSurfer's tool
%T2Data = img.vol; %image matrix
img=nii_tool('load',fname);
T2Data= img.img;
%TEs = 5:5:60; % Echo times in T2*-weighted image
[t2starmap] = mapT2star(T2Data,TEs);

for sliceNum = sliceVec
    [innerCylinder, outerCylinder, center, radius] = gen2_get_i_cylinder_dani(t2starmap(:,:,sliceNum,1),[15 25]);
    % figure; imshowpair(innerCylinder,outerCylinder) %ensure the segmentations are accurate
    
    % Get inner cylinder T2* maps
    t2star_ic = t2starmap(:,:,sliceNum,2);
    t2star_ic(innerCylinder==0)=0;
    
    % Get edges (segment?)
     edgeMap = double(edge(t2star_ic,'Canny',0.01));
    %edgeMap = double(edge(t2star_ic,'Sobel',2));
    s=floor(size(edgeMap)/2);
    indc=(s-floor(radius*1.3):s+floor(radius*1.3));

end


figure(1);
%imagesc(t2star_ic(indc),[0 80]);maskOverlay_simple(edgeMap(indc));
imagesc(t2star_ic,[0 80]);maskOverlay_simple(edgeMap);

%% Make sharp spokes with the above derived center and radius; given the number of segments 
xstart = center(2);ystart = center(1);
[ spokes_img ] = create_cross( [xstart ystart], floor(radius),edgeMap,0.02);
figure(2);imshow(edgeMap);maskOverlay_simple(spokes_img(:,:,1));

%% Register spokes with derived edgemap to get exact outlines.
[ind,vals] = register_imgs( edgeMap,spokes_img,0);
angDeg=(ind-1)*0.02*180/pi;

cross_img=create_cross( s, floor(radius),edgeMap,pi/2);
spokes_registered=imrotate(cross_img,angDeg,'nearest','crop');
spokes_registered=imtranslate(spokes_registered,center-[s(2) s(1)]);
figure(3);imshow(t2star_ic,[0 80]);maskOverlay_simple(im2bw(spokes_registered));


%% Threshold impossible values from T2* map (in seconds)

t2star_s = squeeze(t2starmap(:,:,:,2));
t2star_s(t2star_s<0)=0;
t2star_s(t2star_s>100)=0;
end
