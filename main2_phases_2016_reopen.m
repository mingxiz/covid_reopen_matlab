function output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)

%  SEIR Model for COVID-19 reopenning project
%  Written for MATLAB_R2019b
%  Copyright (C) 2020
%     Mingxi Zhu <mingxiz@stanford.edu>

n_age_strat = 3; n_work_strat = 3; total_N = 1938000;
%following distribution same as previous paper, without work strat
age_dist = [0.24, 0.6, 0.16]; work_dist = [0.554 0.374 0.072; 0.56 0.373 0.067; 0.508 0.418 0.074];
age_work_dist = [0.24*[0.554 0.374 0.072]; 0.6*[0.56 0.373 0.067];0.16*[ 0.508 0.418 0.074]];
%initial epi dist on S E UI DI UA DA R D

% generate epi parameters besides beta
param_epi = generate_param_epi(n_age_strat, n_work_strat);
param_epi.p = infect_rate;
% generate param policy
param_policy.e = 1;
% percentage of peop/Users/mingxi/Desktop/COVID_code/main2_phases.mle under policy control (could be work X age specific)
% each entry is in (0, 1)
param_policy.policy_pct = 0.01*ones(3,3);


% following same x0 with N_zero_patient; calculate intial state following paper
% current hospitalized 182 -- DI
for j = 1: n_work_strat
    %epi dist for y
    % S E UI DI UA DA R D
    x0(1,j,1,:) = age_work_dist(1,j)*[total_N-N_zero_patient 0 N_zero_patient*0.25 0 N_zero_patient*0.75 0 0 0];
    %epi dist for m
    x0(2,j,1,:) = age_work_dist(2,j)*[total_N-N_zero_patient 0 N_zero_patient*0.7 0 N_zero_patient*0.3 0 0 0];
    %epi dist for o
    x0(3,j,1,:) = age_work_dist(3,j)*[total_N-N_zero_patient 0 N_zero_patient*0.7 0 N_zero_patient*0.3 0 0 0];
end

% distributed to different policy;
x0_p=zeros(size(x0));
pct = param_policy.policy_pct;
for i = 1:n_age_strat
    for j = 1:n_work_strat
        for i_epi = 1:8
            x0_p(i,j,1,i_epi) = (1-pct(i,j))*x0(i,j,1,i_epi);
            x0_p(i,j,2,i_epi) = pct(i,j)*x0(i,j,1,i_epi);
        end
    end
end

% feed in parameters for ode
n_param.n_age_strat = n_age_strat;
n_param.n_work_strat = n_work_strat;

% construct vector on y0 from x0_p
start = 1;
y0 = zeros(8*2*n_age_strat*n_work_strat, 1);
for i_epi = 1:8
    for i_p = 1:2
        for i_work = 1:n_work_strat
            for i_age = 1:n_age_strat
                y0(start,1)=x0_p(i_age,i_work,i_p,i_epi);
                start = start + 1;
            end
        end
    end
end


% following website with time span 1 180, use ode 45 as solver
tspan1 = [1 t_SIP];
W_multiplier_1 = 1;
O_multiplier_1 = 1;
S_multiplier_1 = 1;
H_multipler_1 = 1;
phaseIndicator = 1;
fvpvnvRatioVec_1 = [1, 1, 1];
parm_beta_1 = generate_param_beta2(n_age_strat, n_work_strat, param_epi, W_multiplier_1, O_multiplier_1, S_multiplier_1, H_multipler_1, fvpvnvRatioVec_1, phaseIndicator);

opts = odeset('RelTol',1e-4,'AbsTol',1e-4);
% v1 is the version that didn't consider death influence on infection
sol1 = ode45(@(t,y) myODE_covid_v1(t, y, n_param, param_epi, parm_beta_1, param_policy, x0_p), tspan1, y0, opts);

% construct matrix from vector
x1 = zeros(n_age_strat,n_work_strat,2,8,size(sol1.x,2));
yt1 = sol1.y;
start = 1;
for i_epi = 1:8
    for i_p = 1:2
        for i_work = 1:n_work_strat
            for i_age = 1:n_age_strat
                for i_t = 1:size(sol1.x,2)
                    x1(i_age,i_work,i_p,i_epi,i_t)=yt1(start,i_t);
                end
                start = start+1;
            end
        end
    end
end

x0_1p = x1(:,:,:,:,size(sol1.x,2));
y0_1p = yt1(:,size(sol1.x,2));



