function [mu,sig,tau,phi]=franky(T,varargin)
% Syntax : franky gmm1 gmm2 gmm3 ...                                               

Ndepend  = length(varargin)/3;
ind3     = (1:Ndepend)+Ndepend;
iptrs    = getIMptrs(T,varargin(ind3));
gmpefun  = varargin{iptrs};
ind4     = iptrs+2*Ndepend;
param    = varargin{ind4};
[mu,sig,tau,phi] = gmpefun(T,param{:});

if numel(sig)==1 && numel(mu)>1
    on  = ones(size(mu));
    sig = sig*on;
    tau = tau*on;
    phi = phi*on;
end
    

