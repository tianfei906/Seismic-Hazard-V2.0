function handles=run_funcMRe(handles,dg3)

Rbin = handles.Rbin;
Mbin = handles.Mbin;
Ebin = handles.Ebin;
Ebin = Ebin+1e-7;
NR   = size(handles.Rbin,1);
NM   = size(handles.Mbin,1);
NE   = size(handles.Ebin,1);

deagg3 = zeros(NR,NE,NM);

for j=1:NM
    deagg3(:,:,j) = deagghazardMRe3(dg3,Mbin(j,:),Rbin,Ebin);
end
deagg3 = deagg3/sum(deagg3(:))*100;
updateZValue(handles.b,deagg3);
Zmax = sum(deagg3,2,'omitnan');
Zmax = max(Zmax(:));
handles.ax1.ZLim=[0,min(ceil(Zmax),100)];
xtickangle(handles.ax1,0)
ytickangle(handles.ax1,0)
ztickangle(handles.ax1,0)

function[deaggIM]=deagghazardMRe3(deagg,Mbin,Rbin,Ebin)

NR = size(Rbin,1); 
NE = size(Ebin,1);
deaggIM = zeros(NR,NE);

M  = deagg(:,1);
R  = deagg(:,2);
e  = deagg(:,4);
dg = deagg(:,5);
M1 = Mbin(1);
M2 = Mbin(2);

IND=isinf(e);
e(IND)=1000*sign(e(IND));

for i=1:NR
    R1 = Rbin(i,1);
    R2 = Rbin(i,2);
    for j=1:NE
        ind1 = and(R1<R,R<=R2);
        ind2 = and(M1<M,M<=M2);
        ind3 = and(e>Ebin(j,1),e<=Ebin(j,2));
        deaggIM(i,j) = sum(dg(ind1&ind2&ind3));
    end
end


