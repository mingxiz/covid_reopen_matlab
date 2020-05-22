
function finalCM = getCM3(W_multiplier, O_multiplier, S_multiplier, H_multipler, fvpvnvRatioVec, epi_ymo_fvpvnv_fullTWTOTS, phaseIndicator)

% Written by Zhengli Wang %
% modified 2020/5/21
% Written by Zhengli Wang %
% modified 2020/5/21

%{
W_multiplier = 1;
O_multiplier = 1;
S_multiplier = 1;
H_multipler = 0.3;
%}


% pre-epidemic benchmark hrs
pre_epi_bchmrkTWTOTSTH = [1.22
4.466
0.77
7.21
6.16
9.65
3.06
0.432
0.03
12.52
12.94
13.555];


if phaseIndicator == 1 % pre-epidemic
    epi_ymo_fvpvnv_fullTWTOTS = pre_epi_bchmrkTWTOTSTH(1:9);
    epi_rel_TWTOTS = ones(9,1);
    if W_multiplier ~= 1 || O_multiplier~= 1 || S_multiplier~=1 || H_multipler~= 1; disp('error, phase 1, multiplier ~= 1'); temp = [1,2]*[1,2]; end
elseif phaseIndicator == 2 ||  phaseIndicator == 3
    
   
    epi_rel_TWTOTS = [fvpvnvRatioVec, fvpvnvRatioVec, fvpvnvRatioVec]';
end
% Note epi_rel_TH is 1

epi_rel_o_TWTOTS = 0.001;


pre_epi_bchmrkWOSH = [0.193621269	0.594440112	1.04297E-05
0.291051208	4.718460835	3.13572E-05
2.333E-05	0.000353689	4.02748E-05
3.173067683	2.105651355	0.177302627
0.645259748	3.430001215	0.224777108
0.215193753	1.841370168	0.535709037
4.279500055	0.440065735	0.001232786
0.75828838	0.312873068	0.002666921
0.030635069	0.057707493	0.022039096
2.027223737	1.826605952	0.020758853
1.255571221	1.811441214	0.04017814
0.970863626	1.171044869	0.60262609];

% Mtpl: Multiplier
pre_epi_bchmrkWOSH_Mtpl = pre_epi_bchmrkWOSH;
pre_epi_bchmrkWOSH_Mtpl(1:3,:) = pre_epi_bchmrkWOSH(1:3,:).*W_multiplier;
pre_epi_bchmrkWOSH_Mtpl(4:6,:) = pre_epi_bchmrkWOSH(4:6,:).*O_multiplier;
pre_epi_bchmrkWOSH_Mtpl(7:9,:) = pre_epi_bchmrkWOSH(7:9,:).*S_multiplier;
pre_epi_bchmrkWOSH_Mtpl(end-2:end,:) =  pre_epi_bchmrkWOSH(end-2:end,:).*H_multipler;

epi_percMat = [55.4	37.4	7.2
56.0	37.3	6.7
50.8	41.8	7.4]./100;







% e.g. epi_rel_TWTOTS = [0;0.5;1;1;1;1;0;0.5;1]; epi_rel_o_TWTOTS = 0.001;
% -> epi_rel_ymo_fvpvnv_TWTOTS = [0;0.5;1;0;0.5;1;0.001;0.001;0.001;  1;1;1;1;1;1;0.001;0.001;0.001;  0;0.5;1;0;0.5;1;0.001;0.001;0.001]
% (y,fv), (y,pv), (y,nv), (m,fv), (m,pv), (m,nv), (o,fv) ... for W, then (y,fv), (y,pv), (y,nv), (m,fv), (m,pv), (m,nv), (o,fv) ... for O
epi_rel_ymo_fvpvnv_TWTOTS = [repmat(epi_rel_TWTOTS(1:3),2,1); repmat(epi_rel_o_TWTOTS,3,1); repmat(epi_rel_TWTOTS(4:6),2,1); repmat(epi_rel_o_TWTOTS,3,1); repmat(epi_rel_TWTOTS(7:9),2,1); repmat(epi_rel_o_TWTOTS,3,1)];

epi_ymo_fvpvnv_TWTOTS = epi_rel_ymo_fvpvnv_TWTOTS.*repelem(epi_ymo_fvpvnv_fullTWTOTS(1:9),3);


epi_TnH_Vec = zeros(9,1);
for i = 1:length(epi_TnH_Vec)
    epi_TnH_Vec(i) = epi_ymo_fvpvnv_TWTOTS(i) + epi_ymo_fvpvnv_TWTOTS(i+9) + epi_ymo_fvpvnv_TWTOTS(i+18);
