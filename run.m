% XML�쐬����G�l���M�[�v�Z�܂ł���C�Ɏ��s����X�N���v�g
clear
clc
tic

xmlfilename = 'csv2xml_config.xml';
region = 'IVb';


addpath('./subfunction')
addpath('./XMLfileMake')

% XML�쐬
copyfile(xmlfilename,'./XMLfileMake/csv2xml_config.xml')
mytfunc_csv2xml_run('output.xml',region);

% �v�Z���s
RES = ECS_routeB_run('output.xml');

rmpath('./subfunction')
rmpath('./XMLfileMake')