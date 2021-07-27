function[Data]=sh_fillP3Table(handles,val)
source  = handles.sys.source{val};
Nsource = numel(source);
Data    = cell(Nsource,7);
Data(:,2)=handles.sys.labelG{val};
for i=1:Nsource
    switch round(source{i}.sourcetype)
        case 1, Data{i,1}='point1';
        case 2, Data{i,1}='line1';
        case 3, Data{i,1}='area1';
        case 4, Data{i,1}='area2';
        case 5, Data{i,1}='volume1';
    end
    
    num = source{i}.num;
    
    switch num(1)
        case 1, Data{i,3}='Interface';
        case 2, Data{i,3}='Intraslab';
        case 3, Data{i,3}='Crustal';
        case 8, Data{i,3}='Background';
    end
    Data{i,4}=num(2);
    
    switch num(3)
        case 1, Data{i,5}='null';
        case 2, Data{i,5}='wc1994';
        case 3, Data{i,5}='ellsworth';
        case 4, Data{i,5}='hanksbakun2001';
        case 5, Data{i,5}='somerville1999';
        case 6, Data{i,5}='wellscoppersmithr1994';
        case 7, Data{i,5}='wellscoppersmithss1994';
        case 8, Data{i,5}='strasser2010';
    end
    Data{i,6}=num(4);
    Data{i,7}=num(5);
    
end