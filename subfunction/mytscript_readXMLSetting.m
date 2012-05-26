% mytfunc_readXMLSetting.m
%                                                  2011/04/16 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�ݒ�t�@�C���iXML�t�@�C���j��ǂݍ��ށB
%------------------------------------------------------------------------------

% XML�t�@�C���Ǎ���
INPUT = xml_read(INPUTFILENAME);

% Model�̑���
climateAREA  = INPUT.ATTRIBUTE.Region;     % �n��敪
BuildingArea = INPUT.ATTRIBUTE.TotalArea;  % �����ʐ� [m2]
    
%----------------------------------
% �󒲃]�[���̃p�����[�^
numOfRoooms    = length(INPUT.AirConditioningSystem.AirConditioningZone);

roomID          = cell(1,numOfRoooms);
roomFloor       = cell(1,numOfRoooms);
roomName        = cell(1,numOfRoooms);
EnvelopeRef     = cell(1,numOfRoooms);
roomAHU_Qroom   = cell(1,numOfRoooms);
roomAHU_Qoa     = cell(1,numOfRoooms);
buildingType    = cell(1,numOfRoooms);
roomType        = cell(1,numOfRoooms);
roomArea        = zeros(1,numOfRoooms);
roomFloorHeight = zeros(1,numOfRoooms);
roomHeight      = zeros(1,numOfRoooms);

for iZONE = 1:numOfRoooms
    
    roomID{iZONE}       = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ID;        % �󒲎�ID
    roomFloor{iZONE}    = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ACZoneFloor; % �K
    roomName{iZONE}     = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ACZoneName;  % ����
    
    EnvelopeRef{iZONE}  = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ID;  % �O��ID
    
    % �����p�r�A���p�r�A�K���A�V�䍂
    buildingType{iZONE} = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(1).ATTRIBUTE.BuildingType;
    roomType{iZONE}     = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(1).ATTRIBUTE.RoomType;
    roomFloorHeight(iZONE)  = mytfunc_null2value(INPUT.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(1).ATTRIBUTE.FloorHeight,NaN);
    roomHeight(iZONE)   = mytfunc_null2value(INPUT.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(1).ATTRIBUTE.RoomHeight,NaN);
    
    % �]�[���̏��ʐύ��v�l
    tmpRoomArea = 0;
    for iROOM = 1:length(INPUT.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef)
        tmpRoomArea = tmpRoomArea + mytfunc_null2value(INPUT.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(iROOM).ATTRIBUTE.RoomArea,NaN);
    end
    roomArea(iZONE) = tmpRoomArea;
    
    % �󒲋@ID
    for iAHU = 1:2
        if strcmp(INPUT.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(iAHU).ATTRIBUTE.Load,'Room')
            % �����ׂ���������󒲋@ID
            roomAHU_Qroom{iZONE} = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(iAHU).ATTRIBUTE.ID;
        elseif strcmp(INPUT.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(iAHU).ATTRIBUTE.Load,'OutsideAir')
            % �O�C���ׂ���������󒲋@ID
            roomAHU_Qoa{iZONE} = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(iAHU).ATTRIBUTE.ID;
        end
    end
    
end


%----------------------------------
% �O��
numOfENVs = length(INPUT.AirConditioningSystem.Envelope);

envelopeID    = cell(1,numOfENVs);
numOfWalls    = zeros(1,numOfENVs);
WallConfigure = cell(1,numOfENVs);
WallArea      = zeros(1,numOfENVs);
WindowType    = cell(1,numOfENVs);
WindowArea    = zeros(1,numOfENVs);
Direction     = cell(1,numOfENVs);
Blind         = cell(1,numOfENVs);
Eaves         = cell(1,numOfENVs);

for iENV = 1:numOfENVs
    envelopeID{iENV} = INPUT.AirConditioningSystem.Envelope(iENV).ATTRIBUTE.ACZoneID;
    numOfWalls(iENV) = length(INPUT.AirConditioningSystem.Envelope(iENV).Wall);
    for iWALL = 1:numOfWalls(iENV)
        WallConfigure{iENV,iWALL} = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WallConfigure;  % �O�ǎ��
        WallArea(iENV,iWALL)      = mytfunc_null2value(INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WallArea,0);  % �O��ʐ� [m2]
        WindowType{iENV,iWALL}    = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowType;     % �����
        WindowArea(iENV,iWALL)    = mytfunc_null2value(INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowArea,0); % ���ʐ� [m2]
        Direction{iENV,iWALL}     = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Direction;      % ����
        Blind{iENV,iWALL}         = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Blind;          % �u���C���h
        Eaves{iENV,iWALL}         = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Eaves;          % ��
    end
end


%----------------------------------
% �󒲋@�̃p�����[�^
numOfAHUsTemp = length(INPUT.AirConditioningSystem.AirHandlingUnit);

ahueleID    = cell(1,numOfAHUsTemp);
ahueleName  = cell(1,numOfAHUsTemp);
ahueleType  = cell(1,numOfAHUsTemp);
ahueleCount = zeros(1,numOfAHUsTemp);
ahueleQcmax = zeros(1,numOfAHUsTemp);
ahueleQhmax = zeros(1,numOfAHUsTemp);
ahueleVsa   = zeros(1,numOfAHUsTemp);
ahueleEfsa  = zeros(1,numOfAHUsTemp);
ahueleEfra  = zeros(1,numOfAHUsTemp);
ahueleEfoa  = zeros(1,numOfAHUsTemp);
ahueleEfex  = zeros(1,numOfAHUsTemp);
ahueleFlowControl        = cell(1,numOfAHUsTemp);
ahueleMinDamperOpening   = zeros(1,numOfAHUsTemp);
ahueleOACutCtrl          = cell(1,numOfAHUsTemp);
ahueleFreeCoolingCtrl    = cell(1,numOfAHUsTemp);
ahueleHeatExchangeCtrl   = cell(1,numOfAHUsTemp);
ahueleHeatExchangeEff    = zeros(1,numOfAHUsTemp);
ahueleHeatExchangePower  = zeros(1,numOfAHUsTemp);
ahueleHeatExchangeVolume = zeros(1,numOfAHUsTemp);
ahueleHeatExchangeBypass = cell(1,numOfAHUsTemp);
ahueleRef_cooling  = cell(1,numOfAHUsTemp);
ahueleRef_heating  = cell(1,numOfAHUsTemp);
ahuelePump_cooling = cell(1,numOfAHUsTemp);
ahuelePump_heating = cell(1,numOfAHUsTemp);

for iAHU = 1:numOfAHUsTemp
    
    ahueleID{iAHU}    = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.ID;    % �󒲋@ID
%     ahueleName{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Name;    % �󒲋@ID
    ahueleType{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Type;  % �󒲋@�^�C�v
    
    ahueleCount(iAHU) = mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Count,1);  % �䐔
    
    ahueleQcmax(iAHU) = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.CoolingCapacity,0);  % ��i��[�\��
    ahueleQhmax(iAHU) = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatingCapacity,0);  % ��i�g�[�\��
    ahueleVsa(iAHU)   = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.SupplyAirVolume,0);  % ���C����
    ahueleEfsa(iAHU)  = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.SupplyFanPower,0);   % ���C�t�@������d��
    ahueleEfra(iAHU)  = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.ReturnFanPower,0);   % �ҋC�t�@������d��
    ahueleEfoa(iAHU)  = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirFanPower,0);   % �O�C�t�@������d��
    ahueleEfex(iAHU)  = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.ExitFanPower,0);     % �r�C�t�@������d��
        
    ahueleFlowControl{iAHU}        = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.FlowControl;            % ���ʐ���
    ahueleMinDamperOpening(iAHU)   = mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.MinDamperOpening,1);       % VAV�ŏ��J�x
    ahueleOACutCtrl{iAHU}          = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirCutControl;   % �O�C�J�b�g����
    ahueleFreeCoolingCtrl{iAHU}    = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.FreeCoolingControl;     % �O�C��[����
    
    ahueleHeatExchangeCtrl{iAHU}   = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchanger;          % �S�M�����@����
    ahueleHeatExchangeBypass{iAHU} = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerBypass;    % �S�M���o�C�p�X�L��

    ahueleHeatExchangeEff(iAHU)    = mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerEfficiency,0);  % �S�M������
    ahueleHeatExchangePower(iAHU)  = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerPower,0);     % �S�M�𓮗�
    ahueleHeatExchangeVolume(iAHU) = ahueleCount(iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerVolume,0);    % �S�M�𕗗�
    
    ahueleRef_cooling{iAHU}  = strcat(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).HeatSourceSetRef.ATTRIBUTE.CoolingID,'_C');  % �M���ڑ��i��[�j
    ahueleRef_heating{iAHU}  = strcat(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).HeatSourceSetRef.ATTRIBUTE.HeatingID,'_H');  % �M���ڑ��i�g�[�j
    ahuelePump_cooling{iAHU} = strcat(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).SecondaryPumpRef.ATTRIBUTE.CoolingID,'_C');  % �|���v�ڑ��i��[�j
    ahuelePump_heating{iAHU} = strcat(INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).SecondaryPumpRef.ATTRIBUTE.HeatingID,'_H');  % �|���v�ڑ��i�g�[�j
    
end


%----------------------------------
% �|���v�̃p�����[�^
if isfield(INPUT.AirConditioningSystem,'SecondaryPump')
    
    numOfPumps       = 2*length(INPUT.AirConditioningSystem.SecondaryPump);
    pumpName         = cell(1,numOfPumps);
    pumpSystem       = cell(1,numOfPumps);
    pumpMode         = cell(1,numOfPumps);
    pumpCount        = zeros(1,numOfPumps);
    pumpFlow         = zeros(1,numOfPumps);
    pumpPower        = zeros(1,numOfPumps);
    pumpFlowCtrl     = cell(1,numOfPumps);
    pumpQuantityCtrl = cell(1,numOfPumps);
    pumpdelT         = zeros(1,numOfPumps);
    pumpMinValveOpening = zeros(1,numOfPumps);
    
    for iPUMP = 1:numOfPumps/2
                
        % �␅�|���v
        pumpMode{2*iPUMP-1}         = 'Cooling';        % �|���v�^�]���[�h
        pumpName{2*iPUMP-1}         = strcat(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Name,'_C');            % �|���v����
        pumpSystem{2*iPUMP-1}       = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.System;          % �|���v�V�X�e��
        pumpCount(2*iPUMP-1)        = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Count,0);           % �|���v�䐔
        pumpFlow(2*iPUMP-1)         = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedFlow,0);       % �|���v����
        pumpPower(2*iPUMP-1)        = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedPower,0);      % �|���v��i�d��
        pumpFlowCtrl{2*iPUMP-1}     = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.FlowControl;     % �|���v���ʐ���
        pumpQuantityCtrl{2*iPUMP-1} = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.QuantityControl; % �|���v�䐔����
        pumpdelT(2*iPUMP-1)         = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.deltaTemp_Cooling,5);     % �|���v�݌v���x���i��[�j
        pumpMinValveOpening(2*iPUMP-1)  = 0.3;
        
        % �����|���v
        pumpMode{2*iPUMP}           = 'Heating';        % �|���v�^�]���[�h
        pumpName{2*iPUMP}           = strcat(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Name,'_H');            % �|���v����
        pumpSystem{2*iPUMP}         = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.System;          % �|���v�V�X�e��
        pumpCount(2*iPUMP)          = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Count,0);           % �|���v�䐔
        pumpFlow(2*iPUMP)           = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedFlow,0);       % �|���v����
        pumpPower(2*iPUMP)          = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedPower,0);      % �|���v��i�d��
        pumpFlowCtrl{2*iPUMP}       = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.FlowControl;     % �|���v���ʐ���
        pumpQuantityCtrl{2*iPUMP}   = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.QuantityControl; % �|���v�䐔����
        pumpdelT(2*iPUMP)           = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.deltaTemp_Heating,5);     % �|���v�݌v���x���i�g�[�j
        pumpMinValveOpening(2*iPUMP) = 0.3;
                
    end
else
    numOfPumps = 0;
end


%----------------------------------
% �M���̃p�����[�^

numOfRefs = 2*length(INPUT.AirConditioningSystem.HeatSourceSet);

refsetID           = cell(1,numOfRefs);
refsetMode         = cell(1,numOfRefs);
refsetSupplyMode   = cell(1,numOfRefs);
refsetStorage      = cell(1,numOfRefs);
refsetQuantityCtrl = cell(1,numOfRefs);
refsetRnum         = zeros(1,numOfRefs);
refset_Count       = zeros(numOfRefs,3);
refset_Type        = cell(numOfRefs,3);
refset_Capacity    = zeros(numOfRefs,3);
refset_MainPower   = zeros(numOfRefs,3);
refset_SubPower    = zeros(numOfRefs,3);
refset_PrimaryPumpPower = zeros(numOfRefs,3);
refset_CTCapacity       = zeros(numOfRefs,3);
refset_CTFanPower       = zeros(numOfRefs,3);
refset_CTPumpPower      = zeros(numOfRefs,3);
refsetSupplyTemp   = zeros(1,numOfRefs);

for iREF = 1:numOfRefs/2
    
    refsetMode{2*iREF-1}         = 'Cooling';             % �^�]���[�h
    refsetMode{2*iREF}           = 'Heating';             % �^�]���[�h
    refsetID{2*iREF-1}           = strcat(INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.Name,'_C');  % �M���Q����
    refsetID{2*iREF}             = strcat(INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.Name,'_H');  % �M���Q����
    refsetSupplyMode{2*iREF-1}   = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.SupplyMode;  % �≷���������̗L��
    refsetSupplyMode{2*iREF}     = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.SupplyMode;  % �≷���������̗L��
    refsetStorage{2*iREF-1}      = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.ThermalStorage_Cooling;   % �~�M����
    refsetStorage{2*iREF}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.ThermalStorage_Heating;   % �~�M����
    refsetQuantityCtrl{2*iREF-1} = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityControl_Cooling;  % �䐔����
    refsetQuantityCtrl{2*iREF}   = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityControl_Heating;  % �䐔����
    refsetSupplyTemp(2*iREF-1)   = 7;  % �������x
    refsetSupplyTemp(2*iREF)     = 42; % �������x
    
    
    if length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource) > 10
        disp('�M���@�킪10��ȏ゠��܂��B')
        refsetRnum(2*iREF-1)         = 10;  % �M���@��̐��i�ő�3�j
        refsetRnum(2*iREF)           = 10;  % �M���@��̐��i�ő�3�j
    else
        refsetRnum(2*iREF-1)         = length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource);  % �M���@��̐��i�ő�3�j
        refsetRnum(2*iREF)           = length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource);  % �M���@��̐��i�ő�3�j
    end
    
    for iREFSUB = 1:refsetRnum(2*iREF-1)
        
        for rr = 1:10
            % ��[
            if INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order_Cooling == rr
                refset_Count(2*iREF-1,rr)       = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Cooling,0);      % �䐔
                refset_Type{2*iREF-1,rr}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
                refset_Capacity(2*iREF-1,rr)         = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Cooling,0);   % ��i�\��
                refset_MainPower(2*iREF-1,rr)        = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Cooling,0);  % ��i����G�l���M�[
                refset_SubPower(2*iREF-1,rr)         = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Cooling,0);   % ��i��@�d��
                refset_PrimaryPumpPower(2*iREF-1,rr) = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Cooling,0);  % �ꎟ�|���v��i�d��
                refset_CTCapacity(2*iREF-1,rr)       = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity_Cooling,0);  % ��p���\��
                refset_CTFanPower(2*iREF-1,rr)       = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower_Cooling,0);  % ��p���t�@���d��
                refset_CTPumpPower(2*iREF-1,rr)      = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower_Cooling,0); % ��p��
            end
            %         elseif INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order_Cooling == 2
            %             refset_Count(2*iREF-1,2)       = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Cooling,0);      % �䐔
            %             refset_Type{2*iREF-1,2}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
            %             refset_Capacity(2*iREF-1,2)    = refset_Count(2*iREF-1,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Cooling,0);   % ��i�\��
            %             refset_MainPower(2*iREF-1,2)   = refset_Count(2*iREF-1,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Cooling,0);  % ��i����G�l���M�[
            %             refset_SubPower(2*iREF-1,2)    = refset_Count(2*iREF-1,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Cooling,0);   % ��i��@�d��
            %             refset_PrimaryPumpPower(2*iREF-1,2) = refset_Count(2*iREF-1,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Cooling,0);  % �ꎟ�|���v��i�d��
            %             refset_CTCapacity(2*iREF-1,2)  = refset_Count(2*iREF-1,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity_Cooling,0);  % ��p���\��
            %             refset_CTFanPower(2*iREF-1,2)  = refset_Count(2*iREF-1,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower_Cooling,0);  % ��p���t�@���d��
            %             refset_CTPumpPower(2*iREF-1,2) = refset_Count(2*iREF-1,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower_Cooling,0); % ��p��
            %
            %         elseif INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order_Cooling == 3
            %             refset_Count(2*iREF-1,3)       = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Cooling,0);      % �䐔
            %             refset_Type{2*iREF-1,3}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
            %             refset_Capacity(2*iREF-1,3)    = refset_Count(2*iREF-1,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Cooling,0);   % ��i�\��
            %             refset_MainPower(2*iREF-1,3)   = refset_Count(2*iREF-1,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Cooling,0);  % ��i����G�l���M�[
            %             refset_SubPower(2*iREF-1,3)    = refset_Count(2*iREF-1,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Cooling,0);   % ��i��@�d��
            %             refset_PrimaryPumpPower(2*iREF-1,3) = refset_Count(2*iREF-1,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Cooling,0);  % �ꎟ�|���v��i�d��
            %             refset_CTCapacity(2*iREF-1,3)  = refset_Count(2*iREF-1,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity_Cooling,0);  % ��p���\��
            %             refset_CTFanPower(2*iREF-1,3)  = refset_Count(2*iREF-1,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower_Cooling,0);  % ��p���t�@���d��
            %             refset_CTPumpPower(2*iREF-1,3) = refset_Count(2*iREF-1,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower_Cooling,0); % ��p��
        end
        
        % �g�[
        for rr = 1:10
            if INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order_Heating == rr
                refset_Count(2*iREF,rr)       = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Heating,0);      % �䐔
                refset_Type{2*iREF,rr}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
                refset_Capacity(2*iREF,rr)         = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Heating,0);   % ��i�\��
                refset_MainPower(2*iREF,rr)        = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Heating,0);  % ��i����G�l���M�[
                refset_SubPower(2*iREF,rr)         = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Heating,0);   % ��i��@�d��
                refset_PrimaryPumpPower(2*iREF,rr) = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Heating,0);  % �ꎟ�|���v��i�d��
            end
            %         elseif INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order_Heating == 2
            %             refset_Count(2*iREF,2)       = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Heating,0);      % �䐔
            %             refset_Type{2*iREF,2}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
            %             refset_Capacity(2*iREF,2)    = refset_Count(2*iREF,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Heating,0);   % ��i�\��
            %             refset_MainPower(2*iREF,2)   = refset_Count(2*iREF,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Heating,0);  % ��i����G�l���M�[
            %             refset_SubPower(2*iREF,2)    = refset_Count(2*iREF,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Heating,0);   % ��i��@�d��
            %             refset_PrimaryPumpPower(2*iREF,2) = refset_Count(2*iREF,2) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Heating,0);  % �ꎟ�|���v��i�d��
            %
            %         elseif INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order_Heating == 3
            %             refset_Count(2*iREF,3)       = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Heating,0);      % �䐔
            %             refset_Type{2*iREF,3}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
            %             refset_Capacity(2*iREF,3)    = refset_Count(2*iREF,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Heating,0);   % ��i�\��
            %             refset_MainPower(2*iREF,3)   = refset_Count(2*iREF,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Heating,0);  % ��i����G�l���M�[
            %             refset_SubPower(2*iREF,3)    = refset_Count(2*iREF,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Heating,0);   % ��i��@�d��
            %             refset_PrimaryPumpPower(2*iREF,3) = refset_Count(2*iREF,3) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Heating,0);  % �ꎟ�|���v��i�d��
            %
        end
        
    end
end
