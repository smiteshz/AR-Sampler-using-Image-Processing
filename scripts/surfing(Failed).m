shot = imread('camtemp3.jpg');
temp = imread('temp.jpg');
%%
%figure
%imshow(shot);

%%
% imhist(shot(:,:,3))
% title('Histogram of the Red Band (Band 3)')

%%
strshot = imadjust(shot,stretchlim(shot));
grayimg = rgb2gray(strshot);
bw = im2bw(grayimg,0.4);
%imshow(bw)


%% Detect SURF Features
points1 = detectSURFFeatures(rgb2gray(temp));
points2 = detectSURFFeatures(bw);

[feats1,validpts1] = extractFeatures(rgb2gray(temp),points1);
[feats2,validpts2] = extractFeatures(bw,points2);

%% Display 100 strongest features from temp
figure;
imshow(temp);
hold on;
plot(validpts1.selectStrongest(100),'showOrientation',true);
title('Detected Features');

%% Match features
index_pairs = matchFeatures(feats1, feats2,...
                             'Prenormalized', true);
matched_pts1 = validpts1(index_pairs(:, 1));
matched_pts2 = validpts2(index_pairs(:, 2));
figure; 
showMatchedFeatures(temp,bw,matched_pts1,matched_pts2,'montage');
title('Initial Matches');
