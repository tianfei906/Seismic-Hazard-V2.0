clearvars
clc

%%
BM1=[1	1	0.102214386	0.107774118	0.123758486
1.08984148	1	0.09960468	0.106673933	0.121561427
1.187754451	1	0.097190185	0.105563762	0.119542582
1.294464069	1	0.094943586	0.104456653	0.117678242
1.410760637	1	0.092840842	0.103362678	0.115948643
1.537505461	1	0.090860882	0.102286866	0.114336867
1.675637227	1	0.088985303	0.101227672	0.112827621
1.826178955	1	0.087198068	0.100176375	0.111405937
1.990245575	1	0.085485225	0.099117761	0.110055981
2.169052183	1	0.083834645	0.098032159	0.108760155
2.363923041	1	0.082235778	0.096898541	0.107498771
2.576301386	1	0.080679433	0.095698066	0.106250456
2.807760115	1	0.079157586	0.094417226	0.104993323
3.06001344	1	0.077663212	0.093049937	0.103706649
3.334929576	1	0.07619014	0.091598217	0.102372682
3.634544584	1	0.07473293	0.090071508	0.100978175
3.961077449	1	0.073286778	0.088485042	0.099515367
4.316946509	1	0.071847428	0.086857741	0.097982323
4.704787373	1	0.070411114	0.085210099	0.096382704
5.127472433	1	0.068974507	0.083562287	0.094725096
5.588132145	1	0.067534677	0.081932595	0.093022027
6.090178208	1	0.066089067	0.080336202	0.091288761
6.637328831	1	0.06463547	0.078784333	0.089541937
7.233636277	1	0.06317202	0.077283861	0.087798135
7.883516865	1	0.061697182	0.0758375	0.086072477
8.591783688	1	0.060209747	0.07444462	0.084377429
9.36368225	1	0.05870883	0.073102588	0.082721956
10.20492932	1	0.05719387	0.071808344	0.081111171
11.12175528	1	0.05566463	0.070559831	0.079546554
12.12095023	1	0.054121197	0.069356915	0.078026708
13.20991434	1	0.05256398	0.068201572	0.076548507
14.39671259	1	0.050993706	0.067097356	0.075108388
15.69013456	1	0.049411417	0.066048309	0.07370347
17.09975947	1	0.04781846	0.065057577	0.072332268
18.63602716	1	0.046216477	0.064125994	0.070994872
20.31031543	1	0.044607385	0.063250848	0.069692643
22.13502422	1	0.042993364	0.062424991	0.068427573
24.12366756	1	0.041376828	0.061636408	0.06720149
26.29097355	1	0.0397604	0.060868299	0.066015264
28.65299353	1	0.038146884	0.060099701	0.064868141
31.22722087	1	0.03653923	0.059306606	0.063757262
34.03272061	1	0.0349405	0.058463532	0.062677385
37.0902706	1	0.03335383	0.05754544	0.061620773
40.4225154	1	0.031782395	0.056529849	0.060577196
44.05413401	1	0.030229369	0.055398899	0.059533994
48.01202261	1	0.028697889	0.054141014	0.058476275
52.32549378	1	0.027191021	0.052751835	0.057387325
57.02649358	1	0.025711724	0.051234225	0.056249401
62.14983817	1	0.024262824	0.049597353	0.055044928
67.73347161	1	0.022846983	0.047855091	0.053758029
73.81874694	1	0.021466677	0.046023957	0.052376162
80.45073242	1	0.020124175	0.044120724	0.05089153
87.67854528	1	0.018821525	0.042159671	0.049301984
95.55571555	1	0.017560543	0.040149353	0.047611163
104.1405825	1	0.016342802	0.03808906	0.045827732
113.4967265	1	0.015169633	0.035965591	0.04396369
123.6934404	1	0.014042127	0.03375167	0.042031884
134.8062421	1	0.012961139	0.031407847	0.040043093
146.9174345	1	0.011927298	0.02888968	0.038003285
160.1167142	1	0.010941025	0.02616085	0.035911806
174.5018368	1	0.010002547	0.023210398	0.033761234
190.1793401	1	0.00911192	0.020069203	0.031539453
207.2653334	1	0.00826905	0.016818785	0.029234088
225.8863577	1	0.007473712	0.013586405	0.02683886
246.1803224	1	0.006725574	0.010524851	0.024360567
268.2975269	1	0.006024208	0.007781765	0.021824506
292.4017738	1	0.005369105	0.005468484	0.019275841
318.6715819	1	0.004759677	0.003639083	0.016775266
347.3015085	1	0.004195253	0.002286052	0.014389433
378.50359	1	0.003675068	0.001352027	0.012178988
412.5089127	1	0.003198244	0.00075111	0.010188252
449.5693239	1	0.002763768	0.000391209	0.008439848
489.9592974	1	0.002370467	0.000190721	0.00693525
533.9779658	1	0.002016982	8.69117E-05	0.005659821
581.9513365	1	0.001701748	3.69782E-05	0.004589644
634.2347058	1	0.001422986	1.46749E-05	0.003697652
691.2152905	1	0.0011787	5.42751E-06	0.00295775
753.3150951	1	0.000966691	1.86943E-06	0.002346794
820.9940382	1	0.00078458	5.99289E-07	0.001845048
894.7533576	1	0.000629848	1.78709E-07	0.001435832
975.1393235	1	0.00049988	4.95498E-08	0.001104937
1062.747284	1	0.000392022	1.27687E-08	0.000840083
1158.226072	1	0.000303635	3.05707E-09	0.000630534
1262.282817	1	0.000232153	6.79808E-10	0.000466849
1375.688173	1	0.000175128	1.40369E-10	0.000340744
1499.282035	1	0.00013028	2.69062E-11	0.000245009
1633.979752	1	9.55256E-05	4.78672E-12	0.000173444
1780.778911	1	6.9002E-05	7.90217E-13	0.000120806
1940.766724	1	4.90775E-05	1.21032E-13	8.27359E-05
2115.128078	1	3.43526E-05	1.71964E-14	5.56791E-05
2305.154315	1	2.36523E-05	2.2662E-15	3.67956E-05
2512.252791	1	1.60106E-05	2.76992E-16	2.38625E-05
2737.957299	1	1.06497E-05	3.14007E-17	1.51759E-05
2983.939435	1	6.95759E-06	3.35668E-18	9.45839E-06
3252.02097	1	4.46225E-06	1.03881E-20	5.77307E-06
3544.187347	1	2.80813E-06	NaN	3.44849E-06
3862.602384	1	1.7332E-06	NaN	2.01463E-06
4209.624299	1	1.04869E-06	NaN	1.15032E-06
4587.823176	1	6.2176E-07	NaN	6.41547E-07
5000	1	3.6107E-07	NaN	3.49262E-07];

