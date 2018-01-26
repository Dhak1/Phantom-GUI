function [innerCylinder, outerCylinder, center, radius] = gen2_get_i_cylinder_dani(image2D, radiusRange)
% #stg#
% Plan to get only inner and outer cylinders

innerCylinder = image2D;
outerCylinder = image2D;
image2D(isnan(image2D))=0;
[centers, radii] = imfindcircles(image2D,radiusRange,'ObjectPolarity','dark','Sensitivity',.8,'EdgeThreshold',0.1);
if size(centers)== 0
    try
        [centers, radii] = imfindcircles(image2D,radiusRange,'ObjectPolarity','bright','Sensitivity',.9,'EdgeThreshold',0);
    catch ME
        disp('cannot find center')
    end
end

if size(centers)== 0
    error('cannot find center')
end
%figure(10); imshow(image2D,[]);viscircles(centers,radii);
a = (centers(:,1)-size(image2D,1)).^2+(centers(:,2)-size(image2D,2)).^2;
[diff, i] = sort(abs(a));
center = centers(i(1),:); radius = radii(i(1));
%[columnsInImage rowsInImage] = meshgrid(1:size(image2D,1), 1:size(image2D,2));
[columnsInImage rowsInImage] = ndgrid(1:size(image2D,1), 1:size(image2D,2));

innerCylinder(((rowsInImage - center(1)).^2 + (columnsInImage - center(2)).^2) > radius.^2) = 0;
outerCylinder(((rowsInImage - center(1)).^2 + (columnsInImage - center(2)).^2) <= radius.^2) = 0;

end