function [mu,sig,tau,phi]=adj(IM,varargin)
% Syntax : franky gmm1 gmm2 gmm3 ...                                               

adjfun  = str2func(varargin{end-1});
gmmfun  = str2func(varargin{end-0});
param   = varargin(1:end-2);
[mu,sig,tau,phi] = gmmfun(IM,param{:});

SF = adjfun(IM); 
mu = mu+log(SF);
