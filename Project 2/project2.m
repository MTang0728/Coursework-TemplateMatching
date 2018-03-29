clear all;
close all;
clc;

% read in the reference image and the template image
Picture = imread('/Users/michaeltang/Documents/MATLAB/3SK3/Project 2/sun.jpg');
% chagne the data formate to double and grayscale value
% double is used over uint8 for summing purpose
data = rgb2gray(im2double(Picture));
% detecting the size of the reference image
h_data = size(data,1);w_data = size(data,2);
% setting empty matrices the same size as the reference image
L1 = zeros(h_data,w_data);
L2 = L1; L_x = L1; L_y = L1;
L_mean = L1; L_var = L1;
EPx = L1; EPy = L1; EPx_1 = L1; EPy_1 = L1;
G_x = L1; G_y = L1; G_J = L1; G_mag = L1; G_dir = L1;
% creating the L1, L2, Lx, Ly summed area table
for i = 1:h_data
    for j = 1:w_data
        if i == 1 && j == 1
            L1(i,j) = data(i,j);
            L2(i,j) = data(i,j)^2;
            L_x(i,j) = j*data(i,j);
            L_y(i,j) = i*data(i,j);
        elseif i == 1
            L1(i,j) = L1(i,j-1) + data(i,j);
            L2(i,j) = L2(i,j-1) + data(i,j)^2;
            L_x(i,j) = L_x(i,j-1) + j*data(i,j);
            L_y(i,j) = L_y(i,j-1) + i*data(i,j);
        elseif j == 1
            L1(i,j) = L1(i-1,j) + data(i,j);
            L2(i,j) = L2(i-1,j) + data(i,j)^2;
            L_x(i,j) = L_x(i-1,j) + j*data(i,j);
            L_y(i,j) = L_y(i-1,j) + i*data(i,j);
        else
            L1(i,j) = L1(i-1,j) + L1(i,j-1) - L1(i-1,j-1) + data(i,j);
            L2(i,j) = L2(i-1,j) + L2(i,j-1) - L2(i-1,j-1) + data(i,j)^2;
            L_x(i,j) = L_x(i-1,j) + L_x(i,j-1) - L_x(i-1,j-1) + j*data(i,j);
            L_y(i,j) = L_y(i-1,j) + L_y(i,j-1) - L_y(i-1,j-1) + i*data(i,j);
        end
    end
end
%creating the mean table
for i = 1:size(L1,1)
    for j = 1:size(L1,2)
        L_mean(i,j) = L1(i,j) / (i*j);
    end
end
%creating the variance table
for i = 1:h_data
    for j = 1:w_data
        L_var(i,j) = (L2(i,j) - 2*L1(i,j)*L_mean(i,j) + i*j*L_mean(i,j)^2) / (i*j);
    end
end
%creating the EP operator in X and Y direction
for i = 1:h_data
    for j = 1:w_data
        EPx(i,j) = j - (w_data + 1) / 2;
        EPy(i,j) = i - (h_data + 1) / 2;
    end
end
%creating the EP summed table for normalization
for i = 1:h_data
    for j = 1:w_data
        if i == 1 && j == 1
            EPx_1(i,j) = abs(EPx(i,j));
            EPy_1(i,j) = abs(EPy(i,j));
        elseif i == 1
            EPx_1(i,j) = EPx_1(i,j-1) + abs(EPx(i,j));
            EPy_1(i,j) = EPy_1(i,j-1) + abs(EPy(i,j));
        elseif j == 1
            EPx_1(i,j) = EPx_1(i-1,j) + abs(EPx(i,j));
            EPy_1(i,j) = EPy_1(i-1,j) + abs(EPy(i,j));
        else
            EPx_1(i,j) = EPx_1(i-1,j) + EPx_1(i,j-1) - EPx_1(i-1,j-1) + abs(EPx(i,j));
            EPy_1(i,j) = EPy_1(i-1,j) + EPy_1(i,j-1) - EPy_1(i-1,j-1) + abs(EPy(i,j));
        end
    end
end
%creating the gradient component tables Gx(D) and Gy(D)
J_term = (h_data + 1) / 2;
for i = 1:h_data
    for j = 1:w_data
        G_x(i,j) = (L_x(i,j) - J_term * L1(i,j)) / EPx_1(i,j);
        G_y(i,j) = (L_y(i,j) - J_term * L1(i,j)) / EPy_1(i,j);
    end
end
%creating the gradient magnitude and direction
for i = 1:h_data
    for j = 1:w_data
        G_mag(i,j) = sqrt((G_x(i,j)^2) + (G_y(i,j)^2));
        G_dir(i,j) = rad2deg(atan(G_y(i,j) / G_x(i,j)));
    end
end

        