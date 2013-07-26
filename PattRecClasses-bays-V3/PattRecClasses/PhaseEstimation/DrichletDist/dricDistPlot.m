% This function is to plot a two Dimension Drichlet distribution. 
% theta is the parameters of the distribution
% eps is the mesh size. 


function [x,y]=dricDistPlot(theta, eps)

k=1;
x(1)=0;
iteration =1/eps+1;
A=zeros(iteration,iteration);

while x<=1
   y = dirpdf([x(k),1-x(k)],[theta(1),theta(2)]);
   
   
   A(k, iteration-k+1)=y;
   
   x(k+1)= x(k)+eps;
   k=k+1;

end

figure;
contour(A);

figure;
surf(A);