BU1=[1	1	1.092649287	33.39130028	1.572059366
1.08984148	1	1.031806778	31.58411097	1.494894769
1.187754451	1	0.978423866	29.5832274	1.420835418
1.294464069	1	0.931207607	27.41466881	1.349802022
1.410760637	1	0.887786841	25.11401289	1.2817149
1.537505461	1	0.845565027	22.72475317	1.216494285
1.675637227	1	0.802568921	20.29587221	1.154060408
1.826178955	1	0.758014551	17.87885205	1.094333418
1.990245575	1	0.712429539	15.52442361	1.037233235
2.169052183	1	0.667330092	13.27939493	0.982679434
2.363923041	1	0.624599116	11.18388624	0.930591261
2.576301386	1	0.585800729	9.269241459	0.8808878
2.807760115	1	0.551667755	7.556790563	0.833488285
3.06001344	1	0.521917509	6.057522785	0.788312492
3.334929576	1	0.495423736	4.772616516	0.745281118
3.634544584	1	0.470649863	3.694675881	0.704316087
3.961077449	1	0.446172901	2.809459608	0.665340722
4.316946509	1	0.421116674	2.097861024	0.628279785
4.704787373	1	0.395361807	1.53790761	0.593059427
5.127472433	1	0.369485666	1.106587364	0.559607096
5.588132145	1	0.344478441	0.781366119	0.527851477
6.090178208	1	0.321351853	0.541323101	0.497722496
6.637328831	1	0.300782329	0.367890657	0.469151418
7.233636277	1	0.282904709	0.245230731	0.442071011
7.883516865	1	0.26730901	0.160311487	0.416415738
8.591783688	1	0.253218237	0.102762113	0.392121937
9.36368225	1	0.239767618	0.064584732	0.369127944
10.20492932	1	0.226282012	0.039793238	0.347374136
11.12175528	1	0.212461061	0.024034179	0.326802906
12.12095023	1	0.198421631	0.014228247	0.307358589
13.20991434	1	0.184598736	0.008255441	0.28898737
14.39671259	1	0.171552624	0.00469422	0.271637215
15.69013456	1	0.159756213	0.002615718	0.255257839
17.09975947	1	0.149436129	0.00142822	0.239800715
18.63602716	1	0.140514388	0.000764101	0.225219118
20.31031543	1	0.132658251	0.000400529	0.211468177
22.13502422	1	0.125408659	0.000205695	0.198504902
24.12366756	1	0.118335442	0.00010349	0.186288192
26.29097355	1	0.111165371	5.10081E-05	0.17477879
28.65299353	1	0.103844428	2.4628E-05	0.16393921
31.22722087	1	0.096521382	1.16481E-05	0.153733642
34.03272061	1	0.089466786	5.39629E-06	0.144127855
37.0902706	1	0.082961393	2.44873E-06	0.135089112
40.4225154	1	0.077194578	1.08837E-06	0.126586106
44.05413401	1	0.072205539	4.73794E-07	0.118588914
48.01202261	1	0.067881711	2.02009E-07	0.111068963
52.32549378	1	0.064007806	8.43539E-08	0.103998988
57.02649358	1	0.060342952	3.44974E-08	0.097352978
62.14983817	1	0.056697122	1.38166E-08	0.091106106
67.73347161	1	0.052981982	5.41932E-09	0.085234633
73.81874694	1	0.049222557	2.08164E-09	0.079715801
80.45073242	1	0.04553035	7.83027E-10	0.074527729
87.67854528	1	0.042051007	2.88437E-10	0.069649319
95.55571555	1	0.038906605	1.04042E-10	0.065060188
104.1405825	1	0.036152078	3.67521E-11	0.060740638
113.4967265	1	0.033758302	1.27107E-11	0.056671659
123.6934404	1	0.031623908	4.30634E-12	0.052834975
134.8062421	1	0.02960844	1.42619E-12	0.049213124
146.9174345	1	0.02757389	4.63047E-13	0.045789567
160.1167142	1	0.025421216	1.48175E-13	0.042548826
174.5018368	1	0.023112047	4.63047E-14	0.039476639
190.1793401	1	0.020671622	1.38914E-14	0.036560127
207.2653334	1	0.018174911	4.63047E-15	0.033787952
225.8863577	1	0.015722278	NaN	0.031150456
246.1803224	1	0.013412934	NaN	0.028639771
268.2975269	1	0.011323651	NaN	0.026249856
292.4017738	1	0.009497338	NaN	0.023976469
318.6715819	1	0.007942306	NaN	0.021817044
347.3015085	1	0.006639806	NaN	0.019770477
378.50359	1	0.005555528	NaN	0.017836828
412.5089127	1	0.004650727	NaN	0.016016951
449.5693239	1	0.003890033	NaN	0.014312087
489.9592974	1	0.003245048	NaN	0.012723445
533.9779658	1	0.002694567	NaN	0.011251813
581.9513365	1	0.002223097	NaN	0.009897225
634.2347058	1	0.001819107	NaN	0.008658713
691.2152905	1	0.001473747	NaN	0.00753416
753.3150951	1	0.001180038	NaN	0.006520252
820.9940382	1	0.000932294	NaN	0.005612528
894.7533576	1	0.000725591	NaN	0.004805509
975.1393235	1	0.000555343	NaN	0.004092892
1062.747284	1	0.000417093	NaN	0.003467772
1158.226072	1	0.000306527	NaN	0.00292288
1262.282817	1	0.000219614	NaN	0.002450809
1375.688173	1	0.000152711	NaN	0.00204422
1499.282035	1	0.000102557	NaN	0.001696011
1633.979752	1	6.61889E-05	NaN	0.001399441
1780.778911	1	4.08602E-05	NaN	0.001148228
1940.766724	1	2.40274E-05	NaN	0.000936592
2115.128078	1	1.34114E-05	NaN	0.000759287
2305.154315	1	7.08499E-06	NaN	0.000611593
2512.252791	1	3.53422E-06	NaN	0.000489298
2737.957299	1	1.66163E-06	NaN	0.000388672
2983.939435	1	7.35233E-07	NaN	0.000306428
3252.02097	1	3.05824E-07	NaN	0.000239685
3544.187347	1	1.19475E-07	NaN	0.000185929
3862.602384	1	4.38057E-08	NaN	0.000142982
4209.624299	1	1.50654E-08	NaN	0.000108962
4587.823176	1	4.85758E-09	NaN	8.22545E-05
5000	1	1.46785E-09	NaN	6.14859E-05
];

