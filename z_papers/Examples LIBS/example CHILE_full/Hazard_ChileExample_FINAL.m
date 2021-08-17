clearvars

PGA=[1e-05	13.46853517352
1.56017919563028e-05	13.4683820002239
2.43415912247756e-05	13.4672935021273
3.79772442174316e-05	13.4614852562906
5.92513063354073e-05	13.437914334402
9.24426554584194e-05	13.3637543474998
0.000144227107835044	13.178253084394
0.000225020133090161	12.7985579575477
0.000351071730245228	12.1442874965114
0.000547734809702532	11.1723631435882
0.000854564454820402	9.9045507545143
0.00133327368373593	8.42875677005375
0.00208014586344615	6.87059401434408
0.00324540030002507	5.3556733732517
0.0050634060295914	3.9850648738972
0.00789982074639744	2.82543622517259
0.0123251359777378	1.90515337567598
0.0192294207357808	1.21855054487035
0.0300013421759868	0.736702143006759
0.0468074699039601	0.419495930359694
0.0730280407442491	0.224296807003625
0.113936829866818	0.112293632597767
0.177761871574277	0.0523052165425125
0.277340373806489	0.0223324434034301
0.432700681321211	0.00847792148055009
0.675090600932403	0.00275185433558242
1.05326231074028	0.000720597742553398
1.64327794475847	0.000138087248460059
2.56380806205025	1.25680619860938e-05
4	1.3013785539835e-07];

SA1=[1e-05	13.4630707923361
1.56017919563028e-05	13.4471666993616
2.43415912247756e-05	13.4013153688769
3.79772442174316e-05	13.2913651465188
5.92513063354073e-05	13.0634796422426
9.24426554584194e-05	12.6470983984979
0.000144227107835044	11.9741549587401
0.000225020133090161	11.0112352417356
0.000351071730245228	9.78178000377696
0.000547734809702532	8.36185199945101
0.000854564454820402	6.85781300678856
0.00133327368373593	5.38262399102034
0.00208014586344615	4.03584447642579
0.00324540030002507	2.88720958001849
0.0050634060295914	1.96951230796441
0.00789982074639744	1.28139371492596
0.0123251359777378	0.796422157545159
0.0192294207357808	0.474873280810921
0.0300013421759868	0.273087816643528
0.0468074699039601	0.152311794915009
0.0730280407442491	0.0824948374476762
0.113936829866818	0.0432734368424664
0.177761871574277	0.0217617323838207
0.277340373806489	0.0102727211071177
0.432700681321211	0.00440564085283451
0.675090600932403	0.00163680219551609
1.05326231074028	0.000497285452239187
1.64327794475847	0.000113299036755383
2.56380806205025	1.50908113276515e-05
4	0];

CAVdp=[0.01	13.468523868479
0.0158214613571711	13.4682593245343
0.0250318639476458	13.4663966127434
0.0396040668145641	13.4568714826922
0.0626594212693448	13.4205779646208
0.0991363612275642	13.314480989878
0.156848210825246	13.0693727970247
0.248156790651305	12.6093911968293
0.392620307380922	11.8895333549439
0.621182702126789	10.9223164803114
0.98280181174421	9.76736902233234
1.55493608862687	8.49743405193646
2.46013612390808	7.17653678709433
3.89229486177924	5.86241925652799
6.15817927463558	4.61383287467975
9.74313954241786	3.48731718361952
15.415070576789	2.52567365107447
24.3888943448732	1.74932448451346
38.5867949421539	1.15657062584593
61.0499485074372	0.729438489116185
96.5899401167702	0.439994266101859
152.819400504895	0.255540926219118
241.782623971424	0.144259963914544
382.535444199932	0.0798926259549891
605.226974815749	0.0436063727177779
957.557519436493	0.0234726201919733
1514.99592910331	0.0123261025981385
2396.94495485795	0.00613306313543421
3792.31719785512	0.00275338245198069
6000	0.0010460722611238];

CAV=[0.01	13.4685525907679
0.0158214613571711	13.4685525907678
0.0250318639476458	13.4685525907496
0.0396040668145641	13.4685525887386
0.0626594212693448	13.4685524610561
0.0991363612275642	13.4685477667126
0.156848210825246	13.4684465021869
0.248156790651305	13.4671354007323
0.392620307380922	13.4565991165972
0.621182702126789	13.4016280499401
0.98280181174421	13.2052764153371
1.55493608862687	12.6990510299603
2.46013612390808	11.713844423561
3.89229486177924	10.2099027941527
6.15817927463558	8.33626590504961
9.74313954241786	6.35308921961138
15.415070576789	4.51411294157184
24.3888943448732	2.9942331903286
38.5867949421539	1.86082978685892
61.0499485074372	1.09038167012336
96.5899401167702	0.608046846767799
152.819400504895	0.326346960116519
241.782623971424	0.169934268670909
382.535444199932	0.0860327095126987
605.226974815749	0.0422318162805193
957.557519436493	0.0199362658325459
1514.99592910331	0.00885605044697866
2396.94495485795	0.00350121535037606
3792.31719785512	0.00112074670267511
6000	0.00025812548759524];


ax(1)=subplot(1,2,1);
hold on
plot(PGA(:,1),PGA(:,2))
plot(SA1(:,1),SA1(:,2))
set(gca,'xscale','log','yscale','log','xtick',10.^[-3:1:0],'xlim',[1e-3 6],'ylim',[1e-4 1e2],'fontsize',9,'ytick',10.^(-4:2:2),'XMinorTick','off','YMinorTick','off')
L=legend('PGA','SA1');L.Box='off';
L.Title.String='Montalva et al. 2017';
xlabel('PGA,SA1 (g)')
ylabel('MRE')
text(2e-4,100,'(a)')

ax(2)=subplot(1,2,2);
hold on
plot(CAVdp(:,1)/980.66,CAVdp(:,2)); %CAVdp 270 m/s
plot(CAV  (:,1)/980.66,CAV  (:,2)); %CAV   760 m/s
set(gca,'xscale','log','yscale','log','xtick',10.^[-3:1:0],'xlim',[1e-3 6],'ylim',[1e-4 1e2],'fontsize',9,'ytick',10.^(-4:2:2),'XMinorTick','off','YMinorTick','off')
L=legend('CAV','CAVdp');L.Box='off';
L.Title.String='Macedo et al. 2020';
xlabel('CAVdp,CAV (g\cdots)')
ylabel('MRE')
text(2e-4,100,'(b)')

set(gcf,'position',[ 403   421   747   245])