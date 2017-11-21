

x1 = {'bzip2','gcc','mcf','hmmer','sjeng','libquantum','xalan','milc','cactusADM','leslie3d','namd','soplex','calculix','lbm'};
SRRIP1= [ 
98393680.0,
121659502.0,
771793261.0,
66694374.0,
82698857.0,
194613437.0,
70379735.0,
152465076.0,
93643018.0,
216049700.0,
53332622.0,
230920169.0,
49427634.0,
174104334.0,
];
LRU1= [ 
98572418.0,
124936377.0,
799250636.0,
67233594.0,
82597427.0,
195614552.0,
69400569.0,
152339806.0,
94579485.0,
215501708.0,
53321607.0,
233220891.0,
49498006.0,
173755432.0,
];
LFU1= [ 
97895595.0,
125889667.0,
774333988.0,
66225170.0,
82589642.0,
195593128.0,
69279027.0,
152349318.0,
94123918.0,
215525648.0,
53333361.0,
230256172.0,
49497623.0,
173755274.0,
];


h = figure;
plot(SRRIP1,'-.r*','LineWidth',2);
title('SRRIP performance for single-threaded benchmark')
legend('SRRIP')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'SRRIP_performance_single.png')

g = figure;
plot(LRU1,'--mo','LineWidth',2);
title('LRU performance for single-threaded benchmark')
legend('LRU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'LRU_performance_single.png')

a = figure;
plot(LFU1,':bs','LineWidth',2);
title('LFU performance for single-threaded benchmark')
legend('LFU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'LFU_performance_single.png')

b = figure;
plot(SRRIP1,'-.r*','LineWidth',2);hold on
plot(LRU1,'--mo','LineWidth',2);
plot(LFU1,':bs','LineWidth',2);
title('performance for single-threaded benchmark')
legend('SRRIP','LRU','LFU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'performance_single.png')
hold off;


y_RRIP1 = LRU1 ./ SRRIP1;
y_LFU1= LRU1 ./ LFU1;

geomean(y_RRIP1)
geomean(y_LFU1)

d =figure;
plot_data1 = [y_RRIP1 y_LFU1];
bar(plot_data1);hold on;
legend('SRRIP','LFU')
title('performance improvement(%) over LRU single-threaded')
xlabel('Benchmark')
ylabel('performance improvement(%)')
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
hold off;
saveas(gca,'p_Improvement_single.png')
