% test_ECS_routeB_CGSdetail_run
%--------------------------------------------------------------------------
% �R�W�F�l�ڍהł̑����e�X�g
%--------------------------------------------------------------------------
% ���s�F
%�@results = runtests('test_ECS_routeB_CGSdetail_run.m');
%--------------------------------------------------------------------------

function tests = test_ECS_routeB_CGSdetail_run

    tests = functiontests(localfunctions);

end

% �z�e���P�[�X0
function testCase00(testCase)

% ������
load ./test/test_Hotel_Case00.mat inputdata

% ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
EAC_total_d = inputdata(:,1);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_c_d = inputdata(:,2);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
mxLAC_ref_c_d = inputdata(:,3);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_h_hr_d = inputdata(:,4);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
qAC_ref_h_hr_d = inputdata(:,5);
% ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
EV_total_d = inputdata(:,6);
% ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
EL_total_d = inputdata(:,7);
% ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
EW_total_d = inputdata(:,8);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
EW_hr_d = inputdata(:,9);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
qW_hr_d = inputdata(:,10);
% ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
EEV_total_d = inputdata(:,11);
% ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
EPV_total_d = inputdata(:,12);
% ���td�ɂ����邻�̑��̓d�͏����	MWh/��
EM_total_d = inputdata(:,13);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
TAC_c_d = inputdata(:,14);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
TAC_h_d = inputdata(:,15);


% CGS�̔��d�@�e��	kW
Ecgs_rated = 150;
% CGS�ݒu�䐔	��
Ncgs = 2;
% CGS�̒�i���d����(��ʔ��M�ʊ)	������
fcgs_e_rated = 0.336;
% CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
fcgs_e_75 = 0.325;
% CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
fcgs_e_50 = 0.292;
% CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
fcgs_hr_rated = 0.507;
% CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_75 = 0.518;
% CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_50 = 0.546;
% �r�M���p�D�揇��(��M��)�@��1	������
npri_hr_c = 3;
% �r�M���p�D�揇��(���M��) �@��1	������
npri_hr_h = 2;
% �r�M���p�D�揇��(����) �@��1	������
npri_hr_w = 1;
% CGS24���ԉ^�]�̗L���@��2	-
C24ope = 0;
% �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
qAC_link_c_j_rated = 617.22;
% �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
EAC_link_c_j_rated = 561.21;
% CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
NAC_ref_link = 3;

% �����̉^�p���ԑтƔ�^�p���ԑт̕��ϓd�͍�	������
feopeHi = 10;

% ���s
y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
    EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
    qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
    Ecgs_rated,Ncgs,fcgs_e_rated,...
    fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
    npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
    EAC_link_c_j_rated,NAC_ref_link,feopeHi);

actSolution = y;
% �G�N�Z���v���O�������
expSolution = [10220,0.62,955.72,5864.56,12386.55,27.78,47.35,901.62,5337.73,69.30,8799.80,934.24,1117.64,4621.61,3086.74];

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.01)

end

% �z�e���P�[�X1
function testCase01(testCase)

% ������
load ./test/test_Hotel_Case01.mat inputdata

% ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
EAC_total_d = inputdata(:,1);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_c_d = inputdata(:,2);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
mxLAC_ref_c_d = inputdata(:,3);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_h_hr_d = inputdata(:,4);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
qAC_ref_h_hr_d = inputdata(:,5);
% ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
EV_total_d = inputdata(:,6);
% ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
EL_total_d = inputdata(:,7);
% ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
EW_total_d = inputdata(:,8);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
EW_hr_d = inputdata(:,9);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
qW_hr_d = inputdata(:,10);
% ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
EEV_total_d = inputdata(:,11);
% ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
EPV_total_d = inputdata(:,12);
% ���td�ɂ����邻�̑��̓d�͏����	MWh/��
EM_total_d = inputdata(:,13);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
TAC_c_d = inputdata(:,14);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
TAC_h_d = inputdata(:,15);


% CGS�̔��d�@�e��	kW
Ecgs_rated = 50;
% CGS�ݒu�䐔	��
Ncgs = 6;
% CGS�̒�i���d����(��ʔ��M�ʊ)	������
fcgs_e_rated = 0.336;
% CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
fcgs_e_75 = 0.325;
% CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
fcgs_e_50 = 0.292;
% CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
fcgs_hr_rated = 0.507;
% CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_75 = 0.518;
% CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_50 = 0.546;
% �r�M���p�D�揇��(��M��)�@��1	������
npri_hr_c = 3;
% �r�M���p�D�揇��(���M��) �@��1	������
npri_hr_h = 2;
% �r�M���p�D�揇��(����) �@��1	������
npri_hr_w = 1;
% CGS24���ԉ^�]�̗L���@��2	-
C24ope = 0;
% �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
qAC_link_c_j_rated = 617.22;
% �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
EAC_link_c_j_rated = 561.21;
% CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
NAC_ref_link = 3;

