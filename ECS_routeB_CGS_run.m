% ECS_routeB_CGS_run.m
%                                          by Masato Miyata 2012/10/12
%----------------------------------------------------------------------
% �ȃG�l��F�R�W�F�l���[�V�����V�X�e���v�Z�v���O����
%----------------------------------------------------------------------
% ����
%  inputfilename : XML�t�@�C������
%  OutputOption  : �o�͐���iON: �ڍ׏o�́AOFF: �ȈՏo�́j
% �o��
%  y(1) : �ȃG�l���M�[�� [MJ/�N]
%----------------------------------------------------------------------
function y = ECS_routeB_CGS_run(inputfilename,OutputOption)

% clear
% clc
% inputfilename = './output.xml';
% addpath('./subfunction/')
% OutputOption = 'OFF';


%% �ݒ�
model = xml_read(inputfilename);

switch OutputOption
    case 'ON'
        OutputOptionVar = 1;
    case 'OFF'
        OutputOptionVar = 0;
    otherwise
        error('OutputOption���s���ł��BON �� OFF �Ŏw�肵�ĉ������B')
end


%% ���̒��o

% �V�X�e����
numOfSystem =  length(model.CogenerationSystems.CogenerationSet);

for iSYS = 1:numOfSystem
    
    % �N�ԓd�͎��v [MWh]
    DemandAC(iSYS)     = model.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_AC;
    DemandV(iSYS)      = model.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_V;
    DemandL(iSYS)      = model.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_L;
    DemandHW(iSYS)     = model.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_HW;
    DemandEV(iSYS)     = model.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_EV;
    DemandOthers(iSYS) = model.CogenerationSystems.CogenerationSet(iSYS).ATTRIBUTE.ElectricalDemand_Others;
    
    % �R�W�F�l���[�V�������j�b�g�̐�
    numOfUnit(iSYS) = length(model.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit);
    
    for iUNIT = 1:numOfUnit(iSYS)
        
        % ���d���� [-]
        effc(iSYS,iUNIT) = ...
            model.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.GeneratingEfficiency;
        % �r�M����� [-]
        effh(iSYS,iUNIT) = ...
            model.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.ExhaustHeatRecoveryRatio;
        % ���d�ˑ��� [-]
        a(iSYS,iUNIT) = ...
            model.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.ElectricalDependencyRatio;
        % �L���M���p�� [-]
        R(iSYS,iUNIT) = ...
            model.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.HeatUtilizationRatio;
        % �L���r�M�ʂ̗�M���p�� [-]
        alpha(iSYS,iUNIT) = ...
            model.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.RatioForCooling;
        % �����z���Ⓚ�@�܂��͔r�M�����^�≷���@�̐��ьW�� [-]
        COPgar(iSYS,iUNIT) = ...
            model.CogenerationSystems.CogenerationSet(iSYS).CogenerationUnit(iUNIT).ATTRIBUTE.RefrigeratorCOP;
        
    end
end


%% �N�ԑn�G�l���M�[�ʂ̌v�Z

Kele = 9760;     % �d�͂̈ꎟ�G�l���M�[���Z�l [kJ/kWh]
effboiler = 0.8; % �����{�C������ [-]
COPar = 1.0;     % �≷��������̗�M�������̐��ьW�� [-]

for iSYS = 1:numOfSystem
    
    % �N�ԓd�͎��v�� [MWh/�N]
    E = DemandAC(iSYS) + DemandV(iSYS) + DemandL(iSYS) + DemandHW(iSYS) + DemandEV(iSYS) + DemandOthers(iSYS);
    
    for iUNIT = 1:numOfUnit(iSYS)
        
        tmpA = 3600*a(iSYS,iUNIT)*E/effc(iSYS,iUNIT);
        tmpB = 9760*effc(iSYS,iUNIT)/3600;
        tmpC = R(iSYS,iUNIT)*effh(iSYS,iUNIT);
        tmpD = (1-alpha(iSYS,iUNIT))/effboiler + alpha(iSYS,iUNIT)*COPgar(iSYS,iUNIT)/COPar;
        
        % �ȃG�l���M�[�� [MJ/�N]
        Eper(iSYS,iUNIT) =  tmpA*(tmpB + tmpC*tmpD - 1);
        
    end
end

% �N�ԏȃG�l���M�[�ʍ��v [MJ/�N]
y = sum(sum(Eper));

