clearvars
clc

%%
BM1=[1	0.0393202846409269	0.0408428603812728	0.0336358038734036	0.0429638470320366
1.08984147998529	0.0385620152869973	0.039728259985771	0.0335285490134326	0.0418806659179303
1.18775445149652	0.0378727700375006	0.0387190692607894	0.0334159723401343	0.0409174366059529
1.29446406927808	0.0372452498255471	0.0378021763071066	0.0332982310099593	0.040061181661504
1.4107606370498	0.0366725319324587	0.0369655264883794	0.0331757332097455	0.0392996940175711
1.53750546058734	0.0361479740367787	0.0361981017168556	0.0330486271187593	0.0386216202983595
1.67563722665196	0.035665126901661	0.0354898928314938	0.0329163725424902	0.0380164834141672
1.82617895501282	0.0352176735658105	0.034831864893937	0.0327774640725633	0.0374746513666716
1.99024557504915	0.0347994133347514	0.0342159156504292	0.0326293627357784	0.0369872665648244
2.16905218304574	0.0344043013567515	0.0336348277915728	0.0324686592043659	0.0365461544562864
2.36392304133588	0.0340265402506794	0.033082215962049	0.0322914379475227	0.0361437325574168
2.57630138594082	0.0336607046212408	0.0325524697105787	0.0320937578040415	0.0357729389476265
2.80776011534188	0.0333018692291741	0.0320406937155443	0.0318721350792543	0.0354271916587211
3.06001343954786	0.0329457116331244	0.0315426466710658	0.0316239245289873	0.0351003793376519
3.3349295757317	0.0325885701129562	0.0310546801772728	0.0313475364147475	0.0347868741517711
3.63454458446214	0.0322274528295063	0.030573678859646	0.0310424833591694	0.0344815544732674
3.96107744900273	0.0318600075358046	0.0300970027637605	0.0307092944266651	0.0341798278216444
4.31694650935748	0.0314844672140856	0.0296224328550302	0.0303493502061871	0.0338776502919189
4.70478737277547	0.0310995844942981	0.0291481202203808	0.0299646820444065	0.033571542595115
5.12747243336171	0.0307045601036951	0.0286725393408258	0.0295577552920127	0.0332586023345966
5.58813214535868	0.0302989640755437	0.0281944455977574	0.0291312398787582	0.0329365081182422
6.09017820765106	0.0298826482469239	0.0277128370036386	0.0286877749420737	0.0326035069858201
6.63732883120057	0.0294556557267836	0.0272269200165537	0.028229756591861	0.0322583761171257
7.23363627654464	0.0290181431822722	0.0267360792094754	0.0277592034216576	0.0319003544954465
7.88351686530467	0.0285703373171903	0.0262398505164235	0.0272777606308583	0.0315290486652454
8.59178368797261	0.0281125415478474	0.0257378977629741	0.0267868751668865	0.0311443256533356
9.36368225021351	0.0276451925615569	0.0252299921998141	0.0262881148469999	0.0307462127944393
10.2049293216846	0.0271689464503198	0.0247159947864857	0.0257835390719779	0.0303348272947049
11.12175527509	0.0266847608246347	0.0241958410096235	0.0252759920565994	0.0299103563495189
12.1209502290383	0.0261939393317305	0.023669528058481	0.0247692046571183	0.0294730986717156
13.2099143364431	0.025698117145888	0.0231371042145664	0.0242676535989379	0.029023559161739
14.396712590908	0.0251991832606178	0.0225986603377636	0.0237762067811174	0.028562565575513
15.690134556998	0.0246991505027078	0.0220543233461694	0.0232996428280145	0.0280913616114364
17.099759466767	0.0241999934807237	0.0215042515902892	0.0228421504428755	0.02761163555092
18.6360271646537	0.0237034780632756	0.0209486320146979	0.0224068924470748	0.0271254665101549
20.3103154261722	0.0232110045729212	0.0203876789831109	0.0219956821064182	0.0266351978422242
22.1350242230275	0.0227234818541422	0.0198216346180022	0.0216087871617997	0.0261432635444599
24.1236675587345	0.0222412426069506	0.019250770475873	0.0212448604963883	0.0256519933553798
26.2909735548842	0.0217640049225409	0.0186753903467952	0.0209009953296942	0.0251634130481878
28.6529935293091	0.0212908835087389	0.0180958339350006	0.0205729118495423	0.0246790497733773
31.227220873991	0.0208204562104301	0.0175124811491988	0.0202552928302613	0.0241997538335905
34.0327206131378	0.0203508923477352	0.0169257567100146	0.0199422840048045	0.0237255560236185
37.0902706009479	0.0198801426423846	0.0163361347699904	0.0196281427470251	0.0232555895610219
40.4225154047918	0.0194061734127512	0.0157441432408675	0.019307947422448	0.0227881156509119
44.0541340134863	0.018927205683715	0.0151503675343878	0.0189781899128789	0.0223206987745945
48.0120226127281	0.0184419050646091	0.0145554534469324	0.0186370202397146	0.0218505711147773
52.3254937813426	0.0179494724288551	0.0139601089547089	0.0182839592260166	0.0213751874418935
57.0264935836193	0.0174496111335939	0.0133651047343514	0.0179190668383104	0.0208928923176531
62.1498381655432	0.0169423832541874	0.0127712732829371	0.0175417946307067	0.0204035195742326
67.7334716071816	0.0164279962983201	0.0121795065803984	0.0171499353199519	0.0199086749160345
73.8187469409122	0.0159065678184603	0.0115907523142223	0.0167390836600527	0.0194114833901368
80.4507324167431	0.0153778976496445	0.0110060087680944	0.0163027977656639	0.0189157435908533
87.6785452829636	0.0148412509144139	0.0104263185581109	0.015833286316997	0.0184246704018889
95.555715554142	0.0142951378388913	0.00985276147603292	0.0153221321349107	0.0179396096529814
104.140582460579	0.0137370791366328	0.00928644676098428	0.0147604944722581	0.0174591517816357
113.496726515367	0.0131633717568292	0.00872850516014754	0.014138519226184	0.0169789182372709
123.693440398993	0.0125689218248788	0.00818008114613076	0.0134442756741917	0.0164920178778565
134.806242148911	0.0119472816945121	0.00764232562497013	0.0126631938123716	0.0159899153676918
146.917434454824	0.0112910775923208	0.00711638938708212	0.011779319370991	0.0154633488837853
160.116714201886	0.0105929816888459	0.00660341742021622	0.0107793536990841	0.0149030256418645
174.501836776165	0.0098472344367139	0.0061045440207235	0.00965926454933665	0.0143000555879842
190.179340052286	0.00905150224558555	0.00562088841787689	0.00843158836627815	0.0136463306101185
207.265333425209	0.00820866103772589	0.00515355038697443	0.00713024833797373	0.0129351783025233
225.886357729774	0.00732801322781606	0.00470360510353848	0.00580976287841248	0.0121625227701447
246.180322416702	0.00642550326210259	0.00427209632586239	0.00453754148385043	0.0113284798695883
268.297526925874	0.00552268395195736	0.00386002693372807	0.00338092419486496	0.0104389339535555
292.401773821287	0.00464447448353718	0.00346834594049155	0.00239319443749146	0.00950640162136848
318.671581931714	0.00381608386793805	0.00309793136221099	0.00160347515207808	0.008549569712265
347.301508481712	0.0030597462325371	0.00274956877383889	0.00101374752791012	0.0075913274570273
378.503590004831	0.00239200505062275	0.00242392597832917	0.000603154025708048	0.00665571232848478
412.508912710609	0.00182212813989403	0.00212152489448329	0.000336965115693332	0.00576464385810785
449.569323935652	0.00135188535175865	0.00184271243910107	0.000176433511835339	0.00493538084433917
489.959297354015	0.000976526376650617	0.00158763272876827	8.64424723718297e-05	0.00417928538934497
533.977965760852	0.000686519606547375	0.00135620325074881	3.95769024268306e-05	0.00350192972296884
581.951336484339	0.000469537602716277	0.00114809767071826	1.69134900335483e-05	0.00290413562907863
634.234705833507	0.000312273051543598	0.000962737620960686	6.7403770959478e-06	0.0023833738228996
691.215290463622	0.00020184664227058	0.000799295163970867	2.50287497570787e-06	0.00193505835799909
753.315095147334	0.000126734443976032	0.000656706725196091	8.65354205226873e-07	0.00155350490999426
820.994038190627	7.72527838896469e-05	0.000533698249880497	2.78411400059063e-07	0.00123253213722608
894.753357640769	4.56925184916775e-05	0.000428820300445202	8.33091695109323e-08	0.000965798739517821
975.139323513021	2.62097173960358e-05	0.000340490908883386	2.31747809764668e-08	0.000746990323950524
1062.74728352928	1.45731064957778e-05	0.000267043345080253	5.99080493016115e-09	0.000569941318815766
1158.2260723319	7.85076376571049e-06	0.000206775627110294	1.43864125270823e-09	0.000428736917700054
1262.28281682774	4.09589257950218e-06	0.000157998604371241	3.20838826724184e-10	0.000317809055509796
1375.68817325154	2.06859859421074e-06	0.000119079762159738	6.64313738152823e-11	0.000232023604194771
1499.28203473471	1.01091327491073e-06	8.84804621507013e-05	1.27676094479162e-11	0.000166750452091584
1633.97975165063	4.7784083302046e-07	6.47850586282177e-05	2.27722314517022e-12	0.000117909232676599
1780.77891080491	2.18377021604927e-07	4.67211185430733e-05	3.76860616235406e-13	8.19873514385959e-05
1940.76672367821	9.64511360036346e-08	3.31707337850205e-05	5.78579806132094e-14	5.60311588820651e-05
2115.12807843966	4.11534001772883e-08	2.31735721959839e-05	8.23925497197974e-15	3.76143544145261e-05
2305.15431536511	1.69559511356986e-08	1.5922818391753e-05	1.08816784824976e-15	2.47895428066497e-05
2512.25279065198	6.74329620974283e-09	1.07554800787655e-05	1.33266774034062e-16	1.60293838532455e-05
2737.95729946133	2.58737698963695e-09	7.13867783600621e-06	1.51309979851943e-17	1.01633120803584e-05
2983.93943538145	9.61212550306316e-10	4.65351401250836e-06	1.61364725654418e-18	6.31475287283609e-06
3252.02097044258	1.51363252220854e-10	2.97796189370827e-06	1.03118220234415e-20	3.84246762995749e-06
3544.18734737033	0	1.86997046061453e-06	NaN	2.28836955733657e-06
3862.6023840032	0	1.15168590362557e-06	NaN	1.33301278116701e-06
4209.62429877675	0	6.95388197870123e-07	NaN	7.59044138091991e-07
4587.82317596087	0	4.11461626058309e-07	NaN	4.22240826993748e-07
5000	0	2.38484341167328e-07	NaN	2.29326674199916e-07];

