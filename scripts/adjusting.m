shot = imread('camtemp1.jpg');
% 
% vid = videoinput('macvideo', 1);
%   set(vid,'FramesPerTrigger',inf);
%   set(vid, 'ReturnedColorSpace', 'RGB');
%   
%   shot = getsnapshot(vid);

%%
%figure
%imshow(shot);

%%
% imhist(shot(:,:,3))
% title('Histogram of the Red Band (Band 3)')

%%
 strshot = imadjust(shot,stretchlim(shot));
% figure
% imshow(strshot)

%%
%e = impixel(strshot);
red = strshot(:,:,1); green = strshot(:,:,2); blue = strshot(:,:,3);
thresh = 80
out = red<thresh & green<thresh & blue<thresh;
out1 = bwmorph(out, 'dilate', 1);
out2 = imcomplement(out1);
%imshow(out2)
%%
grayimg = single(out2);
imshow(grayimg)

%%
%bw = im2bw(grayimg,0.4);
%imshow(bw)

%%
%grayagain = single(bw)

%imshow(grayagain)