% following website with time span 1 180, use ode 45 as solver
tspan2 =[t_SIP+1, t_reopen];
phaseIndicator = 2;
fvpvnvRatioVec = [0 0 1];
parm_beta_2 = generate_param_beta2(n_age_strat, n_work_strat, param_epi, W_multiplier, O_multiplier, S_multiplier, H_multiplier , fvpvnvRatioVec, phaseIndicator);

% v1 is the version that didn't consider death influence on infection
sol2 = ode45(@(t,y) myODE_covid_v1(t, y, n_param, param_epi, parm_beta_2, param_policy, x0_1p), tspan2, y0_1p, opts);

% construct matrix from vector
x2 = zeros(n_age_strat,n_work_strat,2,8,size(sol2.x,2));
yt2 = sol2.y;
start = 1;
for i_epi = 1:8
    for i_p = 1:2
        for i_work = 1:n_work_strat
            for i_age = 1:n_age_strat
                for i_t = 1:size(sol2.x,2)
                    x2(i_age,i_work,i_p,i_epi,i_t)=yt2(start,i_t);
                end
                start = start+1;
            end
        end
    end
end

x0_2p = x2(:,:,:,:,size(sol2.x,2));
y0_2p = yt2(:,size(sol2.x,2));



% following website with time span 1 180, use ode 45 as solver
tspan3 =[t_reopen+1, t_end];
parm_beta_3 = generate_param_beta3(n_age_strat, n_work_strat, param_epi, W_multiplier_r, O_multiplier_r, S_multiplier_r, H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare);

% v1 is the version that didn't consider death influence on infection
sol3 = ode45(@(t,y) myODE_covid_v1(t, y, n_param, param_epi, parm_beta_3, param_policy, x0_2p), tspan3, y0_2p, opts);

% construct matrix from vector
x3 = zeros(n_age_strat,n_work_strat,2,8,size(sol3.x,2));
yt3 = sol3.y;
start = 1;
for i_epi = 1:8
    for i_p = 1:2
        for i_work = 1:n_work_strat
            for i_age = 1:n_age_strat
                for i_t = 1:size(sol3.x,2)
                    x3(i_age,i_work,i_p,i_epi,i_t)=yt3(start,i_t);
                end
                start = start+1;
            end
        end
    end
end


% create hosp resp death phase 1

hospitalization_rate = [0.00 0.1124 0.2885];
respirator_rate = [0.00 0.0304 0.0673];
plot_DI_hosp_rates_1 = zeros(n_age_strat,size(x1,5));
plot_DI_resp_rates_1 = zeros(n_age_strat,size(x1,5));
plot_DI_death_rates_1 = zeros(n_age_strat,size(x1,5));
for i = 1:n_age_strat
    for t = 1: size(x1,5)
        crt_sum_1 = x1(i,:,:,4,t);
        plot_DI_hosp_rates_1(i, t) = hospitalization_rate(1, i)*sum(crt_sum_1(:));
        plot_DI_resp_rates_1(i, t) = respirator_rate(1, i)*sum(crt_sum_1(:));
        crt_sum_2 = x1(i,:,:,8,t);
        plot_DI_death_rates_1(i, t)= sum(crt_sum_2(:));
    end
end
plot_DI_hosp_rates_interp_1 = zeros(n_age_strat,t_SIP);
plot_DI_resp_rates_interp_1 = zeros(n_age_strat,t_SIP);
plot_DI_death_rates_interp_1 = zeros(n_age_strat,t_SIP);

for i = 1:n_age_strat
    plot_DI_hosp_rates_interp_1(i,:) = interp1(sol1.x,plot_DI_hosp_rates_1(i,:),[1:1:t_SIP]);
    plot_DI_resp_rates_interp_1(i,:) = interp1(sol1.x,plot_DI_resp_rates_1(i,:),[1:1:t_SIP]);
    plot_DI_death_rates_interp_1(i,:) = interp1(sol1.x,plot_DI_death_rates_1(i,:),[1:1:t_SIP]);
end

% change to culmulative
mean_hospital = 5;
mean_ICU = 15;
plot_DI_hosp_1 = zeros(n_age_strat,t_SIP);
plot_DI_resp_1 = zeros(n_age_strat,t_SIP);

plot_DI_hosp_1(:,1)=plot_DI_hosp_rates_interp_1(:,1);
plot_DI_resp_1(:,1)=plot_DI_resp_rates_interp_1(:,1);

plot_DI_death_1 = plot_DI_death_rates_interp_1;

for t = 2:mean_hospital
    for i = 1:n_age_strat
    plot_DI_hosp_1(i,t)= plot_DI_hosp_rates_interp_1(i,t) + plot_DI_hosp_1(i,t-1);
    end