end
epi_TnH_Mat = reshape(epi_TnH_Vec',3,3);
epi_TnH_Mat = epi_TnH_Mat';

epi_TH_Mat = 24 - epi_TnH_Mat;



% Posterior Probability
Bayes_PW = zeros(3,3);
for i = 1:size(Bayes_PW,1)
    for j = 1:size(Bayes_PW,2)
        Bayes_PW(i,j) = epi_percMat(i,j)*epi_TnH_Mat(i,j)/sum(epi_percMat(i,:).*epi_TnH_Mat(i,:));
    end
end
Bayes_PWPOPS = repmat(Bayes_PW, 3, 1);
Bayes_PH = zeros(3,3);
for i = 1:size(Bayes_PH,1)
    for j = 1:size(Bayes_PH,2)
        Bayes_PH(i,j) = epi_percMat(i,j)*epi_TH_Mat(i,j)/sum(epi_percMat(i,:).*epi_TH_Mat(i,:));
    end
end
Bayes_PWPOPSPH = [Bayes_PWPOPS; Bayes_PH];

% epi_TWTOTSTH, pre_epi_WxyOxySxyHxy, pre_epi_WxmOxmSxmHxm,
% pre_epi_WxoOxoSxoHxo, pre_epi_TWTOTSTH, pre_epi_ymo_fvpvnv_TWTOTSTH
epi_ymo_fvpvnv_TWTOTSTH = [epi_ymo_fvpvnv_TWTOTS; reshape(epi_TH_Mat',9,1)];
pre_epi_bchmrkWxyOxySxyHxy = repelem(pre_epi_bchmrkWOSH_Mtpl(:,1),3);
pre_epi_bchmrkWxmOxmSxmHxm = repelem(pre_epi_bchmrkWOSH_Mtpl(:,2),3);
pre_epi_bchmrkWxoOxoSxoHxo = repelem(pre_epi_bchmrkWOSH_Mtpl(:,3),3);
pre_epi_ymo_fvpvnv_bchmrkTWTOTSTH = repelem(pre_epi_bchmrkTWTOTSTH,3);

y_total = pre_epi_bchmrkWxyOxySxyHxy.*(epi_ymo_fvpvnv_TWTOTSTH./pre_epi_ymo_fvpvnv_bchmrkTWTOTSTH);
m_total = pre_epi_bchmrkWxmOxmSxmHxm.*(epi_ymo_fvpvnv_TWTOTSTH./pre_epi_ymo_fvpvnv_bchmrkTWTOTSTH);
o_total = pre_epi_bchmrkWxoOxoSxoHxo.*(epi_ymo_fvpvnv_TWTOTSTH./pre_epi_ymo_fvpvnv_bchmrkTWTOTSTH);
ymo_total = [y_total, m_total, o_total];

Bayes_PWPOPSPH_transpose = Bayes_PWPOPSPH';
Bayes_ymo_fvpvnv_PWPOPSPH = reshape(Bayes_PWPOPSPH_transpose(:),9,4)';
% This gives Prob(y,fv | y), Prob(y,pv | y), Prob(y,nv | y), Prob(m,fv | m), Prob(m,pv | m), Prob(m,nv | m), Prob(o,fv | o), Prob(o,pv | o), Prob(o,nv | o)
Bayes_ymo_fvpvnv_PWPOPSPH = repelem(Bayes_ymo_fvpvnv_PWPOPSPH,9,1);  % dimension is 36*9
epi_WOSH = zeros(9*4,9);
for i = 1:size(epi_WOSH,1)
    for j = 1:size(epi_WOSH,2)
        epi_WOSH(i,j) = ymo_total(i, ceil(j/3))*Bayes_ymo_fvpvnv_PWPOPSPH(i, j);
    end
end
% fix i, and j = [1,2,3,4,5,6,7,8,9]
% ymo_total(i, [1,1,1,2,2,2,3,3,3])

finalCM = epi_WOSH(1:9,:) + epi_WOSH(10:18,:) + epi_WOSH(19:27,:) + epi_WOSH(28:36,:);

% TODO: modify this percentage
pop_perc_ymo = [1/3;1/3;1/3];
pre_epi_avgHvalue = sum(pop_perc_ymo.*sum(pre_epi_bchmrkWOSH(end-2:end,:),2));

epi_avgHvalue_y = sum(epi_percMat(1,:)'.*sum(epi_WOSH(end-8:end-6,:),2));
epi_avgHvalue_m = sum(epi_percMat(2,:)'.*sum(epi_WOSH(end-5:end-3,:),2));
epi_avgHvalue_o = sum(epi_percMat(3,:)'.*sum(epi_WOSH(end-2:end-0,:),2));
epi_avgHvalue = sum(pop_perc_ymo.*[epi_avgHvalue_y; epi_avgHvalue_m; epi_avgHvalue_o]);

