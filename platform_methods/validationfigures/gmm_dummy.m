function [lnIM,sig]=gmm_dummy(To,val)

if To==0
    lnIM=log(val);
elseif To==1
    lnIM=log(0.6*val);
end
sig=1;