% �����̉^�p���ԑтƔ�^�p���ԑт̕��ϓd�͍�	������
feopeHi = 10;

% ���s
y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
    EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
    qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
    Ecgs_rated,Ncgs,fcgs_e_rated,...
    fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
    npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
    EAC_link_c_j_rated,NAC_ref_link,feopeHi);

actSolution = y;
% �G�N�Z���v���O�������iinputSheet_Ver2.5_20180206_01������CGS.xlsm�j
expSolution = [21056,0.90,946.70,5198.42,11422.75,29.84,45.51,901.62,4903.43,71.34,8799.80,826.09,775.89,4621.61,3600.64];

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.01)

end

% �z�e���P�[�X1
function testCase02(testCase)

% ������
load ./test/test_Hotel_Case02.mat inputdata

% ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
EAC_total_d = inputdata(:,1);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_c_d = inputdata(:,2);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
mxLAC_ref_c_d = inputdata(:,3);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_h_hr_d = inputdata(:,4);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
qAC_ref_h_hr_d = inputdata(:,5);
% ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
EV_total_d = inputdata(:,6);
% ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
EL_total_d = inputdata(:,7);
% ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
EW_total_d = inputdata(:,8);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
EW_hr_d = inputdata(:,9);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
qW_hr_d = inputdata(:,10);
% ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
EEV_total_d = inputdata(:,11);
% ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
EPV_total_d = inputdata(:,12);
% ���td�ɂ����邻�̑��̓d�͏����	MWh/��
EM_total_d = inputdata(:,13);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
TAC_c_d = inputdata(:,14);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
TAC_h_d = inputdata(:,15);


% CGS�̔��d�@�e��	kW
Ecgs_rated = 300;
% CGS�ݒu�䐔	��
Ncgs = 1;
% CGS�̒�i���d����(��ʔ��M�ʊ)	������
fcgs_e_rated = 0.336;
% CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
fcgs_e_75 = 0.325;
% CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
fcgs_e_50 = 0.292;
% CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
fcgs_hr_rated = 0.507;
% CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_75 = 0.518;
% CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_50 = 0.546;
% �r�M���p�D�揇��(��M��)�@��1	������
npri_hr_c = 3;
% �r�M���p�D�揇��(���M��) �@��1	������
npri_hr_h = 2;
% �r�M���p�D�揇��(����) �@��1	������
npri_hr_w = 1;
% CGS24���ԉ^�]�̗L���@��2	-
C24ope = 0;
% �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
qAC_link_c_j_rated = 617.22;
% �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
EAC_link_c_j_rated = 561.21;
% CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
NAC_ref_link = 3;

% �����̉^�p���ԑтƔ�^�p���ԑт̕��ϓd�͍�	������
feopeHi = 10;

% ���s
y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
    EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
    qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
    Ecgs_rated,Ncgs,fcgs_e_rated,...
    fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
    npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
    EAC_link_c_j_rated,NAC_ref_link,feopeHi);

actSolution = y;
% �G�N�Z���v���O�������iinputSheet_Ver2.5_20180206_01������CGS.xlsm�j
expSolution = [4788,0.62,894.91,5492.94,11600.61,27.77,47.35,844.25,5093.61,70.11,8239.91,881.43,1078.64,4382.22,2981.59];

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.01)

end

% ������
function testCase03(testCase)

% ������
load ./test/test_Office_Case03.mat inputdata

% ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
EAC_total_d = inputdata(:,1);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_c_d = inputdata(:,2);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
mxLAC_ref_c_d = inputdata(:,3);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
EAC_ref_h_hr_d = inputdata(:,4);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
qAC_ref_h_hr_d = inputdata(:,5);
% ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
EV_total_d = inputdata(:,6);
% ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
EL_total_d = inputdata(:,7);
% ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
EW_total_d = inputdata(:,8);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
EW_hr_d = inputdata(:,9);
% ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
qW_hr_d = inputdata(:,10);
% ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
EEV_total_d = inputdata(:,11);
% ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
EPV_total_d = inputdata(:,12);
% ���td�ɂ����邻�̑��̓d�͏����	MWh/��
EM_total_d = inputdata(:,13);
% ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
TAC_c_d = inputdata(:,14);
% ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
TAC_h_d = inputdata(:,15);


% CGS�̔��d�@�e��	kW
Ecgs_rated = 200;
% CGS�ݒu�䐔	��
Ncgs = 1;
% CGS�̒�i���d����(��ʔ��M�ʊ)	������
fcgs_e_rated = 0.236;
% CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
fcgs_e_75 = 0.225;
% CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
fcgs_e_50 = 0.192;
% CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
fcgs_hr_rated = 0.507;
% CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_75 = 0.518;
% CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
fcgs_hr_50 = 0.546;
% �r�M���p�D�揇��(��M��)�@��1	������
npri_hr_c = 3;
% �r�M���p�D�揇��(���M��) �@��1	������
npri_hr_h = 2;
% �r�M���p�D�揇��(����) �@��1	������
npri_hr_w = 1;
% CGS24���ԉ^�]�̗L���@��2	-
C24ope = 0;
% �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
qAC_link_c_j_rated = 1093.5;
% �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
EAC_link_c_j_rated = 994.08;
% CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
NAC_ref_link = 3;

% �����̉^�p���ԑтƔ�^�p���ԑт̕��ϓd�͍�	������
feopeHi = 10;

% ���s
y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
    EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
    qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
    Ecgs_rated,Ncgs,fcgs_e_rated,...
    fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
    npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
    EAC_link_c_j_rated,NAC_ref_link,feopeHi);

actSolution = y;
% �G�N�Z���v���O�������iinputSheet_Ver2.5_20180206_01������CGS.xlsm�j
expSolution = [2030	1.00	406.00	3139.96	6933.76	21.08	45.29	383.02	2688.68	58.66	3738.26	1825.42	10.91	0.00	-1359.17];

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.01)

end

