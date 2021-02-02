function Y=dsha_is(opt,Nsim,Nsites,scenarios,mu,L,etype)

pd = makedist('normal');
sigma = opt.Sigma;
if ~isempty(sigma) && strcmpi(sigma{1},'truncate')
    pd = truncate(pd,-inf,sigma{2});
elseif ~isempty(sigma) && strcmpi(sigma{1},'overwrite')
    pd.sigma=sigma{2};
end

IM         = [opt.IM1;opt.IM2(:)];
NIM        = length(IM);
Nscenarios = size(scenarios,1);

% compute event rates
rate = repmat(scenarios(:,end),1,Nsim)'/Nsim;
rate = rate(:);

% writes scenario simulations
Y      = zeros(Nsites*NIM,Nsim*Nscenarios);
uscen  = unique(scenarios(:,1:2),'rows','stable');
if size(L,3)==1
    indL =ones(Nscenarios,1);
else
    [~,indL]=ismember(scenarios(:,1:2),uscen,'rows');
end

Z  = random(pd,[min(Nsites*NIM*Nsim,0.5e6),1]);
nZ = numel(Z);
for i=1:NIM
    IND     = (1:Nsites)+Nsites*(i-1);
    fprintf('Computing shakefield: %g\n',i)
    for j = 1:Nscenarios
        Lptr     = indL(j);
        mulogIM  = permute(mu(j,i,:),[3 1 2]);
        Lj       = L(IND,:,Lptr);
        if nZ==Nsites*NIM*Nsim
            perm     = randperm(nZ,nZ);
        else
            perm     = randi(nZ,Nsites*NIM*Nsim,1);
        end
        Zij      = reshape(Z(perm),Nsites*NIM,Nsim);
        ptr      = (1:Nsim)+Nsim*(j-1);
        Y(IND,ptr) = exp(mulogIM+Lj*Zij);
    end
end

Y = Y';

switch etype
    case 'IS'
        Y = [rate,Y];
    case 'KM'
        
        Nclust  = opt.kmclusters(1);
        Replic  = opt.kmclusters(2);
        stream  = RandStream('mlfg6331_64');  % Random number stream
        options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
        
        [idx,Y] = kmeans(Y,Nclust,'Options',options,'MaxIter',10000,'Display','final','Replicates',Replic);
 
        rateKM    = zeros(Nclust,1);
        for i=1:Nclust
            rateKM(i)=sum(rate(idx==i));
        end
        Y = [rateKM,Y];
        
        1
        
end