BU1=[1	1	0.433601027481048	14.2369612781117	0.620235168811026
1.08984147998529	1	0.410080876753397	13.4664347032304	0.590144041736899
1.18775445149652	1	0.389450644655676	12.6133232131701	0.561298677058188
1.29446406927808	1	0.371210034857942	11.6887205681386	0.533662743719674
1.4107606370498	1	0.354442266856813	10.7077959245224	0.507200177065698
1.53750546058734	1	0.338143510327773	9.68909351123525	0.481875276925197
1.67563722665196	1	0.321550583258086	8.65349789902909	0.457652724816712
1.82617895501282	1	0.304359389227135	7.62295934036978	0.434497538007519
1.99024557504915	1	0.286772018032478	6.61910785072941	0.412374996255434
2.16905218304574	1	0.26937190507541	5.66190085027687	0.391250582172743
2.36392304133588	1	0.252883632995675	4.76844429553503	0.371089967777681
2.57630138594082	1	0.237908246754973	3.95210221309067	0.351859061794248
2.80776011534188	1	0.224725489725586	3.22196900793293	0.333524111219606
3.06001343954786	1	0.21322296807313	2.58273013076177	0.316051833574367
3.3349295757317	1	0.202963003636025	2.0348880088866	0.299409548167545
3.63454458446214	1	0.19335050437698	1.57528928234991	0.283565277375884
3.96107744900273	1	0.183835816338098	1.1978619377921	0.268487800489073
4.31694650935748	1	0.174082351798311	0.894459512240943	0.254146658577039
4.70478737277547	1	0.164047572839944	0.655713641103854	0.240512123605018
5.12747243336171	1	0.153959106930063	0.47181275715454	0.227555154065956
5.58813214535868	1	0.144203888821864	0.333149026455188	0.215247360413119
6.09017820765106	1	0.135175613718391	0.230802513324492	0.203560997056707
6.63732883120057	1	0.127135754705127	0.156856576077696	0.192468986499938
7.23363627654464	1	0.120133458682606	0.10455838477497	0.181944969403384
7.88351686530467	1	0.114004891109739	0.0683515889138044	0.171963365826081
8.59178368797261	1	0.108443490956632	0.0438144129604568	0.162499430001358
9.36368225021351	1	0.10310996955144	0.0275368228906786	0.153529284098719
10.2049293216846	1	0.0977414924407675	0.0169665385766793	0.145029923872064
11.12175527509	1	0.092224368339877	0.0102473899546969	0.136979198039051
12.1209502290383	1	0.0866102190504115	0.0060664606225242	0.129355770638374
13.2099143364431	1	0.0810760249639493	0.00351985091014193	0.122139079256994
14.396712590908	1	0.0758469191502384	0.00200146235179034	0.115309301146553
15.690134556998	1	0.0711112915752925	0.00111525692858746	0.108847334639671
17.099759466767	1	0.066957481548898	0.000608946567169557	0.102734796838283
18.6360271646537	1	0.0633509507225651	0.000325787718134342	0.0969540325657136
20.3103154261722	1	0.060155011717123	0.000170772493797775	0.0914881259370876
22.1350242230275	1	0.0571832289804477	8.77014937531564e-05	0.0863209055213149
24.1236675587345	1	0.054262577258807	4.41246898935402e-05	0.0814369366917917
26.2909735548842	1	0.0512854300261215	2.17481910067307e-05	0.0768214991878618
28.6529935293091	1	0.0482345671668097	1.05005951510088e-05	0.0724605524758505
31.227220873991	1	0.0451758255941029	4.96635435654187e-06	0.0683406946856432
34.0327206131378	1	0.0422241458804448	2.30080237371587e-06	0.0644491218060031
37.0902706009479	1	0.0394970434436969	1.04405787251784e-06	0.0607735923974604
40.4225154047918	1	0.0370723945547112	4.64045125910944e-07	0.0573024000483393
44.0541340134863	1	0.0349642344336442	2.0201045083075e-07	0.0540243523354575
48.0120226127281	1	0.0331226541844784	8.61298762858354e-08	0.0509287523579555
52.3254937813426	1	0.0314550560993098	3.59657618548306e-08	0.0480053778246372
57.0264935836193	1	0.0298592505746631	1.47085508171395e-08	0.0452444534311243
62.1498381655432	1	0.0282561446677032	5.89096129937821e-09	0.0426366144984968
67.7334716071816	1	0.0266113395531909	2.31062221210339e-09	0.0401728627794758
73.8187469409122	1	0.0249397147466077	8.87543009582952e-10	0.0378445180732831
80.4507324167431	1	0.023293203912945	3.33857230196965e-10	0.0356431711071107
87.6785452829636	1	0.0217374510055289	1.22980081525456e-10	0.0335606436982647
95.555715554142	1	0.020326159118079	4.43601716427006e-11	0.0315889615853881
104.140582460579	1	0.0190818099655426	1.56698866139176e-11	0.0297203439058108
113.496726515367	1	0.0179883535123118	5.41940767987954e-12	0.0279472116148409
123.693440398993	1	0.0169968666545939	1.83608347624334e-12	0.0262622156169837
134.806242148911	1	0.0160409064719234	6.08079258798869e-13	0.0246582841976427
146.917434454824	1	0.0150557549774702	1.97428330778854e-13	0.0231286884251342
160.116714201886	1	0.0139954543614614	6.31770658492332e-14	0.0216671232649277
174.501836776165	1	0.0128430875342275	1.97428330778854e-14	0.020267800906343
190.179340052286	1	0.0116123378775092	5.92284992336561e-15	0.0189255510809884
207.265333425209	1	0.0103410718387016	1.97428330778854e-15	0.0176359210464263
225.886357729774	1	0.00907978844122266	NaN	0.0163952657974533
246.180322416702	1	0.00787878666751516	NaN	0.015200817534115
268.297526925874	1	0.00677766443184607	NaN	0.0140507230837109
292.401773821287	1	0.00579949932258332	NaN	0.0129440393138782
318.671581931714	1	0.00495028501842134	NaN	0.0118806797383764
347.301508481712	1	0.00422253742478586	NaN	0.0108613102577906
378.503590004831	1	0.00360096999872683	NaN	0.00988719766474501
412.508912710609	1	0.00306802267820225	NaN	0.00896002028828645
449.569323935652	1	0.00260771098686645	NaN	0.0080816549941286
489.959297354015	1	0.00220733136076317	NaN	0.0072539578697728
533.977965760852	1	0.00185748983622318	NaN	0.00647855678563706
581.951336484339	1	0.00155133758220392	NaN	0.00575667251965611
634.234705833507	1	0.001283756500453	NaN	0.00508898155973788
691.215290463622	1	0.00105080746813534	NaN	0.00447552868489043
753.315095147334	1	0.000849386293777178	NaN	0.00391569179253629
820.994038190627	1	0.00067692453275074	NaN	0.0034081960337825
894.753357640769	1	0.000531076365179429	NaN	0.002951169861703
975.139323513021	1	0.000409465199183844	NaN	0.002542232576347
1062.74728352928	1	0.000309585366815135	NaN	0.00217860156507305
1158.2260723319	1	0.000228866565927796	NaN	0.00185720761306009
1262.28281682774	1	0.000164810810656237	NaN	0.00157480810380089
1375.68817325154	1	0.000115090550506677	NaN	0.00132809021894936
1499.28203473471	1	7.75570276753945e-05	NaN	0.00111375891851175
1633.97975165063	1	5.01884633065669e-05	NaN	0.000928607115827948
1780.77891080491	1	3.10457939321341e-05	NaN	0.000769567735489064
1940.76672367821	1	1.82837550911617e-05	NaN	0.000633749060296266
2115.12807843966	1	1.02166706355016e-05	NaN	0.000518455864916542
2305.15431536511	1	5.40155445948509e-06	NaN	0.000421199332892913
2512.25279065198	1	2.6959783929474e-06	NaN	0.000339698766109935
2737.95729946133	1	1.26802215076611e-06	NaN	0.000271877764543139
2983.93943538145	1	5.61226228258914e-07	NaN	0.000215857027503165
3252.02097044258	1	2.3348914525683e-07	NaN	0.000169945336286654
3544.18734737033	1	9.12284396430219e-08	NaN	0.00013262972149037
3862.6023840032	1	3.34520743867719e-08	NaN	0.000102565359462898
4209.62429877675	1	1.15053247753159e-08	NaN	7.8565410760514e-05
4587.82317596087	1	3.70985662473518e-09	NaN	5.95908109189714e-05
5000	1	1.12106923343117e-09	NaN	4.47399332659633e-05];

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
    set(gca,'xscale','log','yscale','log','xlim',[1 1300],'ylim',[1e-4 1e0],'xtick',[1 10 100 1000],'ytick',10.^[-4:1:0])
    xlabel('Settlement (mm)'); ylabel('MRE')
    
    L=legend('Ds (BM2017)','Dv (BM2017)','LIBS (BM2017)','Ds (B2018)','LIBS (B2018)');
    L.Box='off'; L.Title.String='Settlement Component';L.Location='NorthEast';
    set(gcf,'position',[ 403   421   747   245])
    text(0.23,1,'(d)')
end

%% PSEUDO-PROBABILISTIC APPROACH FOR BRAY AND MACEDO
clc
param =loadsiteLIBS('CPTZ1B3.txt','');
param.Q=param.Q(1);

%                         M     Rrup   CAV      CAVdp   PGA         SA1
RetPeriod = 475;  data1 = [8.05000	65.00	2.69322	3.91904	0.53975	0.33272];
% RetPeriod = 2475; data1 = [8.25000	65.00	5.13786	8.06458	1.02785	0.45872];

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