s       = BM1(:,1);
BM1(:,2)=[];
BU1(:,2)=[];

%% plotting
close all
if 1
    close all
    f=figure;
    ax=subplot(1,2,2);
    hold on
    loglog(s,BM1(:,2)              ,'color',[    0        0.447        0.741])
    loglog(s,BM1(:,3),'--'         ,'color',[    0        0.447        0.741])
    loglog(s,BM1(:,4),'linewidth',2,'color',[    0        0.447        0.741])    
    loglog(s,BU1(:,2),'color',[ 0.85        0.325        0.098])
    loglog(s,BU1(:,4),'color',[ 0.85        0.325        0.098],'linewidth',2)
    set(gca,'xscale','log','yscale','log','xlim',[1 1300],'ylim',[1e-4 1e2],'xtick',[1 10 100 1000],'ytick',10.^[-4:2:2])
    xlabel('Settlement (mm)'); ylabel('MRE')
    
    L=legend('Ds (BM2017)','Dv (BM2017)','LIBS (BM2017)','Ds (B2018)','LIBS (B2018)');
    L.Box='off'; L.Title.String='Settlement Component';L.Location='NorthEast';
    set(gcf,'position',[ 403   421   747   245])
    text(0.23,100,'(d)')
end

%% PSEUDO-PROBABILISTIC APPROACH FOR BRAY AND MACEDO
clc
param =loadsiteLIBS('CPTZ1B3.txt','');
param.Q=param.Q(1);

