temp = imread('temp.jpg');
shot = imread('camtemp2.jpg');
%vid = videoinput('macvideo', 1); set(vid,'FramesPerTrigger',inf);  set(vid, 'ReturnedColorSpace', 'RGB');  shot = getsnapshot(vid);

%% Contrast Stretch
strshot = imadjust(shot,stretchlim(shot));
% figure
% imshow(strshot)

%% Thresholding
red = strshot(:,:,1); green = strshot(:,:,2); blue = strshot(:,:,3);
thresh = 40
out = red<thresh & green<thresh & blue<thresh;
out1 = bwmorph(out, 'dilate', 1);
out2 = imcomplement(out1);

%% Convert to Single
a = single(rgb2gray(temp));
imshow(a);

b = single(out2);
imshow(b);

%% Detect SiFt Features

[F1 D1] = vl_sift(a);
[F2 D2] = vl_sift(b);

[matches score] = vl_ubcmatch(D1,D2,1.5); 

subplot(1,2,1);
    imshow(uint8(a));
    hold on;
    plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'b*');
subplot(1,2,2);
    
    hold on;
    plot(F2(1,matches(2,:)),F2(2,matches(2,:)),'r*');

    