end
for t = 2:mean_ICU
     for i = 1:n_age_strat
     plot_DI_resp_1(i,t)= plot_DI_resp_rates_interp_1(i,t) + plot_DI_resp_1(i,t-1);
     end
end

for t = mean_hospital+1:t_SIP
     for i = 1:n_age_strat
     plot_DI_hosp_1(i,t)=plot_DI_hosp_rates_interp_1(i,t)+plot_DI_hosp_1(i,t-1)-plot_DI_hosp_rates_interp_1(i,t-mean_hospital);
     end
end

for t = mean_ICU+1:t_SIP
     for i = 1:n_age_strat
     plot_DI_resp_1(i,t)=plot_DI_resp_rates_interp_1(i,t)+plot_DI_resp_1(i,t-1)-plot_DI_resp_rates_interp_1(i,t-mean_ICU);
     end
end


plot_DI_hosp_total = sum(plot_DI_hosp_1,1);
plot_DI_resp_total = sum(plot_DI_resp_1,1);
plot_DI_death_total = sum(plot_DI_death_1,1);

output.hosp_phase_1 = plot_DI_hosp_total;
output.resp_phase_1 = plot_DI_resp_total;
output.death_phase_1 = plot_DI_death_total;











% creat hosp resp death phase 2

hospitalization_rate = [0.00 0.1124 0.2885];
respirator_rate = [0.00 0.0304 0.0673];
plot_DI_hosp_rates_2 = zeros(n_age_strat,size(x2,5));
plot_DI_resp_rates_2 = zeros(n_age_strat,size(x2,5));
plot_DI_death_rates_2 = zeros(n_age_strat,size(x2,5));
for i = 1:n_age_strat
    for t = 1: size(x2,5)
        crt_sum_1 = x2(i,:,:,4,t);
        plot_DI_hosp_rates_2(i, t) = hospitalization_rate(1, i)*sum(crt_sum_1(:));
        plot_DI_resp_rates_2(i, t) = respirator_rate(1, i)*sum(crt_sum_1(:));
        crt_sum_2 = x2(i,:,:,8,t);
        plot_DI_death_rates_2(i, t)= sum(crt_sum_2(:));
    end
end

plot_DI_hosp_rates_interp_2 = zeros(n_age_strat,length([t_SIP+1:1:t_reopen]));
plot_DI_resp_rates_interp_2 = zeros(n_age_strat,length([t_SIP+1:1:t_reopen]));
plot_DI_death_rates_interp_2 = zeros(n_age_strat,length([t_SIP+1:1:t_reopen]));

for i = 1:n_age_strat
    plot_DI_hosp_rates_interp_2(i,:) = interp1(sol2.x,plot_DI_hosp_rates_2(i,:),[t_SIP+1:1:t_reopen]);
    plot_DI_resp_rates_interp_2(i,:) = interp1(sol2.x,plot_DI_resp_rates_2(i,:),[t_SIP+1:1:t_reopen]);
    plot_DI_death_rates_interp_2(i,:) = interp1(sol2.x,plot_DI_death_rates_2(i,:),[t_SIP+1:1:t_reopen]);
end

% change to culmulative
mean_hospital = 5;
mean_ICU = 15;
plot_DI_hosp_2 = zeros(n_age_strat,length([t_SIP+1:1:t_reopen]));
plot_DI_resp_2 = zeros(n_age_strat,length([t_SIP+1:1:t_reopen]));

plot_DI_hosp_2(:,1)= plot_DI_hosp_1(:,t_SIP)+plot_DI_hosp_rates_interp_2(:,1) - plot_DI_hosp_rates_interp_1(:,t_SIP-(mean_hospital-1));
plot_DI_resp_2(:,1)= plot_DI_resp_1(:,t_SIP)+plot_DI_resp_rates_interp_2(:,1) - plot_DI_resp_rates_interp_1(:,t_SIP-(mean_ICU-1));
plot_DI_death_2 = plot_DI_death_rates_interp_2;

for t = 2:mean_hospital
    for i = 1:n_age_strat
    plot_DI_hosp_2(i,t)= plot_DI_hosp_rates_interp_2(i,t) + plot_DI_hosp_2(i,t-1)-plot_DI_hosp_rates_interp_1(i,t_SIP-(mean_hospital-t));
    end
end
for t = 2:mean_ICU
     for i = 1:n_age_strat
     plot_DI_resp_2(i,t)= plot_DI_resp_rates_interp_2(i,t) + plot_DI_resp_2(i,t-1)-plot_DI_resp_rates_interp_1(i,t_SIP-(mean_ICU-t));
     end
end

