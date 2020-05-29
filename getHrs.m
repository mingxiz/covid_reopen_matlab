function epi_ymo_fvpvnv_TWTOTS = getHrs(fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare)
% Written by Zhengli Wang %
% init. 2020/5/28, input 6 arguments -> get 27*1 vector of hrs

% o_specialCare == 1 means we are providing special care to old

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

fvpvnv_TOratio = TOratio.*ones(1,3);
fvpvnv_TSratio = TSratio.*ones(1,3);
epi_rel_TWTOTS = [fv_TWratio, pv_TWratio, nv_TWratio, fvpvnv_TOratio, fvpvnv_TSratio]';


% e.g. epi_rel_TWTOTS = [0;0.5;1;1;1;1;0;0.5;1]; epi_rel_o_TWTOTS = 0.001;
% -> epi_rel_ymo_fvpvnv_TWTOTS = [0;0.5;1;0;0.5;1;0.001;0.001;0.001;  1;1;1;1;1;1;0.001;0.001;0.001;  0;0.5;1;0;0.5;1;0.001;0.001;0.001]
% (y,fv), (y,pv), (y,nv), (m,fv), (m,pv), (m,nv), (o,fv) ... for W, then (y,fv), (y,pv), (y,nv), (m,fv), (m,pv), (m,nv), (o,fv) ... for O
if o_specialCare == 1 % Special Care in place
    epi_rel_ymo_fvpvnv_TWTOTS = [repmat(epi_rel_TWTOTS(1:3),2,1); repmat(0.001,3,1); repmat(epi_rel_TWTOTS(4:6),3,1); repmat(epi_rel_TWTOTS(7:9),3,1)];
else
    epi_rel_ymo_fvpvnv_TWTOTS = [repmat(epi_rel_TWTOTS(1:3),3,1); repmat(epi_rel_TWTOTS(4:6),3,1); repmat(epi_rel_TWTOTS(7:9),3,1)];
end

epi_ymo_fvpvnv_TWTOTS = epi_rel_ymo_fvpvnv_TWTOTS.*repelem(pre_epi_bchmrkTWTOTSTH(1:9),3);


