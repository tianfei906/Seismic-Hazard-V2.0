function [eq]=GMtrimming(eq)

th1 = 0.01;
th2 = 0.01;
th3 = 0.98;

for i=1:numel(eq)
    ACC = sqrt(eq(i).accH1.^2+eq(i).accH2.^2);
    if ~isempty(ACC)
        ACC = ACC/max(ACC);
        AI  = cumsum(ACC.^2)/sum(ACC.^2);
        ini=find(ACC>th1); ini=ini(1)-1;
        IND2=find(ACC>th2); IND2=IND2(end)+1;
        IND3=find(AI >th3); IND3=IND3(1)+1;
        fin=min(IND2,IND3);
        
        time  = eq(i).time;
        time  = time(ini:fin);
        eq(i).time  = time-time(1);
        eq(i).accH1 = eq(i).accH1(ini:fin);
        eq(i).accH2 = eq(i).accH2(ini:fin);
        eq(i).velH1 = eq(i).velH1(ini:fin);
        eq(i).velH2 = eq(i).velH2(ini:fin);
        eq(i).trim  = [ini,fin];
    end
end