for t = mean_hospital+1:length([t_SIP+1:1:t_reopen])
     for i = 1:n_age_strat
     plot_DI_hosp_2(i,t)=plot_DI_hosp_rates_interp_2(i,t)+plot_DI_hosp_2(i,t-1)-plot_DI_hosp_rates_interp_2(i,t-mean_hospital);
     end
end

for t = mean_ICU+1:length([t_SIP+1:1:t_reopen])
     for i = 1:n_age_strat
     plot_DI_resp_2(i,t)=plot_DI_resp_rates_interp_2(i,t)+plot_DI_resp_2(i,t-1)-plot_DI_resp_rates_interp_2(i,t-mean_ICU);
     end
end


plot_DI_hosp_total = sum(plot_DI_hosp_2,1);
plot_DI_resp_total = sum(plot_DI_resp_2,1);
plot_DI_death_total = sum(plot_DI_death_2,1);

output.hosp_phase_2 = plot_DI_hosp_total;
output.resp_phase_2 = plot_DI_resp_total;
output.death_phase_2 = plot_DI_death_total;






% creat hosp resp death phase 3

hospitalization_rate = [0.00 0.1124 0.2885];
respirator_rate = [0.00 0.0304 0.0673];
plot_DI_hosp_rates_3 = zeros(n_age_strat,size(x3,5));
plot_DI_resp_rates_3 = zeros(n_age_strat,size(x3,5));
plot_DI_death_rates_3 = zeros(n_age_strat,size(x3,5));
for i = 1:n_age_strat
    for t = 1: size(x3,5)
        crt_sum_1 = x3(i,:,:,4,t);
        plot_DI_hosp_rates_3(i, t) = hospitalization_rate(1, i)*sum(crt_sum_1(:));
        plot_DI_resp_rates_3(i, t) = respirator_rate(1, i)*sum(crt_sum_1(:));
        crt_sum_2 = x3(i,:,:,8,t);
        plot_DI_death_rates_3(i, t)= sum(crt_sum_2(:));
    end
end

plot_DI_hosp_rates_interp_3 = zeros(n_age_strat,length([t_reopen+1:1:t_end]));
plot_DI_resp_rates_interp_3 = zeros(n_age_strat,length([t_reopen+1:1:t_end]));
plot_DI_death_rates_interp_3 = zeros(n_age_strat,length([t_reopen+1:1:t_end]));

for i = 1:n_age_strat
    plot_DI_hosp_rates_interp_3(i,:) = interp1(sol3.x,plot_DI_hosp_rates_3(i,:),[t_reopen+1:1:t_end]);
    plot_DI_resp_rates_interp_3(i,:) = interp1(sol3.x,plot_DI_resp_rates_3(i,:),[t_reopen+1:1:t_end]);
    plot_DI_death_rates_interp_3(i,:) = interp1(sol3.x,plot_DI_death_rates_3(i,:),[t_reopen+1:1:t_end]);
end

% change to culmulative
mean_hospital = 5;
mean_ICU = 15;
plot_DI_hosp_3 = zeros(n_age_strat,length([t_reopen+1:1:t_end]));
plot_DI_resp_3 = zeros(n_age_strat,length([t_reopen+1:1:t_end]));

plot_DI_hosp_3(:,1)= plot_DI_hosp_2(:,end)+plot_DI_hosp_rates_interp_3(:,1)-plot_DI_hosp_rates_interp_2(:,end-(mean_hospital-1));
plot_DI_resp_3(:,1)= plot_DI_resp_2(:,end)+plot_DI_resp_rates_interp_3(:,1)-plot_DI_resp_rates_interp_2(:,end-(mean_ICU-1));
plot_DI_death_3 = plot_DI_death_rates_interp_3;

for t = 2:mean_hospital
    for i = 1:n_age_strat
    plot_DI_hosp_3(i,t)= plot_DI_hosp_rates_interp_3(i,t) + plot_DI_hosp_3(i,t-1)-plot_DI_hosp_rates_interp_2(i,end-(mean_hospital-t));
    end
end
for t = 2:mean_ICU
     for i = 1:n_age_strat
     plot_DI_resp_3(i,t)= plot_DI_resp_rates_interp_3(i,t) + plot_DI_resp_3(i,t-1)-plot_DI_resp_rates_interp_2(i,end-(mean_ICU-t));
     end
end

for t = mean_hospital+1:length([t_reopen+1:1:t_end])
     for i = 1:n_age_strat
     plot_DI_hosp_3(i,t)=plot_DI_hosp_rates_interp_3(i,t)+plot_DI_hosp_3(i,t-1)-plot_DI_hosp_rates_interp_3(i,t-mean_hospital);
     end
