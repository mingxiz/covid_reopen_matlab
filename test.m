
function test

% use the same parameter as the orginal code did 
% one potential problem, their code didn't consider Nj0 as in system of
% equation but just as parameter that does not change across time

% in order for consistentcy I used same modeling
% but please refer to more precide ode version

% main
% input parameters
% [y m o] % [fv pv nv]
n_age_strat = 3; n_work_strat = 1; total_N = 1938000;
%following distribution same as previous paper, without work strat
age_dist = [0.24, 0.6, 0.16]; work_dist = 1;
%initial epi dist on S E UI DI UA DA R D


% generate epi parameters besides beta
param_epi = generate_param_epi(n_age_strat, n_work_strat);
% generate beta
v_table_nopolicy = [9.76190295 6.68764643 0.91568368; 2.2706404 10.333416 1.01411684;0.29226176 0.88528063 1.24948302];
v_table_policy = v_table_nopolicy;
parm_beta = covid_open_beta(n_age_strat, n_work_strat, v_table_nopolicy, v_table_policy, param_epi);
% generate param policy
param_policy = generate_param_policy;


% following same x0; calculate intial state following paper
x0(1,:,1,:) =  [0.24*total_N-(25+6+18) 100*0.24 100*0.24*0.25 0 100*0.24*0.75 0 0 0];
x0(2,:,1,:)= [0.6*total_N-(60+40+20) 100*0.6 100*0.6*0.7 0 100*0.6*0.3 0 0 0];
x0(3,:,1,:) =  [0.16*total_N-(16+11+4) 100*0.16 100*0.16*0.7 0 100*0.16*0.3 0 0 0];
x0(1,:,2,:)= zeros(8,1);
x0(2,:,2,:)= zeros(8,1);
x0(3,:,2,:)= zeros(8,1);

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
t_span_end = 180;
tspan = [1 t_span_end];
opts = odeset('RelTol',1e-10,'AbsTol',1e-10);
% v1 is the version that didn't consider death influence on infection
sol = ode45(@(t,y) myODE_covid_v1(t, y, n_param, param_epi, parm_beta, param_policy, x0_p), tspan, y0);

% construct matrix from vector
x = zeros(n_age_strat,n_work_strat,2,8,size(sol.x,2));
yt = sol.y;
start = 1;
for i_epi = 1:8
    for i_p = 1:2
        for i_work = 1:n_work_strat
            for i_age = 1:n_age_strat
                for i_t = 1:size(sol.x,2)
                    x(i_age,i_work,i_p,i_epi,i_t)=yt(start,i_t);
                end
                start = start+1;
            end
        end
    end
end


% plot E, Asym and Sym as website
plot_age_E = zeros(1,size(x,5));
plot_age_sym = zeros(1,size(x,5));
plot_age_asym = zeros(1,size(x,5));
for i = 1:n_age_strat
    for t = 1: size(x,5)
        plot_age_E(i,t) = sum(x(i,:,:,2,t),'all');
        plot_age_sym(i,t) = sum(x(i,:,:,[3,4],t),'all');
        plot_age_asym(i,t) = sum(x(i,:,:,[5,6],t),'all');
    end
end

X1 = sol.x;
YMatrix1 = [plot_age_sym(1,:);plot_age_E(1,:);plot_age_asym(1,:)];
YMatrix2 = [plot_age_sym(2,:);plot_age_E(2,:);plot_age_asym(2,:)];
YMatrix3 = [plot_age_sym(3,:);plot_age_E(3,:);plot_age_asym(3,:)];

% Create figure
figure1 = figure;

