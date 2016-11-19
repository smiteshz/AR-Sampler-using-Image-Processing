temp = imread('temp.jpg');
shot = imread('camtemp1.jpg');
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
grayimg = rgb2gray(strshot);
bw = im2bw(grayimg,0.3);

%imshow(bw)

%%
a = single(rgb2gray(temp));
imshow(a)

%%
b = single(bw);
imshow(b)

%% Detect SiFt Features

[F1 D1] = vl_sift(a);
[F2 D2] = vl_sift(b);

[matches score] = vl_ubcmatch(D1,D2,1.5); 

subplot(1,2,1);
    imshow(uint8(a));
    hold on;
    plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'b*');
subplot(1,2,2);
    imshow(b);
    hold on;
    plot(F2(1,matches(2,:)),F2(2,matches(2,:)),'r*');
    