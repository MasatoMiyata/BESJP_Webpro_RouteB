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
    
    ahueleID{iAHU}    = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Name;    % �󒲋@ID
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
if isfield(INPUT.AirConditioningSystem,'SecondaryPumpSet')
    
    numOfPumps       = 2*length(INPUT.AirConditioningSystem.SecondaryPumpSet);  % ��[�p�ƒg�[�p��2�쐬
    pumpName         = cell(1,numOfPumps);
    pumpdelT         = zeros(1,numOfPumps);
    pumpMode         = cell(1,numOfPumps);
    
    for iPUMP = 1:numOfPumps/2
               
        % 10��ȏ゠��Όx��
        if length(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump) > 10
            disp('�񎟃|���v��10��ȏ゠��܂��B')
            pumpsetPnum(2*iPUMP-1) = 10; % �|���v�̐��i�ő�10�j
            pumpsetPnum(2*iPUMP)  = 10; % �|���v�̐��i�ő�10�j
        else
            pumpsetPnum(2*iPUMP-1) = length(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump); % �|���v�̐��i�ő�10�j
            pumpsetPnum(2*iPUMP)  = length(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump); % �|���v�̐��i�ő�10�j
        end
        
        
        % �␅�|���v�Q
        pumpMode{2*iPUMP-1}         = 'Cooling';        % �|���v�^�]���[�h
        pumpName{2*iPUMP-1}         = strcat(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).ATTRIBUTE.Name,'_C');            % �|���v�Q����
        pumpdelT(2*iPUMP-1)         = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).ATTRIBUTE.deltaTemp_Cooling,5);     % �|���v�݌v���x���i��[�j
        pumpQuantityCtrl{2*iPUMP-1} = INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).ATTRIBUTE.QuantityControl; % �|���v�䐔����
        
        % �����|���v�Q
        pumpMode{2*iPUMP}           = 'Heating';        % �|���v�^�]���[�h
        pumpName{2*iPUMP}           = strcat(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).ATTRIBUTE.Name,'_H');            % �|���v����
        pumpdelT(2*iPUMP)           = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).ATTRIBUTE.deltaTemp_Heating,5);     % �|���v�݌v���x���i�g�[�j
        pumpQuantityCtrl{2*iPUMP}   = INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).ATTRIBUTE.QuantityControl; % �|���v�䐔����
        
        % �e�|���v�̐ݒ�
        for iPUMPSUB = 1:pumpsetPnum(2*iPUMP-1)      
            for rr = 1:10
                if INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.Order == rr
                    pumpsubCount  = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.Count,0);           % �|���v�䐔
                    pumpFlow(2*iPUMP-1,rr)         = pumpsubCount * mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.RatedFlow,0);       % �|���v����
                    pumpPower(2*iPUMP-1,rr)        = pumpsubCount * mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.RatedPower,0);      % �|���v��i�d��
                    pumpFlowCtrl{2*iPUMP-1,rr}     = INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.FlowControl;     % �|���v���ʐ���
                    pumpMinValveOpening(2*iPUMP-1,rr)  = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.MinValveOpening,0.3);  % VWV���ŏ�����
                    
                    pumpsubCount  = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.Count,0);           % �|���v�䐔
                    pumpFlow(2*iPUMP,rr)           = pumpsubCount * mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.RatedFlow,0);       % �|���v����
                    pumpPower(2*iPUMP,rr)          = pumpsubCount * mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.RatedPower,0);      % �|���v��i�d��
                    pumpFlowCtrl{2*iPUMP,rr}       = INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.FlowControl;     % �|���v���ʐ���
                    pumpMinValveOpening(2*iPUMP,rr)    = mytfunc_null2value(INPUT.AirConditioningSystem.SecondaryPumpSet(iPUMP).SecondaryPump(iPUMPSUB).ATTRIBUTE.MinValveOpening,0.3);  % VWV���ŏ�����
                end
            end
        end
        
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
    refsetSupplyMode{2*iREF-1}   = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.CHmode;  % �≷���������̗L��
    refsetSupplyMode{2*iREF}     = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.CHmode;  % �≷���������̗L��
    refsetStorage{2*iREF-1}      = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.StorageMode;   % �~�M����
    refsetStorage{2*iREF}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.StorageMode;   % �~�M����
    refsetQuantityCtrl{2*iREF-1} = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityConrol;  % �䐔����
    refsetQuantityCtrl{2*iREF}   = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityConrol;  % �䐔����
    refsetSupplyTemp(2*iREF-1)   = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.SupplyWaterTemp_Cooling;  % �������x
    refsetSupplyTemp(2*iREF)     = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.SupplyWaterTemp_Heating; % �������x
    
    
    if length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource) > 10
        disp('�M���@�킪10��ȏ゠��܂��B')
        refsetRnum(2*iREF-1)         = 10;  % �M���@��̐��i�ő�10�j
        refsetRnum(2*iREF)           = 10;  % �M���@��̐��i�ő�10�j
    else
        refsetRnum(2*iREF-1)         = length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource);  % �M���@��̐��i�ő�10�j
        refsetRnum(2*iREF)           = length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource);  % �M���@��̐��i�ő�10�j
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
        end
        
    end
