% �R�W�F�l�v�Z�p
clear
clc
tic

inputfilename = './InputFiles/1005_�R�W�F�l�e�X�g/model_CGS_case_hotel_01.xml';

addpath('./subfunction')

%% �v�Z���s

disp('��C���a�ݔ��̌v�Z�����s���D�D�D')
RES_AC = ECS_routeB_AC_run(inputfilename,'OFF','4','Calc','0');

toc

disp('�@�B���C�ݔ��̌v�Z�����s���D�D�D')
RES_V  = ECS_routeB_V_run(inputfilename,'OFF');

toc

disp('�Ɩ��ݔ��̌v�Z�����s���D�D�D')
RES_L  = ECS_routeB_L_run(inputfilename,'OFF');

toc

disp('�����ݔ��̌v�Z�����s���D�D�D')
RES_HW = ECS_routeB_HW_run(inputfilename,'OFF');

toc

disp('���~�@�̌v�Z�����s���D�D�D')
RES_EV = ECS_routeB_EV_run(inputfilename,'OFF');

toc

disp('���̑��G�l���M�[�̌v�Z�����s���D�D�D')
RES_OA = ECS_routeB_Others_run(inputfilename,'OFF');

toc

disp('�R�W�F�l�̌v�Z�����s���D�D�D')
y = ECS_routeB_CGSdetail_run(inputfilename,'OFF');
toc

% rmpath('./subfunction')
