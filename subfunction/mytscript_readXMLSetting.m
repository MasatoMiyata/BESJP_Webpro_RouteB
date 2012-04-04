% mytfunc_readXMLSetting.m
%                                                  2011/01/01 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�ݒ�t�@�C���iXML�t�@�C���j��ǂݍ��ށB
%------------------------------------------------------------------------------

% XML�t�@�C���Ǎ���
INPUT = xml_read(INPUTFILENAME);

% Model�̑���
climateAREA  = INPUT.ATTRIBUTE.Region; % �n��敪
BuildingArea = INPUT.ATTRIBUTE.Area;   % �����ʐ� [m2]
BuildingType = INPUT.ATTRIBUTE.Type;   % �����p�r


%----------------------------------
% ���v�f�̃p�����[�^

numOfRooomEs = length(INPUT.Rooms.Room);
for iROOMEL = 1:numOfRooomEs
    roomElementName{iROOMEL}   = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.ID;     % ��ID
    roomElementType{iROOMEL}   = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.Type;   % ���p�r
    roomElementArea(iROOMEL)   = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.Area;   % ���ʐ�
    roomElementCount(iROOMEL)  = 1;  % ����
    roomElementFloorHeight(iROOMEL) = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.FloorHeight; % �K��
    roomElementHeight(iROOMEL) = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.Height; % ����
end
    
%----------------------------------
% �󒲎��̃p�����[�^
numOfRoooms = length(INPUT.AirConditioningSystem.AirConditioningRoom);
for iROOM = 1:numOfRoooms
    
    roomName{iROOM}   = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).ATTRIBUTE.ID;           % �󒲎�ID
    roomElements{iROOM}   = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).ATTRIBUTE.RoomIDs;  % ���̌Q�oa,b,c}
    EnvelopeRef{iROOM} = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).ATTRIBUTE.EnvelopeID;  % �O��ID
    
    % �󒲋@ID�@�������n���E���Ή���
    for iAHU = 1:2
        if strcmp(INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.Load,'Room')
            % �����ׂ���������󒲋@ID
            roomAHU_Qroom{iROOM} = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.ID;
        elseif strcmp(INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.Load,'OutsideAir')
            % �����ׂ���������󒲋@ID
            roomAHU_Qoa{iROOM} = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.ID;
        end
    end
    
end

%----------------------------------
% �O��
numOfENVs = length(INPUT.AirConditioningSystem.Envelope);
for iENV = 1:numOfENVs
    envelopeID{iENV} = INPUT.AirConditioningSystem.Envelope(iENV).ATTRIBUTE.ID;
    numOfWalls(iENV) = length(INPUT.AirConditioningSystem.Envelope(iENV).Wall);
    for iWALL = 1:numOfWalls(iENV)
        WallConfigure{iENV,iWALL} = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WallConfigure;  % �O�ǎ��
        WallArea(iENV,iWALL)      = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WallArea;       % �O��ʐ� [m2]
        WindowType{iENV,iWALL}    = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowType;     % �����
        WindowArea(iENV,iWALL)    = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowArea;     % ���ʐ� [m2]
        Direction{iENV,iWALL}     = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Direction;      % ����
    end
end


