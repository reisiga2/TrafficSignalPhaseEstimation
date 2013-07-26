% this is a function to generate random values from unif[a,b]

% a= min value
%b =max value
% N,M size of the matrix if you want scalar set N=1;

function randomValu = generate_UnifRand(a,b,N,M)

    randomValu = a + (b-a)*rand(N,M);
    
end