clear
clc

tic

addpath('./subfunction/')

INPUTFILENAME = 'routeB_inputXML_0-1.xml';
y = ECS_routeB_AC_run_v11(INPUTFILENAME,'ON');

% BEIHW = ECS_routeB_HW_run_v1('IVa','��������','�������V�[�g.csv','����_�@��V�[�g.csv');

rmpath('./subfunction/')

toc