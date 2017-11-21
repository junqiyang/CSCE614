x = {'blackscholes_8c_simlarge',
'bodytrack_8c_simlarge',
'canneal_8c_simlarge',
'dedup_8c_simlarge',
'fluidanimate_8c_simlarge',
'freqmine_8c_simlarge',
'streamcluster_8c_simlarge',
'swaptions_8c_simlarge',
'x264_8c_simlarge'}

SRRIP= [ 
372110636,
403040013,
21198834,
510299519,
1674490718,
526596572,
630218174,
392920187,
414656462,
];
LRU= [ 
372104365,
419292768,
746289594,
494808918,
1669951753,
526065812,
949932326,
392918244,
422661744,
];
LFU= [ 
372110115,
411361551,
727216788,
501228005,
1673704133,
525732562,
774872590,
392918057,
424646226,
];

h = figure;
plot(SRRIP,'-.r*','LineWidth',2);
title('SRRIP performance for multi-threaded benchmark')
legend('SRRIP')
xlabel('Benchmark')
ylabel('Max Cycle')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'SRRIP_performance.png')

g = figure;
plot(LRU,'--mo','LineWidth',2);
title('LRU performance for multi-threaded benchmark')
legend('LRU')
xlabel('Benchmark')
ylabel('Max Cycle')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'LRU_performance.png')

a = figure;
plot(LFU,':bs','LineWidth',2);
title('LFU performance for multi-threaded benchmark')
legend('LFU')
xlabel('Benchmark')
ylabel('Max Cycle')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'LFU_performance.png')

b = figure;
plot(SRRIP,'-.r*','LineWidth',2);hold on
plot(LRU,'--mo','LineWidth',2);
plot(LFU,':bs','LineWidth',2);
title('performance for multi-threaded benchmark')
legend('SRRIP','LRU','LFU')
xlabel('Benchmark')
ylabel('Max Cycle')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'performance.png')
hold off;


y_RRIP = LRU./SRRIP;
y_LFU = LRU./LFU;

geomean(y_RRIP)
geomean(y_LFU)

d =figure;
plot_data = [y_RRIP y_LFU];
bar(plot_data);hold on;
legend('SRRIP','LFU')
title('performance speed up over LRU(multi-threaded)')
xlabel('Benchmark')
ylabel('performance speed up')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
hold off;
saveas(gca,'p_Improvement_multi.png')
