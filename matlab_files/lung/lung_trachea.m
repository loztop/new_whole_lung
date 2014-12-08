%clear all;
%close all;

tec='.tec';

prefix='5036_H_80NT_8T';

%x_axis_str='Percentage of original Young''s modulus';
x_axis_str='Percentage of original airway constriction';

%numerical solution

%work
base='/auto/users/lorenzb/mount_point/data/';
out_base='/users/lorenzb/Dphil/poroelasticity_papers/coupling_paper/figures/lung_sims/';

%home
base='/home/loztop/mount_point/mount_point/data/';
out_base='/home/loztop/Dropbox/Dphil/poroelasticity_papers/coupling_paper/figures/lung_sims/';

Nodes=5036; %for 246 mesh



NT=[1:1:80];

for i=1:length(NT)
i
%Load time step data    
fnameC=strcat(base,prefix,'__',num2str(NT(i)),tec)

importfile(fnameC);

header_info=textdata{3};
TEMP=data;
clear data;
data=TEMP(1:Nodes,:);

%This might change depending on what order vraibles are stored

t=size(data,1);

%reference positions
x=data(:,20);
y=data(:,21);
z=data(:,22);


%Pressure
s_p(i,:)=data(:,7)';

%%Jacobian
J(i,:)=data(:,31)';

%%Stress
sig(i,:)=data(:,33)';

i
end

