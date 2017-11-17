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
0.00724468959742,
0.0317853761929,
12.6785976447,
1.2924959853,
1.06935411708,
0.880914746843,
1.97167312981,
0.00224358090533,
0.750168944564,
];

LRU= [ 
0.00724493575163,
0.036070875528,
13.2370473742,
1.15239142879,
1.05971599558,
0.897247165633,
6.58243412873,
0.00224377615719,
0.80316685691,
];

LFU= [ 
0.00724493575163,
0.0361034597924,
11.8531237466,
1.23721296128,
1.06183413128,
0.877432094494,
3.75453075342,
0.00224377397985,
0.866878562773,
];

h = figure;
plot(SRRIP,'-.r*','LineWidth',2);
title('SRRIP MPKI for multi-threaded benchmark')
legend('SRRIP')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'SRRIP_MPKI.png')

g = figure;
plot(LRU,'--mo','LineWidth',2);
title('LRU MPKI for multi-threaded benchmark')
legend('LRU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'LRU_MPKI.png')

a = figure;
plot(LFU,':bs','LineWidth',2);
title('LFU MPKI for multi-threaded benchmark')
legend('LFU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'LFU_MPKI.png')

b = figure;
plot(SRRIP,'-.r*','LineWidth',2);hold on
plot(LRU,'--mo','LineWidth',2);
plot(LFU,':bs','LineWidth',2);
title('MPKI for multi-threaded benchmark')
legend('SRRIP','LRU','LFU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
saveas(gca,'MPKI.png')
hold off;


y_RRIP = (LRU - SRRIP)./LRU*100;
y_LFU = (LRU - LFU)./LRU*100;

mean(y_RRIP)
mean(y_LFU)

d =figure;
plot_data = [y_RRIP y_LFU];
bar(plot_data);hold on;
legend('SRRIP','LFU')
title('MPKI improvement(%) over LRU(multi-threaded)')
xlabel('Benchmark')
ylabel('MPKI improvement(%)')
set(gca,'Xticklabel',x,'XTickLabelRotation',90)
hold off;
saveas(gca,'Improvement_multi.png')
