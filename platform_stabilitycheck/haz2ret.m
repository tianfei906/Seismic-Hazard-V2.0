function data=haz2ret(data)

header = data(1,:);
data(1,:)=[];

data = cell2mat(data);
IM     = data(:,1);
lambda = data(:,2:end);

Tr   = [50;100;250;475;949;2475;5000;10000;20000];
NT   = length(Tr);
Ncol = size(lambda,2);
IMD  = nan(NT,Ncol);

for i=1:NT
    for j=1:Ncol
        if numel(unique(lambda(:,j)))>3
            IMD(i,j)=robustinterp(lambda(:,j),IM,1/Tr(i),'loglog');
        end
    end
end

data=[{'Tr',header{2:end}};num2cell([Tr,IMD])];