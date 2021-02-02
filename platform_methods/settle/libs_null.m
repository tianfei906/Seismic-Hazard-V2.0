function [varargout] = libs_null(~,im,varargin)

lnLIBS = nan(size(im));
sig    = 1;

if nargin<=3
    varargout{1} = lnLIBS;
    varargout{2} = nan;
    return
end

y    = varargin{1};
dist = varargin{2};
if strcmp(dist,'pdf')
    varargout{1} = lognpdf(y,lnLIBS,sig);
elseif strcmp(dist,'cdf')
    varargout{1} = logncdf(y,lnLIBS,sig);
elseif strcmp(dist,'ccdf')
    varargout{1} = 1-logncdf(y,lnLIBS,sig);
end