mean_s_p=mean(s_p');
std_s_p=std(s_p');

mean_J=mean(J');
std_J=std(J');

mean_sig=mean(sig');
std_sig=std(sig');

dt=0.1;
t=NT.*dt;

t=[0,t];

FRC=1.6757;

%%calculate volume
Vol=(mean_J-1).*FRC;

%%calculate flow rate

Frate=(Vol(1:end)-[0,Vol(1:end-1)])./dt


%plotting vars
axisF=23;
fontF=22;

close all;
hFig=figure;
plot(t(1:41),[0,Vol(1:40)],'k-','LineWidth',2,'MarkerSize',8);
set([gca]             , ...
    'FontSize'   , fontF           );
ylabel('Volume (L)','interpreter','latex','FontSize',axisF);
xlabel('time (s)','interpreter','latex','FontSize',axisF);
 set(gca,'XTick', 0:0.5:4);
set(gcf, 'PaperSize', [16 15])
set(gcf, 'PaperPosition', [-1.3 0.2 18 15]); %Position plot at left hand corner with width 5 and height 5.
output_plot_filename='volume_tracheaz'
print(hFig,strcat(out_base,output_plot_filename),'-dpdf','-r0')




hFig=figure;
plot(t(1:41),Frate(1:41),'k-','LineWidth',2,'MarkerSize',8);
set([gca]             , ...
    'FontSize'   , fontF           );
ylabel('Flow rate (L/s)','interpreter','latex','FontSize',axisF);
xlabel('time (s)','interpreter','latex','FontSize',axisF);
 set(gca,'XTick', 0:0.5:4);
set(gcf, 'PaperSize', [16 15])
set(gcf, 'PaperPosition', [-2 0.2 19  15.5]); %Position plot at left hand corner with width 5 and height 5.
output_plot_filename='flowrate_tracheaz'
print(hFig,strcat(out_base,output_plot_filename),'-dpdf','-r0')



 

hFig=figure;
plot(mean_sig(1:39),Vol(1:39),'k-','LineWidth',2,'MarkerSize',8);
hold all;
arrowhead([mean_sig(9) mean_sig(10)],[Vol(9) Vol(10)],'k',[],2)
hold all;
arrowhead([mean_sig(29) mean_sig(30)],[Vol(29) Vol(30)],'k',[],2)

set([gca]             , ...
    'FontSize'   , fontF           );
ylabel('Volume (L)','interpreter','latex','FontSize',axisF);
xlabel('Mean elastic recoil (Pa)','interpreter','latex','FontSize',axisF);
 set(gca,'XTick', 0:500:3000);
  set(gca,'YTick', 0:0.1:0.4);
  ylim([-0.02 0.4]);
set(gcf, 'PaperSize', [16 15])
set(gcf, 'PaperPosition', [-1.2 0.2 17.5 15]); %Position plot at left hand corner with width 5 and height 5.
output_plot_filename='recoil_tracheaz'
print(hFig,strcat(out_base,output_plot_filename),'-dpdf','-r0')

close all
hFig=figure;
plot(t(1:41),[0,mean_s_p(1:40)],'k-','LineWidth',2,'MarkerSize',8);
set([gca]             , ...
    'FontSize'   , fontF           );
ylabel('Mean pressure drop (Pa)','interpreter','latex','FontSize',axisF);
xlabel('time (s)','interpreter','latex','FontSize',axisF);
 set(gca,'XTick', 0:0.5:4);
set(gcf, 'PaperSize', [16 15])
set(gcf, 'PaperPosition', [-3.7 0.2 21.5 15]); %Position plot at left hand corner with width 5 and height 5.
output_plot_filename='pressure_tracheaz'
print(hFig,strcat(out_base,output_plot_filename),'-dpdf','-r0')




close all;
clear ylabels
hFig=figure;

hist(s_p(18,:),20);
axis([-550 50 0 2000]);
ylabels = get(gca, 'YTickLabel');
ylabels = linspace(0,100*2000/5000,5);
set(gca,'YTickLabel',ylabels); 
set([gca]             , ...
    'FontSize'   , fontF           );
ylabel('Percentage of total lung volme','interpreter','latex','FontSize',axisF);
xlabel('Pressure (Pa)','interpreter','latex','FontSize',axisF);
set(gcf, 'PaperPosition', [-4.7 0.25 17 15]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [11 15])
output_plot_filename='pressure_histz'
print(hFig,strcat(out_base,output_plot_filename),'-dpdf','-r0')



close all;
clear ylabels
hFig=figure;

hist(J(18,:),20);
axis([1.185 1.215 0 2500]);
ylabels = get(gca, 'YTickLabel');
ylabels = linspace(0,100*2500/5000,6);
set(gca,'YTickLabel',ylabels); 
set([gca]             , ...
    'FontSize'   , fontF           );
ylabel('Percentage of total lung volume','interpreter','latex','FontSize',axisF);
xlabel('Jacobian','interpreter','latex','FontSize',axisF);
set(gcf, 'PaperPosition', [-5 0.25 17 15]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [11 15])
output_plot_filename='j_histz'
print(hFig,strcat(out_base,output_plot_filename),'-dpdf','-r0')





close all;
clear ylabels
hFig=figure;

hist(sig(18,:),20);
axis([1750 3250 0 2500]);
ylabels = get(gca, 'YTickLabel');
ylabels = linspace(0,100*2500/5000,6);
set(gca,'YTickLabel',ylabels); 
set([gca]             , ...
    'FontSize'   , fontF           );
ylabel('Percentage of total lung volume','interpreter','latex','FontSize',axisF);
xlabel('Total stress (Pa)','interpreter','latex','FontSize',axisF);
set(gcf, 'PaperPosition', [-5 0.25 17 15]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [11 15])
output_plot_filename='stress_histz'
print(hFig,strcat(out_base,output_plot_filename),'-dpdf','-r0')











































%figure;
%plot(Frate(40:80),mean_s_p(40:80))
%ylabel('TBPD');
%xlabel('Flow rate (L/s)');

%figure;
%plot(mean_s_p(40:80),Vol(40:80))
%xlabel('TBPD');
%ylabel('Volume (L)');
% close all;
% figure;
% errorbar(NT,mean_s_p,std_s_p)
% title('Pressure');
% 
% figure;
% errorbar(NT,mean_J,std_J)
% title('J');
% 
% figure;
% errorbar(NT,mean_sig,std_sig)
% title('stress');

