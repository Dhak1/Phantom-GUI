function [masks_ic, maskSize_ic,masks_oc,maskSize_oc] = generateMasks5(image2D,numEdges,c_radii,tolerance,radialIdent) 

% *********#stg#*************
% Outer Cylinder Mask doesn't exist yet
% *********#stg#*************

if nargin<1
    display('No input image size specified, creating an 84x84 matrix')
    image2D = zeros(84,84);
end

if nargin < 2
    display('Number of edges not specified, assuming 16')
    numEdges = 16; %3 unique values, innerCylinderOut, outerCylinderIn, outerCylinderOut, in increasing order
end

if nargin < 3
    display('No input radii, assuming [9.6 10.8 24.4]')
    c_radii = [9.6 10.8 24.4]; %3 unique values, innerCylinderOut, outerCylinderIn, outerCylinderOut, in increasing order

end

if nargin < 4
    tolerance = pi/numEdges/2 ; 
end

if nargin < 5
    radialOuterIdent=0.6;
    radialInnerIdent=0.35;
else
    radialOuterIdent = radialIdent(1);
    radialInnerIdent = radialIdent(2);
end

%% need to work on phase, does not create full masks
maskPhase = pi/numEdges ;

[x,y] = meshgrid(1:size(image2D,2), 1:size(image2D,1));

masks_ic = zeros(size(image2D,1)*size(image2D,2),numEdges);
maskSize_ic = zeros(numEdges,1);
%%
mapExist=0;
if mapExist == 1
 %edit option to reuse scripts for mask creation on real data #stg#
else
  %   c_center = size(image2D)/2; 
    c_center(1:2)=c_radii(2:3);
%     theta1 = [-pi/numEdges:2*pi/numEdges:pi , ...
%     -pi+pi/numEdges:2*pi/numEdges:-pi/numEdges]; % matlab's cookie angle
%     issues
    theta1 =  maskPhase + [(pi/2-pi/numEdges:2*pi/numEdges:pi) (-pi+pi/numEdges:2*pi/numEdges:pi/2)];

    tanMap = atan2(x-c_center(1),y-c_center(2));
    radiiMap = ((y-c_center(2)).^2+(x-c_center(1)).^2);
    
    for iEdge = 1:numEdges
        if theta1(iEdge)<theta1(iEdge+1) 
            angIDX = find((tanMap> theta1(iEdge) + tolerance & ...
                tanMap <= theta1(iEdge+1) - tolerance  )& ... % establish angle range
                radiiMap<(c_radii(1)*(1-radialOuterIdent))^2 & ...
                radiiMap>(c_radii(1)*radialInnerIdent)^2); % Within inner cylinder radius
        else 
            angIDX = find((tanMap > -theta1(iEdge) + tolerance  & ...
                tanMap <= theta1(iEdge+1) - tolerance )  & ... % establish angle range
                radiiMap<(c_radii(1)*(1-radialOuterIdent))^2 & ...
                radiiMap>(c_radii(1)*radialInnerIdent)^2); % Within inner cylinder radius
        end
            masks_ic(angIDX,iEdge) = 1;
            maskSize_ic(iEdge) = numel(angIDX);
    end
end

masks_oc=radiiMap>(c_radii(1)*1.5)^2 & radiiMap<(c_radii(1)*1.7)^2 ;
maskSize_oc=nnz(masks_oc);
masks_ic = reshape(masks_ic, [size(image2D,1),size(image2D,2),numEdges]);
end