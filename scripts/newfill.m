vid = videoinput('winvideo', 1, 'MJPG_320x240');
set(vid,'FramesPerTrigger',inf);
set(vid, 'ReturnedColorSpace', 'RGB');

vid.FrameGrabInterval = 1;

    
    a = getsnapshot(vid);
    
    b = imread('temp.jpg');
    
%     %% Contrast Stretch
% strshot = imadjust(shot,stretchlim(shot));
% % figure
% % imshow(strshot)
% 
% %% Thresholding
% red = strshot(:,:,1); green = strshot(:,:,2); blue = strshot(:,:,3);
% thresh = 80
% out = red<thresh & green<thresh & blue<thresh;
% out1 = bwmorph(out, 'dilate', 1);
% out2 = imcomplement(out1);
% 
% %% Convert to Single
% b = single(rgb2gray(temp));
% 
% 
% a = single(out2);
% imshow(a)
%%
    
    b=single(rgb2gray(b));
    a=single(rgb2gray(a));
    [F1 D1] = vl_sift(a, 'PeakThresh', 8, 'edgethresh', 40);
    [F2 D2] = vl_sift(b, 'PeakThresh', 8,'edgethresh', 40);
    [matches score] = vl_ubcmatch(D1,D2,1.5);
    xmin = min(F1(1,matches(1,:)));
    xmax = max(F1(1,matches(1,:)));
    ymin = min(F1(2,matches(1,:)));
    ymax = max(F1(2,matches(1,:)));
    xint = (xmax-xmin)/5;
    yd = ymax - ymin;
    x1 = xmin + xint;
    x2 = xmin + 2*xint;
    x3 = xmin + 3*xint;
    x3 = xmin + 4*xint;
    
    
    imshow(uint8(a));
    hold on;
    plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'b*');
    plot([xmin,xmin,xmax,xmax,xmin],[ymin,ymax,ymax,ymin,ymin],'r');
try  
    start(vid);
    
    %delay(2);
    
    
    while(vid.FramesAcquired<=800)
        data = getsnapshot(vid);
        
        imshow(uint8(data));
        
        
        hold on;
        plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'b*');
        plot([xmin,xmin,xmax,xmax,xmin],[ymin,ymax,ymax,ymin,ymin],'r');
        
        diff_im = imsubtract(data(:,:,1),rgb2gray(data));
        diff_im = medfilt2(diff_im, [3, 3]);
        diff_im = im2bw(diff_im, 0.12);
        diff_im = bwareaopen(diff_im, 300);
        bw = bwlabel(diff_im, 8);
        
        stats = regionprops(bw, 'BoundingBox', 'Centroid');
        
        hold on;
        for object = 1 : length(stats)
            bb = stats(object).BoundingBox;
            bc = stats(object).Centroid;
            rectangle('Position',bb,'EdgeColor','r','LineWidth', 2);
            plot(bc(1),bc(2),'-m+');
            
            
            if (bc(2)<=ymax && bc(2)>=ymin) && (bc(1)<=xmax && bc(1)>=xmin)
                if bc(1) < x1
                    %
                    plot([x1, x1],[ymin, ymax],'b');
                    rectangle('Position',[xmin,ymin,xint,yd],'Curvature',[1,1],'FaceColor','r');
                    [l,f,m] = wavread('1.wav');
                    sound(l,f,m);
                elseif bc(1) < x2
                    %
                    plot([x1, x1],[ymin, ymax],'b');
                    plot([x2, x2],[ymin, ymax],'b');
                    rectangle('Position',[x1,ymin,xint,yd],'Curvature',[1,1],'FaceColor','r');
                    [l,f,m] = wavread('2.wav');
                    sound(l,f,m);
                elseif bc(1) < x3
                    %
                    plot([x2, x2],[ymin, ymax],'b');
                    plot([x3, x3],[ymin, ymax],'b');
                    rectangle('Position',[x2,ymin,xint,yd],'Curvature',[1,1],'FaceColor','r');
                    [l,f,m] = wavread('3.wav');
                    sound(l,f,m);
                elseif bc(1) < x4
                    %
                    plot([x3, x3],[ymin, ymax],'b');
                    plot([x4, x4],[ymin, ymax],'b');
                    rectangle('Position',[x3,ymin,xint,yd],'Curvature',[1,1],'FaceColor','r');
                    [l,f,m] = wavread('4.wav');
                    sound(l,f,m);
                else
                    %
                    plot([x4, x4],[ymin, ymax],'b');
                    rectangle('Position',[x4,ymin,xint,yd],'Curvature',[1,1],'FaceColor','r');
                    [l,f,m] = wavread('5.wav');
                    sound(l,f,m);
                end
            end
        end
        hold off;
        
    end
    
    stop(vid);
    flushdata(vid);
    clear all;
    
catch
    stop(vid);
    imaqreset;
    disp('Cleaned up');
    %rethrow(err);
end

