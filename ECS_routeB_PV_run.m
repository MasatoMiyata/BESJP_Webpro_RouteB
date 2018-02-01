% ECS_routeB_PV_run.m
%                                          by Masato Miyata 2012/10/12
%----------------------------------------------------------------------
% �ȃG�l��F���z�����d�v�Z�v���O����
%----------------------------------------------------------------------
% ����
%  inputfilename : XML�t�@�C������
%  OutputOption  : �o�͐���iON: �ڍ׏o�́AOFF: �ȈՏo�́j
% �o��
%  y(1) : �n�G�l���M�[�� [MJ/�N]
%----------------------------------------------------------------------
function y = ECS_routeB_PV_run(inputfilename,OutputOption)

% clear
% clc
% inputfilename = './model_routeB_sample01.xml';
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


%% �C�ۃf�[�^���ǂݍ���

% �f�[�^�x�[�X�ǂݍ���
mytscript_readDBfiles;

% �n��敪
climateAREA = num2str(model.ATTRIBUTE.Region);

check = 0;
for iDB = 1:length(perDB_climateArea(:,2))
    if strcmp(perDB_climateArea(iDB,1),climateAREA) || strcmp(perDB_climateArea(iDB,2),climateAREA)
        % �C�ۃf�[�^�t�@�C����
        eval(['climatedatafile  = ''./weathdat/C1_',perDB_climateArea{iDB,6},''';'])
        % �ܓx
        phi   = str2double(perDB_climateArea(iDB,4));
        % �o�x
        longi = str2double(perDB_climateArea(iDB,5));
        
        check = 1;
    end
end
if check == 0
    error('�n��敪���s���ł�')
end

% ���˃f�[�^�ǂݍ���(�O�C���A�@���ʒ��B���˗ʁA�����ʓV����˗ʁA�����ʖ�ԕ��˗�)
[ToutALL,~,IodALL,IosALL,InnALL] = mytfunc_climatedataRead(climatedatafile);


%% ���̒��o

% ���j�b�g��
numOfUnit =  length(model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration);

PV_Name = cell(numOfUnit,1);
PV_Type = cell(numOfUnit,1);
PV_InstallationMode = cell(numOfUnit,1);
PV_Capacity = zeros(numOfUnit,1);
PV_PanelDirection = zeros(numOfUnit,1);
PV_PanelAngle = zeros(numOfUnit,1);
PV_SolorIrradiationRegion = cell(numOfUnit,1);
PV_Info = cell(numOfUnit,1);

for iUNIT = 1:numOfUnit
    
    % ����
    PV_Name{iUNIT} = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Name;
    % ���z�d�r�̎��
    PV_Type{iUNIT} = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Type;
    % �A���C�ݒu����
    PV_InstallationMode{iUNIT} = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.InstallationMode;
    % �A���C�̃V�X�e���e��
    PV_Capacity(iUNIT) = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Capacity;
    % �p�l���̕��ʊp
    PV_PanelDirection(iUNIT) = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.PanelDirection;
    % �p�l���̌X�Ίp
    PV_PanelAngle(iUNIT) = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.PanelAngle;
    % �N�ԓ��˗ʒn��敪
    PV_SolorIrradiationRegion{iUNIT} = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.SolorIrradiationRegion;
    % ���l
    PV_Info{iUNIT} = ...
        model.PhotovoltaicGenerationSystems.PhotovoltaicGeneration(iUNIT).ATTRIBUTE.Info;
    
end


%% ���z�d�r�A���C�ɂ��N�Ԕ��d�ʂ̌v�Z

Ep = zeros(numOfUnit,1);

for iUNIT = 1:numOfUnit
    
    % ���z�d�r�A���C�̑����݌v�W�������߂�B
    
    switch PV_Type{iUNIT}
        case 'Crystalline'  % �����n
            Khd = 0.97; % ���˗ʔN�ϓ��␳�W��
            Khs = 1.0;  % ���A�␳�W��
            Kpd = 0.95; % �p���ω��␳�W��
            Kpa = 0.94; % �A���C���א����␳�W��
            Kpm = 0.97; % �A���C��H�␳�W��
            Kin = 0.90; % �C���o�[�^��H�␳�W��
            apmax = -0.41;  % �ő�o�͉��x�W��
        case 'NonCrystalline'  % �񌋏��n
            Khd = 0.97; % ���˗ʔN�ϓ��␳�W��
            Khs = 1.0;  % ���A�␳�W��
            Kpd = 0.87; % �p���ω��␳�W��
            Kpa = 0.94; % �A���C���א����␳�W��
            Kpm = 0.97; % �A���C��H�␳�W��
            Kin = 0.90; % �C���o�[�^��H�␳�W��
            apmax = -0.20;  % �ő�o�͉��x�W��
        otherwise
            error('���z�d�r�̎�ނ��s���ł�')
    end
    
    % ���W���[�����x�����߂邽�߂̌W�� Fa
    switch PV_InstallationMode{iUNIT}
        case 'RackMountType'  % �ˑ�ݒu�`
            Fa = 46;
        case 'RoomMountType'  % �����u���`
            Fa = 50;
        case 'Others'  % ���̑�
            Fa = 57;
        otherwise
            error('�A���C�ݒu�������s���ł�')
    end
    
    % �p�l���ɓ��˂�����˗ʂ����߂� : hourlyIds => (365�~24) [W/m2]
    [~,hourlyIds] = mytfunc_calcSolorRadiation(IodALL,IosALL,InnALL,phi,longi,...
        PV_PanelDirection(iUNIT),PV_PanelAngle(iUNIT),1);
    
    % ���z�d�r�A���C�̉��d���ϑ��z�d�r���W���[�����x Tcr(365�~24)
    Tcr = ToutALL + (Fa+2).*hourlyIds./1000 - 2;
    
    % ���z�d�r�A���C�̉��x�␳�W�� Kpt(365�~24)
    Kpt = 1 + apmax./100.*(Tcr-25);
    
    % ���z�d�r�A���C�̑����݌v�W�� Kp(365�~24)
    Kp = (Khd*Khs*Kpd*Kpa*Kpm*Kin)*ones(365,24) .* Kpt;
    
    % ���z�d�r�A���C�ɂ��N�Ԕ��d�� [MJ]
    Ep(iUNIT) =sum(sum( PV_Capacity(iUNIT)*ones(365,24) .* hourlyIds .* Kp * 3600*10^(-6) ));
    
end

% �N�ԑn�G�l���M�[�ʍ��v [MJ/�N]
y = sum(Ep);


