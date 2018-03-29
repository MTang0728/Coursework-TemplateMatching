clear all;
close all;
clc;

% read in the reference image and the template image
Picture = imread('/Users/michaeltang/Documents/MATLAB/3SK3/Project 1/Friends.png');
Template = imread('/Users/michaeltang/Documents/MATLAB/3SK3/Project 1/Chandler.png');
% chagne the data formate to double and grayscale value
% double is used over uint8 for summing purpose
Friends = rgb2gray(im2double(Picture));
Ross = rgb2gray(im2double(Template));
% detecting the size of the template image
size_Ross = size(Ross);
h_Ross = size_Ross(1); w_Ross = size_Ross(2);
% determing the average value of the template matrix, to be compared with
% the average of the sliding window
cumsum_Ross = cumsum(cumsum(Ross,1),2);
sum_Ross = cumsum_Ross(h_Ross,w_Ross);
mean_Ross = sum_Ross / (h_Ross * w_Ross);
% detecting the size of the reference image
size_Friends = size(Friends);
h_Friends = size_Friends(1);w_Friends = size_Friends(2);
sumtable = zeros(h_Friends,w_Friends);
% creating the summed area table
for i = 1:h_Friends
    for j = 1:w_Friends
        if i == 1 && j == 1
            sumtable(i,j) = Friends(i,j);
        elseif i == 1
            sumtable(i,j) = sumtable(i,j-1) + Friends(i,j);
        elseif j == 1
            sumtable(i,j) = sumtable(i-1,j) + Friends(i,j);
        else
            sumtable(i,j) = sumtable(i-1,j) + sumtable(i,j-1) - sumtable(i-1,j-1) + Friends(i,j);
        end
    end
end
% initializing a variable for the location of top left of the determined
% sliding window. Setting an arbitrary value of 10 as the difference
% between the average of the selected window and that of the template
loc = [0,0];
diff = 10;
% calculate the area of for each region of the summed table
for i = 1:(h_Friends - h_Ross + 1)
    for j = 1: (w_Friends - w_Ross + 1)
        %area A
        if i == 1 || j == 1
            A = 0;
        else
            A = sumtable(i-1,j-1);
        end
        %area AB
        if i == 1
            AB = 0;
        else
            AB = sumtable(i-1,j+w_Ross-1);
        end
        %area AC
        if j == 1
            AC = 0;
        else
            AC = sumtable(i+h_Ross-1,j-1);
        end
        %area ABCD
        ABCD = sumtable(i+h_Ross-1,j+w_Ross-1);
        %area of D         
        D = ABCD - AB - AC + A;
        %mean of D         
        mean_D = D / (w_Ross * h_Ross);
        %calculate the difference of the mean values, and register its current location
        %if a smaller differnece is found         
        if abs(mean_D - mean_Ross) < diff
            diff = abs(mean_D - mean_Ross);
            loc(1) = i;
            loc(2) = j;
        end
    end
end
% display the template image and its location on the reference image
subplot(2,1,1);
imshow(Template);title('Template Image');
subplot(2,1,2);
imshow(Picture);title('Reference Image(Red Box Indicates Template Image)');
hold on
rectangle('Position', [loc(2),loc(1), w_Ross, h_Ross], 'EdgeColor','r');

toc;