end

for t = mean_ICU+1:length([t_reopen+1:1:t_end])
     for i = 1:n_age_strat
     plot_DI_resp_3(i,t)=plot_DI_resp_rates_interp_3(i,t)+plot_DI_resp_3(i,t-1)-plot_DI_resp_rates_interp_3(i,t-mean_ICU);
     end
end


plot_DI_hosp_total = sum(plot_DI_hosp_3,1);
plot_DI_resp_total = sum(plot_DI_resp_3,1);
plot_DI_death_total = sum(plot_DI_death_3,1);

output.hosp_phase_3 = plot_DI_hosp_total;
output.resp_phase_3 = plot_DI_resp_total;
output.death_phase_3 = plot_DI_death_total;







plot_DI_hosp_total = [output.hosp_phase_1,output.hosp_phase_2, output.hosp_phase_3];
plot_DI_resp_total = [output.resp_phase_1,output.resp_phase_2, output.resp_phase_3];
plot_DI_death_total = [output.death_phase_1,output.death_phase_2, output.death_phase_3];

capacity_bed = (1034+1222)*ones(1,t_end);
capacity_ven = 722*ones(1,t_end);
X2 = [1:t_end];
YMatrix4 = [plot_DI_hosp_total;plot_DI_resp_total;capacity_bed;capacity_ven];


if options_figure
per1Length = t_SIP;


bchmkData = [63	66	69	72	73	82	75	76	69	72	72	74	73	77	66	69	69	64	65	64	58	72	66	67	69	69	67	66	60	61	65	55	50	45	43	36	37	37	35	35
62	75	81	82	76	70	90	89	99	95	111	115	77	74	89	71	70	84	73	77	71	67	69	76	79	74	69	76	70	64	60	59	65	62	59	55	55	57	54	42
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	3	6	8	8	11	13	15	18	19	19	22	25	25	27	28	30	30	30	31	33];

length_bchmkData = size(bchmkData,2);
bchmkStart = 12;
    
    
% Create figure
figure2 = figure;
% Create axes
axes1 = axes('Parent',figure2);
hold(axes1,'on');
% Create multiple lines using matrix input to plot
plot1 = plot(X2,YMatrix4,'LineWidth',3,'Parent',axes1);
set(plot1(1),'DisplayName','Hospital',...
    'Color',[0.850980392156863 0.325490196078431 0.0980392156862745]);
set(plot1(2),'DisplayName','Ventilator',...
    'Color',[0 0.447058823529412 0.741176470588235]);
set(plot1(3),'DisplayName','Bed Capacity','LineStyle',':','Color',[0 0 0]);
set(plot1(4),'DisplayName','Ventilator Capacity','LineStyle','--',...
    'Color',[0 0 0]);
% Create xlabel
xlabel({'Time (days)'});
% Create title
title({'Dyanmics of cases needing advanced care'});
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',14,'XGrid','on','XTick',[0:50:t_end],'YGrid','on');
% Create legend
legend(axes1,'show');

% Create figure
figure3 = figure;
% Create axes
axes1 = axes('Parent',figure3);
hold(axes1,'on');
% Create multiple lines using matrix input to plot
YMatrix1_p=[plot_DI_hosp_total;plot_DI_resp_total];
plot1 = plot(X2,YMatrix1_p,'LineWidth',3);
set(plot1(1),'DisplayName','Hospital');
set(plot1(2),'DisplayName','Ventilator');
% Create multiple lines using matrix input to plot
X2_p = [per1Length+ bchmkStart:(per1Length + bchmkStart + length_bchmkData - 1)];
YMatrix2_p = bchmkData(1:2,:);
plot2 = plot(X2_p,YMatrix2_p,'LineWidth',3,'LineStyle',':');
set(plot2(1),'DisplayName','Benchmark Ventilator',...
    'Color',[0.850980392156863 0.325490196078431 0.0980392156862745]);
set(plot2(2),'DisplayName','Benchmark Hospital',...
    'Color',[0 0.447058823529412 0.741176470588235]);
% Create xlabel
xlabel({'Time (days)'});
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',16);
% Create legend
legend(axes1,'show');


% Create figure
figure1 = figure;
Y1 = plot_DI_death_total;
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
% Create plot
plot(Y1,'LineWidth',3);
% Create ylabel
ylabel({'Number of Death'});
% Create xlabel
xlabel({'Time (days)'});
% Create title
title({'Cumulative Death'});
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',18);

end


output.x1=sol1.x;
output.x2=sol2.x;
output.x3=sol3.x;
output.y1 = x1;
output.y2 = x2;
output.y3 = x3;