% 
% function testCase01(testCase)
% 
% % ������
% load ./test/testCase01.mat inputdata
% 
% % ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
% EAC_total_d = inputdata(:,1);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_c_d = inputdata(:,2);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
% mxLAC_ref_c_d = inputdata(:,3);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_h_hr_d = inputdata(:,4);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
% qAC_ref_h_hr_d = inputdata(:,5);
% % ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
% EV_total_d = inputdata(:,6);
% % ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
% EL_total_d = inputdata(:,7);
% % ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
% EW_total_d = inputdata(:,8);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
% EW_hr_d = inputdata(:,9);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
% qW_hr_d = inputdata(:,10);
% % ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
% EEV_total_d = inputdata(:,11);
% % ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
% EPV_total_d = inputdata(:,12);
% % ���td�ɂ����邻�̑��̓d�͏����	MWh/��
% EM_total_d = inputdata(:,13);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
% TAC_c_d = inputdata(:,14);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
% TAC_h_d = inputdata(:,15);
% 
% 
% % CGS�̔��d�@�e��	kW
% Ecgs_rated = 200;
% % CGS�ݒu�䐔	��
% Ncgs = 1;
% % CGS�̒�i���d����(��ʔ��M�ʊ)	������
% fcgs_e_rated = 0.336;
% % CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
% fcgs_e_75 = 0.325;
% % CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
% fcgs_e_50 = 0.292;
% % CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_rated = 0.507;
% % CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_75 = 0.518;
% % CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_50 = 0.546;
% % �r�M���p�D�揇��(��M��)�@��1	������
% npri_hr_c = 2;
% % �r�M���p�D�揇��(���M��) �@��1	������
% npri_hr_h = 1;
% % �r�M���p�D�揇��(����) �@��1	������
% npri_hr_w = 0;
% % CGS24���ԉ^�]�̗L���@��2	-
% C24ope = 0;
% % �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% qAC_link_c_j_rated = 1093.5;
% % �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% EAC_link_c_j_rated = 994.08;
% % CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
% NAC_ref_link = 3;
% 
% % �����̉^�p���ԑтƔ�^�p���ԑт̕��ϓd�͍�	������
% feopeHi = 10;
% 
% % ���s
% y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
%     EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
%     qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
%     Ecgs_rated,Ncgs,fcgs_e_rated,...
%     fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
%     npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
%     EAC_link_c_j_rated,NAC_ref_link,feopeHi);
% 
% actSolution = y;
% % �G�N�Z���v���O�������iinputSheet_Ver2.5_20180206_01������CGS.xlsm�j
% expSolution = [2044,1.00,408.80,2220.66,4903.73,30.01,45.29,385.66,2090.54,70.94,3764.05,1412.23,21.81,0.00,294.36];
% 
% % ����
% verifyEqual(testCase,actSolution,expSolution,'RelTol',0.01)
% 
% end
% 
% 
% function testCase02(testCase)
% 
% load ./test/testCase02.mat inputdata
% 
% % ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
% EAC_total_d = inputdata(:,1);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_c_d = inputdata(:,2);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
% mxLAC_ref_c_d = inputdata(:,3);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_h_hr_d = inputdata(:,4);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
% qAC_ref_h_hr_d = inputdata(:,5);
% % ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
% EV_total_d = inputdata(:,6);
% % ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
% EL_total_d = inputdata(:,7);
% % ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
% EW_total_d = inputdata(:,8);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
% EW_hr_d = inputdata(:,9);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
% qW_hr_d = inputdata(:,10);
% % ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
% EEV_total_d = inputdata(:,11);
% % ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
% EPV_total_d = inputdata(:,12);
% % ���td�ɂ����邻�̑��̓d�͏����	MWh/��
% EM_total_d = inputdata(:,13);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
% TAC_c_d = inputdata(:,14);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
% TAC_h_d = inputdata(:,15);
% 
% 
% % CGS�̔��d�@�e��	kW
% Ecgs_rated = 150;
% % CGS�ݒu�䐔	��
% Ncgs = 2;
% % CGS�̒�i���d����(��ʔ��M�ʊ)	������
% fcgs_e_rated = 0.336;
% % CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
% fcgs_e_75 = 0.325;
% % CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
% fcgs_e_50 = 0.292;
% % CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_rated = 0.507;
% % CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_75 = 0.518;
% % CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_50 = 0.546;
% % �r�M���p�D�揇��(��M��)�@��1	������
% npri_hr_c = 3;
% % �r�M���p�D�揇��(���M��) �@��1	������
% npri_hr_h = 2;
% % �r�M���p�D�揇��(����) �@��1	������
% npri_hr_w = 1;
% % CGS24���ԉ^�]�̗L���@��2	-
% C24ope = 0;
% % �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% qAC_link_c_j_rated = 205.74*3;
% % �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% EAC_link_c_j_rated = 187.07*3;
% % CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
% NAC_ref_link = 3;
% 
% feopeHi = 10;
% 
% % ���s
% y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
%     EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
%     qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
%     Ecgs_rated,Ncgs,fcgs_e_rated,...
%     fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
%     npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
%     EAC_link_c_j_rated,NAC_ref_link,feopeHi);
% 
% actSolution = y;
% expSolution = [10220,0.62,956.08,5865.88,12389.96,27.78,47.34,901.96,5344.77,69.35,8803.13,941.10,1110.00,4621.61,3085.87];
% 
% % ����
% verifyEqual(testCase,actSolution,expSolution,'RelTol',0.01)
% 
% end
% 
% 
% function testCase03(testCase)
% 
% % 
% load ./test/testCase03.mat inputdata
% 
% % ���td�ɂ������C���a�ݔ��̓d�͏����	MWh/��
% EAC_total_d = inputdata(:,1);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_c_d = inputdata(:,2);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̗�M���Ƃ��Ă̕��ח� 	������
% mxLAC_ref_c_d = inputdata(:,3);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̎�@�̈ꎟ�G�l���M�[�����	MJ/��
% EAC_ref_h_hr_d = inputdata(:,4);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̔M������	MJ/��
% qAC_ref_h_hr_d = inputdata(:,5);
% % ���td�ɂ�����@�B���C�ݔ��̓d�͏����	MWh/��
% EV_total_d = inputdata(:,6);
% % ���td�ɂ�����Ɩ��ݔ��̓d�͏����	MWh/��
% EL_total_d = inputdata(:,7);
% % ���td�ɂ����鋋���ݔ��̓d�͏����	MWh/��
% EW_total_d = inputdata(:,8);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̈ꎟ�G�l���M�[�����	MJ/��
% EW_hr_d = inputdata(:,9);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȋ����@(�n��)�̋�������	MJ/��
% qW_hr_d = inputdata(:,10);
% % ���td�ɂ����鏸�~�@�̓d�͏����	MWh/��
% EEV_total_d = inputdata(:,11);
% % ���td�ɂ�����������ݔ��i���z�����d�j�̔��d��	MWh/��
% EPV_total_d = inputdata(:,12);
% % ���td�ɂ����邻�̑��̓d�͏����	MWh/��
% EM_total_d = inputdata(:,13);
% % ���td�ɂ�����CGS�̔r�M���p���\�Ȕr�M�����^�z�����≷���@(�n��)�̉^�]����	h/��
% TAC_c_d = inputdata(:,14);
% % ���td�ɂ�����CGS�̔r�M���p���\�ȉ��M���Q�̉^�]����	h/��
% TAC_h_d = inputdata(:,15);
% 
% 
% % CGS�̔��d�@�e��	kW
% Ecgs_rated = 370;
% % CGS�ݒu�䐔	��
% Ncgs = 1;
% % CGS�̒�i���d����(��ʔ��M�ʊ)	������
% fcgs_e_rated = 0.405;
% % CGS�̕��ח�0.75�����d����(��ʔ��M�ʊ)	������
% fcgs_e_75 = 0.39;
% % CGS�̕��ח�0.50�����d����(��ʔ��M�ʊ)	������
% fcgs_e_50 = 0.349;
% % CGS�̒�i�r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_rated = 0.332;
% % CGS�̕��ח�0.75���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_75 = 0.337;
% % CGS�̕��ח�0.50���r�M����(��ʔ��M�ʊ)	������
% fcgs_hr_50 = 0.369;
% % �r�M���p�D�揇��(��M��)�@��1	������
% npri_hr_c = 3;
% % �r�M���p�D�揇��(���M��) �@��1	������
% npri_hr_h = 2;
% % �r�M���p�D�揇��(����) �@��1	������
% npri_hr_w = 1;
% % CGS24���ԉ^�]�̗L���@��2	-
% C24ope = 0;
% % �r�M�����^�z�����≷���@j�̒�i��p�\��	��W/��@�i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% qAC_link_c_j_rated = 1613.7;
% % �r�M�����^�z�����≷���@j�̎�@��i����G�l���M�[	��W/��i���s��ɂ��ׂ��H 3.3�Q�Ɓj
% EAC_link_c_j_rated = 1467;
% % CGS�̔r�M���p���\�Ȍn���ɂ���r�M�����^�z�����≷���@�̑䐔	��
% NAC_ref_link = 2;
% 
% feopeHi = 10;
% 
% 
% % ���s
% y = ECS_routeB_CGSdetail_run( EAC_total_d,EAC_ref_c_d,mxLAC_ref_c_d,...
%     EAC_ref_h_hr_d,qAC_ref_h_hr_d,EV_total_d,EL_total_d,EW_total_d,EW_hr_d,....
%     qW_hr_d,EEV_total_d,EPV_total_d,EM_total_d,TAC_c_d,TAC_h_d,...
%     Ecgs_rated,Ncgs,fcgs_e_rated,...
%     fcgs_e_75,fcgs_e_50,fcgs_hr_rated,fcgs_hr_75,fcgs_hr_50,...
%     npri_hr_c,npri_hr_h,npri_hr_w,C24ope,qAC_link_c_j_rated,...
%     EAC_link_c_j_rated,NAC_ref_link,feopeHi);
% 
% actSolution = y;
% expSolution = [5110,0.96,1815.56,5385.11,18142.97,36.03,29.68,1712.79,5223.55,62.78,16716.88,821.70,893.42,5062.39,5351.42];
% 
% % ����
% verifyEqual(testCase,actSolution,expSolution,'RelTol',0.01)
% 
% end
% 





