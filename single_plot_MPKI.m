x1 = {'bzip2','gcc','mcf','hmmer','sjeng','libquantum','xalan','milc','cactusADM','leslie3d','namd','soplex','calculix','lbm'};
SRRIP1= [ 
2.68086777277,
2.3912721043,
76.8660670069,
1.36743735051,
0.36960364209,
25.0503869767,
2.8596567796,
14.9569490224,
4.74474325598,
23.8764816929,
0.268290698901,
21.0782327037,
0.0587295742106,
30.9731359317,
];

LRU1= [ 
2.74299775935,
2.59701521342,
80.8959193597,
1.41683409173,
0.362183615034,
25.0456996344,
2.80387225701,
14.948523159,
4.84042802052,
23.8411398382,
0.268201310278,
21.7253563012,
0.0587088324059,
30.9418752465,
];

LFU1= [ 
2.67555863007,
2.63278396748,
77.3353893184,
1.34019693734,
0.3621836293,
25.0456224196,
2.79260653563,
14.9487257013,
4.81361427277,
23.833714776,
0.268122764813,
21.6555673808,
0.0587088324059,
30.9417734076,
];

h = figure;
plot(SRRIP1,'-.r*','LineWidth',2);
title('SRRIP MPKI for single-threaded benchmark')
legend('SRRIP')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'SRRIP_MPKI_single.png')

g = figure;
plot(LRU1,'--mo','LineWidth',2);
title('LRU MPKI for single-threaded benchmark')
legend('LRU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'LRU_MPKI_single.png')

a = figure;
plot(LFU1,':bs','LineWidth',2);
title('LFU MPKI for single-threaded benchmark')
legend('LFU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'LFU_MPKI_single.png')

b = figure;
plot(SRRIP1,'-.r*','LineWidth',2);hold on
plot(LRU1,'--mo','LineWidth',2);
plot(LFU1,':bs','LineWidth',2);
title('MPKI for single-threaded benchmark')
legend('SRRIP','LRU','LFU')
xlabel('Benchmark')
ylabel('Miss per Kilo Instruction')
set(gca,'XTick',[1 : 1 : 14])
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
saveas(gca,'MPKI_single.png')
hold off;


y_RRIP1 = (LRU1 - SRRIP1)./LRU1*100;
y_LFU1= (LRU1 - LFU1)./LRU1*100;

mean(y_RRIP1)
mean(y_LFU1)

d =figure;
plot_data1 = [y_RRIP1 y_LFU1];
bar(plot_data1);hold on;
legend('SRRIP','LFU')
title('MPKI improvement(%) over LRU single-threaded')
xlabel('Benchmark')
ylabel('MPKI improvement(%)')
set(gca,'Xticklabel',x1,'XTickLabelRotation',90)
hold off;
saveas(gca,'Improvement_single.png')

%}
