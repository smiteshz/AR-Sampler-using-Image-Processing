
%% Start capture 
vid = videoinput('macvideo', 1); set(vid,'FramesPerTrigger',inf); set(vid, 'ReturnedColorSpace', 'RGB');
 
 vid.FrameGrabInterval = 1;
%% 

temp = imread('temp.jpg');
shot = getsnapshot(vid);
shot = imread('camtemp3.jpg');

%% Contrast Stretch
strshot = imadjust(shot,stretchlim(shot));
% figure
% imshow(strshot)

%% Thresholding
red = strshot(:,:,1); green = strshot(:,:,2); blue = strshot(:,:,3);
thresh = 80
out = red<thresh & green<thresh & blue<thresh;
out1 = bwmorph(out, 'dilate', 1);
out2 = imcomplement(out1);

%% Convert to Single
a = single(rgb2gray(temp));
imshow(a);

b = single(out2);
imshow(b);

%% Detect SiFt Features

[F1 D1] = vl_sift(a); %temp
[F2 D2] = vl_sift(b); %shot

[matches score] = vl_ubcmatch(D1,D2,1.5); 

x = F2(1,matches(2,:));
y = F2(2,matches(2,:));

%% Plot matches
subplot(1,2,1);
    imshow(uint8(a));
    hold on;
    plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'b*');
subplot(1,2,2);
    imshow(b);
    hold on;
    plot(F2(1,matches(2,:)),F2(2,matches(2,:)),'r*');



%% Bound Points
xmin = min(x)+50;
xmax = max(x)-50;
ymin = min(y);
ymax = max(y);
xint = (xmax-xmin)/5;
x1 = xmin + xint;
x2 = xmin + 2*xint;
x3 = xmin + 3*xint;
x4 = xmin + 4*xint;

% (xtl, ytl) = 
% tr
% bl
% br


%% Convex Hull Trapezoid
 k = convhull(x,y);
 plot(x(k),y(k),'r-');

%%
l = 400; m =250
in = inpolygon(l,m,x(k),y(k));
plot(l(in), m(in), 'g*', l(~in), m(~in), 'y*')