% Create subplot
subplot1 = subplot(3,1,1,'Parent',figure1);
hold(subplot1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',subplot1,'LineWidth',2);
set(plot1(1),'DisplayName','Symptomatic');
set(plot1(2),'DisplayName','Exposed');
set(plot1(3),'DisplayName','Asymptomatic',...
    'Color',[0.466666666666667 0.674509803921569 0.188235294117647]);

% Create title
title({'< 20'});

box(subplot1,'on');
grid(subplot1,'on');
% Set the remaining axes properties
set(subplot1,'FontSize',12,'XTick',[0 50 100 150 200]);
% Create legend
legend1 = legend(subplot1,'show');
set(legend1,'FontSize',12);

% Create subplot
subplot2 = subplot(3,1,2,'Parent',figure1);
hold(subplot2,'on');

% Create multiple lines using matrix input to plot
plot2 = plot(X1,YMatrix2,'Parent',subplot2,'LineWidth',2);
set(plot2(1),'DisplayName','Symptomatic');
set(plot2(2),'DisplayName','Exposed');
set(plot2(3),'DisplayName','Asymptomatic',...
    'Color',[0.466666666666667 0.674509803921569 0.188235294117647]);

% Create title
title({'21 - 65'});

box(subplot2,'on');
grid(subplot2,'on');
% Set the remaining axes properties
set(subplot2,'FontSize',12,'XTick',[0 50 100 150 200]);
% Create legend
legend2 = legend(subplot2,'show');
set(legend2,'FontSize',12);

% Create subplot
subplot3 = subplot(3,1,3,'Parent',figure1);
hold(subplot3,'on');

% Create multiple lines using matrix input to plot
plot3 = plot(X1,YMatrix3,'Parent',subplot3,'LineWidth',2);
set(plot3(1),'DisplayName','Symptomatic');
set(plot3(2),'DisplayName','Exposed');
set(plot3(3),'DisplayName','Asymptomatic',...
    'Color',[0.466666666666667 0.674509803921569 0.188235294117647]);

% Create xlabel
xlabel({'Time (days)'});

% Create title
title({'> 65'});

box(subplot3,'on');
grid(subplot3,'on');
% Set the remaining axes properties
set(subplot3,'FontSize',12,'XTick',[0 50 100 150 200]);
% Create legend
legend3 = legend(subplot3,'show');
set(legend3,'FontSize',12);



% creat hospitalization
% plot DI as website

capacity_bed = (1034+1222)*ones(1,size(x,5));
capacity_ven = 722*ones(1,size(x,5));

% create hospitalization by age
% plot DI as website
hospitalization_rate = [0.00 0.1124 0.2885];
respirator_rate = [0.00 0.0304 0.0673];
plot_DI_hosp_rates = zeros(n_age_strat,size(x,5));
plot_DI_resp_rates = zeros(n_age_strat,size(x,5));
for i = 1:n_age_strat
    for t = 1: size(x,5)
        plot_DI_hosp_rates(i, t) = hospitalization_rate(1, i)*sum(x(i,:,:,4,t),'all');
        plot_DI_resp_rates(i, t) = respirator_rate(1, i)*sum(x(i,:,:,4,t),'all');
    end
end
plot_DI_hosp_rates_interp = zeros(n_age_strat,t_span_end);
plot_DI_resp_rates_interp = zeros(n_age_strat,t_span_end);
for i = 1:n_age_strat
    plot_DI_hosp_rates_interp(i,:) = interp1(sol.x,plot_DI_hosp_rates(i,:),[1:1:t_span_end]);
    plot_DI_resp_rates_interp(i,:) = interp1(sol.x,plot_DI_resp_rates(i,:),[1:1:t_span_end]);
end

% change to culmulative
mean_hospital = 5;
mean_ICU = 10;
plot_DI_hosp = zeros(n_age_strat,t_span_end);
plot_DI_resp = ones(n_age_strat,t_span_end);

plot_DI_hosp(:,1)=plot_DI_hosp_rates_interp(:,1);
plot_DI_resp(:,1)=plot_DI_resp_rates_interp(:,1);
for t = 2:mean_hospital
    for i = 1:n_age_strat
    plot_DI_hosp(i,t)=plot_DI_hosp_rates_interp(i,t)+plot_DI_hosp(i,t-1);
    end
end
for t = 2:mean_ICU
     for i = 1:n_age_strat
     plot_DI_resp(i,t)=plot_DI_resp_rates_interp(i,t)+plot_DI_resp(i,t-1);
     end
end
for t = mean_hospital+1:t_span_end
     for i = 1:n_age_strat
     plot_DI_hosp(i,t)=plot_DI_hosp_rates_interp(i,t)+plot_DI_hosp(i,t-1)-plot_DI_hosp_rates_interp(i,t-mean_hospital);
     end
end
for t = mean_ICU+1:t_span_end
     for i = 1:n_age_strat
     plot_DI_resp(i,t)=plot_DI_resp_rates_interp(i,t)+plot_DI_resp(i,t-1)-plot_DI_resp_rates_interp(i,t-mean_ICU);
     end
end
plot_DI_hosp_total = sum(plot_DI_hosp,1);
plot_DI_resp_total = sum(plot_DI_resp,1);

capacity_bed = (1034+1222)*ones(1,t_span_end);
capacity_ven = 722*ones(1,t_span_end);
X2 = [1:t_span_end];

YMatrix4 = [plot_DI_hosp_total;plot_DI_resp_total;capacity_bed;capacity_ven];
YMatrix5 = [plot_DI_hosp;capacity_bed];
YMatrix6 = [plot_DI_resp;capacity_ven];



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
set(axes1,'FontSize',14,'XGrid','on','XTick',[0 50 100 150 200],'YGrid',...
    'on','YTick',[0 2500 5000 7500 10000 12500]);
% Create legend
legend(axes1,'show');

% plot
% Create figure
figure3 = figure;
% Create axes
axes1 = axes('Parent',figure3);
hold(axes1,'on');
% Create multiple lines using matrix input to plot
plot1 = plot(X2,YMatrix5,'LineWidth',3,'Parent',axes1);
set(plot1(1),'DisplayName','Y');
set(plot1(2),'DisplayName','M');
set(plot1(3),'DisplayName','O');
set(plot1(4),'DisplayName','Bed Capacity','LineWidth',2,'LineStyle','--',...
    'Color',[0.149019607843137 0.149019607843137 0.149019607843137]);
% Create xlabel
xlabel({'Time (days)'});
% Create title
% Create title
title({'Dyanmics of cases needing advanced care'});
% Set the remaining axes properties
set(axes1,'FontSize',16,'XGrid','on','YGrid','on');
% Create legend
legend(axes1,'show');

% Create figure
figure4 = figure;
% Create axes
axes1 = axes('Parent',figure4);
hold(axes1,'on');
% Create multiple lines using matrix input to plot
plot1 = plot(X2,YMatrix6,'LineWidth',3,'Parent',axes1);
set(plot1(1),'DisplayName','Y');
set(plot1(2),'DisplayName','M');
set(plot1(3),'DisplayName','O');
set(plot1(4),'DisplayName','Ventilator Capacity','LineWidth',2,'LineStyle','--',...
    'Color',[0.149019607843137 0.149019607843137 0.149019607843137]);
% Create xlabel
xlabel({'Time (days)'});
% Create title
title({'Dyanmics of cases needing advanced care'});
% Set the remaining axes properties
set(axes1,'FontSize',16,'XGrid','on','YGrid','on');
% Create legend
legend(axes1,'show');








