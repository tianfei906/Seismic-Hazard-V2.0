function[uhs]=builduhs(T,Ret,avgtype,optdspec)

im      = optdspec.im;
lambda  = optdspec.lambdauhs;
weights = optdspec.weights;

lambda    = nansum(lambda,5);
nT        = length(T);
Nsites    = size(lambda,1);
Nbranches = size(lambda,4);
uhs       = nan(nT,Nsites);

for i=1:Nsites
    Sa0=zeros(nT,Nbranches);
    for j=1:Nbranches
        lij = permute(lambda(i,:,:,j),[2,3,1]);
        Sa0(:,j) = uhspectrum(im,lij,1/Ret);
    end
    
    switch avgtype
        case 'Mean'
            uhs(:,i)=mean(Sa0,2);
        case 'Percentile 50'
            uhs(:,i)=prctile(Sa0,50,2);
    end
end
uhs = uhs.';