%----------------------------------
% �󒲋@�̃p�����[�^

numOfAHUs = length(INPUT.AirConditioningSystem.AirHandlingUnit);
for iAHU = 1:numOfAHUs
    
    ahuName{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.ID;    % �󒲋@ID
    ahuType{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Type;  % �󒲋@�^�C�v
    
    ahuCount(iAHU) = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Count;  % �䐔
    
    ahuQcmax(iAHU) = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.CoolingCapacity;  % ��i��[�\��
    ahuQhmax(iAHU) = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatingCapacity;  % ��i�g�[�\��
    ahuVsa(iAHU)   = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.SupplyAirVolume;  % ���C����
    ahuEfsa(iAHU)  = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.SupplyFanPower;   % ���C�t�@������d��
    ahuEfra(iAHU)  = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.ReturnFanPower;   % �ҋC�t�@������d��
    ahuEfoa(iAHU)  = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirFanPower;   % �O�C�t�@������d��
    
    ahuFlowControl{iAHU}       = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.FlowControl;           % ���ʐ���
    ahuMinDamperOpening(iAHU)  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.MinDamperOpening;      % VAV�ŏ��J�x
    ahuOACutCtrl{iAHU}         = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirCutControl;  % �O�C�J�b�g����
    ahuFreeCoolingCtrl{iAHU}   = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.FreeCoolingControl;    % �O�C��[����
    ahuHeatExchangeCtrl{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchanger;          % �S�M�����@����
    ahuHeatExchangeEff(iAHU)   = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerEfficiency;  % �S�M������
    ahuHeatExchangePower(iAHU) = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerPower;    % �S�M�𓮗�
    
    ahuRef_cooling{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).HeatSourceSetRef.ATTRIBUTE.CoolingID;  % �M���ڑ��i��[�j
    ahuRef_heating{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).HeatSourceSetRef.ATTRIBUTE.HeatingID;  % �M���ڑ��i�g�[�j
    ahuPump_cooling{iAHU} = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).SecondaryPumpRef.ATTRIBUTE.CoolingID;  % �|���v�ڑ��i��[�j
    ahuPump_heating{iAHU} = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).SecondaryPumpRef.ATTRIBUTE.HeatingID;  % �|���v�ڑ��i�g�[�j
    
end


%----------------------------------
% �|���v�̃p�����[�^
if isfield(INPUT.AirConditioningSystem,'SecondaryPump')
    numOfPumps = length(INPUT.AirConditioningSystem.SecondaryPump);
    for iPUMP = 1:numOfPumps
        pumpName{iPUMP}         = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.ID;          % �|���v����
        pumpMode{iPUMP}         = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Mode;        % �|���v�^�]���[�h
        pumpCount(iPUMP)        = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Count;       % �|���v�䐔
        pumpFlow(iPUMP)         = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedFlow;   % �|���v����
        pumpPower(iPUMP)        = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedPower;  % �|���v��i�d��
        pumpFlowCtrl{iPUMP}     = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.FlowControl; % �|���v���ʐ���
        pumpQuantityCtrl{iPUMP} = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.QuantityControl; % �|���v�䐔����
    end
else
    numOfPumps = 0;
end


%----------------------------------
% �M���̃p�����[�^

numOfRefs = length(INPUT.AirConditioningSystem.HeatSourceSet);
for iREF = 1:numOfRefs
    
    refsetID{iREF}           = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.ID;               % �M���Q����
    refsetMode{iREF}         = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.Mode;             % �^�]���[�h
    refsetStorage{iREF}      = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.ThermalStorage;   % �~�M����
    refsetQuantityCtrl{iREF} = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityControl;  % �䐔����
    
    refsetRnum(iREF) = length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource);  % �M���@��̐��i�ő�3�j
    for iREFSUB = 1:refsetRnum(iREF)
        if strcmp(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order,'First')
            refset_Count(iREF,1)       = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count;      % �䐔
            refset_Type{iREF,1}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
            refset_Capacity(iREF,1)    = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity;   % ��i�\��
            refset_MainPower(iREF,1)   = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower;  % ��i����G�l���M�[
            refset_SubPower(iREF,1)    = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower;   % ��i��@�d��
            refset_PrimaryPumpPower(iREF,1) = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower;  % �ꎟ�|���v��i�d��
            refset_CTCapacity(iREF,1)  = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity;  % ��p���\��
            refset_CTFanPower(iREF,1)  = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower;  % ��p���t�@���d��
            refset_CTPumpPower(iREF,1) = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower; % ��p��
        elseif strcmp(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order,'Second')
            refset_Count(iREF,2)       = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count;      % �䐔
            refset_Type{iREF,2}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
            refset_Capacity(iREF,2)    = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity;   % ��i�\��
            refset_MainPower(iREF,2)   = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower;  % ��i����G�l���M�[
            refset_SubPower(iREF,2)    = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower;   % ��i��@�d��
            refset_PrimaryPumpPower(iREF,2) = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower;  % �ꎟ�|���v��i�d��
            refset_CTCapacity(iREF,2)  = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity;  % ��p���\��
            refset_CTFanPower(iREF,2)  = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower;  % ��p���t�@���d��
            refset_CTPumpPower(iREF,2) = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower; % ��p��
        elseif strcmp(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order,'Third')
            refset_Count(iREF,3)       = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count;      % �䐔
            refset_Type{iREF,3}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
            refset_Capacity(iREF,3)    = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity;   % ��i�\��
            refset_MainPower(iREF,3)   = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower;  % ��i����G�l���M�[
            refset_SubPower(iREF,3)    = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower;   % ��i��@�d��
            refset_PrimaryPumpPower(iREF,3) = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower;  % �ꎟ�|���v��i�d��
            refset_CTCapacity(iREF,3)  = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity;  % ��p���\��
            refset_CTFanPower(iREF,3)  = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower;  % ��p���t�@���d��
            refset_CTPumpPower(iREF,3) = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower; % ��p��
        end
    end
    
end