end


% WCON.csv �̐���
confW = {};

for iWALL = 1:length(INPUT.AirConditioningSystem.WallConfigure)
      
    % �ǖ���
    confW{iWALL,1} = INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.Name;
    % ��ID
    confW{iWALL,2} = INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.ID;
    
    for iELE = 1:length(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef)
   
        LayerNum = INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.Layer;
        
        % �ޗ��ԍ�
        confW{iWALL,2+2*(LayerNum-1)+1} = int2str(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.MaterialNumber);
        % ����
        if INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.WallThickness < 1000    
            confW{iWALL,2+2*(LayerNum-1)+2} = int2str(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.WallThickness);
        else
            error('�ǂ̌������s���ł�')
        end
    end
end

% WIND.csv �̐���
confG = {};

for iWIND = 1:length(INPUT.AirConditioningSystem.WindowConfigure)
    
    % ����
    confG{iWIND,1} = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.ID;
    % �����
    confG{iWIND,2} = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.WindowTypeClass;
    % ���ԍ�
    confG{iWIND,3} = int2str(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.WindowTypeNumber);
    % �u���C���h
    confG{iWIND,4} = '1'; % newHASP�ł͏�ɖ��F�u���C���h����Ƃ���B

end
    
% WCON,WIND.csv �̏o��
for iFILE=1:2
    if iFILE == 1
        tmp = confG;
        filename = './database/WIND.csv';
        header = {'����','����','�i��ԍ�','�u���C���h'};
    else
        tmp = confW;
        filename = './database/WCON.csv';
        header = {'����','WCON��','��1�w�ޔ�','��1�w��','��2�w�ޔ�','��2�w��','��3�w�ޔ�',...
            '��3�w��','��4�w�ޔ�','��4�w��','��5�w�ޔ�','��5�w��','��6�w�ޔ�','��6�w��',...
            '��7�w�ޔ�','��7�w��','��8�w�ޔ�','��8�w��','��9�w�ޔ�','��9�w��','��10�w�ޔ�',...
            '��10�w��','��11�w�ޔ�','��11�w��'};
    end
    
    fid = fopen(filename,'wt'); % �������ݗp�Ƀt�@�C���I�[�v��
    
    % �w�b�_�[�̏����o��
    fprintf(fid, '%s,', header{1:end-1});
    fprintf(fid, '%s\n', header{end});
    
    [rows,cols] = size(tmp);
    for j = 1:rows
        for k = 1:cols
            if k < cols
                fprintf(fid, '%s,', tmp{j,k}); % ������̏����o��
            else
                fprintf(fid, '%s\n', tmp{j,k}); % �s���̕�����́A���s���܂߂ďo��
            end
        end
    end
    
    y = fclose(fid);
    
end






