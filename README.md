# Coursework-TemplateMatching
The repository contains the coursework for template matching problem using Summed Table 

Originall, template matching can be done by creating a sliding window of the same size as the template image (patch). Since each image is essentially a matrix with each of its elements representing a scale indicating the color intensity, statistical features such as pixel mean value could then be calculated for each respective window and compared to that of the template image. The window with closest match could potentially contain the same info as the template image.
However, one drawback of this sliding window would be that since the window moves with each iteration, the elements that it contains are changing constantly. This nested loop would further complicate the program and introduce unnecessary time to execute the program.

To perform the task more efficiently, a summed area table can be utilized to help ease the process for calculating the mean pixel value. The advantage of using this algorithm is its fast processing speed. The utilization of summed table significantly reduces the processing time. It can be created at the beginning of the code and be used anywhere later on in the code. On top of that, the idea of using mean pixel value also helps save time because it is a very simple operation.
One of the weaknesses of this algorithm is that, if the reference image and template image (patch) are both statistically invariant across all their pixels, statistical features such as mean pixel value might not give a precise matching.

Project 1 uses mean value as the statisical feature to match the template

Project 2 uses gradient as a statistical feature to match the template

NOTE:
Please change the image reading directories in the .m file