%                         M     Rrup   CAV      CAVdp   PGA         SA1
% RetPeriod = 475;  data1 = [7.15000	97.10	3.07600	4.52825	0.85398	0.28390];
RetPeriod = 2475; data1 = [7.35000	68.10	5.45161	8.65538	1.42241	0.42204];


M     = data1(:,1);
R     = data1(:,2);
CAV   = data1(:,3)*980.66;
CAVdp = data1(:,4)*980.66;
PGA   = data1(:,5);
SA1   = data1(:,6);

im3   = [CAVdp,PGA,SA1];
D     = zeros (1,14);

% column 1
for i=1:1
    D(i,1) =exp(pseudoProbaBMDs(param,im3(i,:),M(i),'BI14'))*0.5 +...
        exp(pseudoProbaBMDs(param,im3(i,:),M(i),'R15'))*0.5;
end

%column 2
for i=1:1
    D(i,2) = exp(libs_Juang2013Dv(param,PGA(i),M(i)));
end

%column 3
for i=1:1
    D(i,3) = libs_Hutabarat2020De(param,PGA(i),M(i),'BI14');
end

% column 4
for i=1:1
    D(i,4) = exp(pseudoProbaBM(param,im3(i,1),im3(i,2),im3(i,3),M(i),'BI14'))*0.5+...
        exp(pseudoProbaBM(param,im3(i,1),im3(i,2),im3(i,3),M(i),'R15')) *0.5+D(i,3);
end

% column 5
for i=1:1
    D(i,5) = exp(libs_Bullock2018Ds(param,CAV(i)));
end

% column 6
for i=1:1
    D(i,6) = D(i,5)*(exp(libs_Bullock2018Dv(param,CAV(i)))-1);
end

% column 7
for i=1:1
    D(i,7) = exp(libs_Bullock2018(param,CAV(i)));
end

% colum 8
D(1,8)= robustinterp(BM1(:,2),s,1/RetPeriod,'loglog');

% colum 9
D(1,9)= robustinterp(BM1(:,3),s,1/RetPeriod,'loglog');

% column 10
D(:,10)=D(:,3);

% colum 11  Ds + Dv +De
D(1,11)= robustinterp(BM1(:,4),s,1/RetPeriod,'loglog') + D(1,10);

% colum 12
D(1,12)= robustinterp(BU1(:,2),s,1/RetPeriod,'loglog');

% colum 13
D(1,13)= robustinterp(BU1(:,3),s,1/RetPeriod,'loglog');

% colum 14
D(1,14)= robustinterp(BU1(:,4),s,1/RetPeriod,'loglog');
