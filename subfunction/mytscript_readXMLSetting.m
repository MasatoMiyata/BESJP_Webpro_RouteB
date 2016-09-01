% mytfunc_readXMLSetting.m
%                                                  2011/04/16 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�ݒ�t�@�C���iXML�t�@�C���j��ǂݍ��ށB
%------------------------------------------------------------------------------

% XML�t�@�C���Ǎ���
INPUT = xml_read(INPUTFILENAME);

% Model�̑���
climateAREA  = num2str(INPUT.ATTRIBUTE.Region);   % �n��敪
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
            roomAHU_Qroom{iZONE} = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(iAHU).ATTRIBUTE.Name;
        elseif strcmp(INPUT.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(iAHU).ATTRIBUTE.Load,'OutsideAir')
            % �O�C���ׂ���������󒲋@ID
            roomAHU_Qoa{iZONE} = INPUT.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(iAHU).ATTRIBUTE.Name;
        end
    end
    
end

%----------------------------------
% �O�ǂƑ�

% WCON.csv �̐���
confW = {};
WallType = {};

for iWALL = 1:length(INPUT.AirConditioningSystem.WallConfigure)
    
    % �ǖ���
    confW{iWALL,1} = INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.Name;
    % WCON��
    if strcmp(INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.Name,'����_�V���')
        confW{iWALL,2} = 'CEI';
    elseif strcmp(INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.Name,'����_����')
        confW{iWALL,2} = 'FLO';
    else
        confW{iWALL,2} = strcat('W',int2str(iWALL));
    end
    
    % �O�ǃ^�C�v
    WallType{iWALL,1} = INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.WallType;
    
    % U�l
    if strcmp(INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.Uvalue,'Null')
        WallUvalue(iWALL,1) = NaN;
    else
        WallUvalue(iWALL,1) = INPUT.AirConditioningSystem.WallConfigure(iWALL).ATTRIBUTE.Uvalue;
    end
        
    for iELE = 1:length(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef)
        
        LayerNum = INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.Layer;
        
        % �ޗ��ԍ�
        confW{iWALL,2+2*(LayerNum-1)+1} = int2str(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.MaterialNumber);
        % ����
        if isempty(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.WallThickness) == 0
            if INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.WallThickness < 1000
%                 confW{iWALL,2+2*(LayerNum-1)+2} = int2str(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.WallThickness);
                confW{iWALL,2+2*(LayerNum-1)+2} = num2str(INPUT.AirConditioningSystem.WallConfigure(iWALL).MaterialRef(iELE).ATTRIBUTE.WallThickness);  %  �����ɂ���K�v�͂Ȃ�
            else
                error('�ǂ̌������s���ł�')
            end
        else
            confW{iWALL,2+2*(LayerNum-1)+2} = '0';
        end
    end
end

% WIND.csv �̐����i2016/3/20�X�V�j
confG = {};

for iWIND = 1:length(INPUT.AirConditioningSystem.WindowConfigure)
    
    % ����
    confG{2*iWIND-1,1} = strcat(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Name,'_0');
    confG{2*iWIND,1}   = strcat(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Name,'_1');
    % ����̎��
    confG{2*iWIND-1,2} = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType;
    confG{2*iWIND,2}   = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.frameType;
    % �K���X�ԍ�
    confG{2*iWIND-1,3} = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassTypeNumber;
    confG{2*iWIND,3}   = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassTypeNumber;
    % �u���C���h
    confG{2*iWIND-1,4} = '0';  % �u���C���h�Ȃ�
    confG{2*iWIND,4}   = '1';  % ���F�u���C���h����
    % �K���XU�l
    confG{2*iWIND-1,5} = num2str(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassUvalue);
    confG{2*iWIND,5}   = num2str(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassUvalue);
    % �K���X�Œl
    confG{2*iWIND-1,6} = num2str(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassMvalue);
    confG{2*iWIND,6}   = num2str(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.glassMvalue);
    
    % ���̔M�ї����iU�l�j
    if strcmp(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue,'Null')
        WindowUvalue(2*iWIND-1,1) = NaN;
        WindowUvalue(2*iWIND,1)   = NaN;
    else
        WindowUvalue(2*iWIND-1,1) = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue;
        WindowUvalue(2*iWIND,1)   = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Uvalue;
    end
    
    % ���̓��˔M�擾���i�Œl�j
    if strcmp(INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue,'Null')
        WindowMvalue(2*iWIND-1,1) = NaN;
        WindowMvalue(2*iWIND,1)   = NaN;
    else
        WindowMvalue(2*iWIND-1,1) = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue;
        WindowMvalue(2*iWIND,1)   = INPUT.AirConditioningSystem.WindowConfigure(iWIND).ATTRIBUTE.Mvalue;
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
        WindowArea(iENV,iWALL)    = mytfunc_null2value(INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowArea,0); % ���ʐ� [m2]
        Direction{iENV,iWALL}     = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Direction;      % ����
        Blind{iENV,iWALL}         = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Blind;          % �u���C���h
        
        Eaves_Cooling{iENV,iWALL}  = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Eaves_Cooling;  % ���悯���ʌW���i��[�j
        Eaves_Heating{iENV,iWALL}  = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Eaves_Heating;  % ���悯���ʌW���i�g�[�j
        
        % �O�ǃ^�C�vNum
        check = 0;
        for iDB = 1:size(confW,1)
            if strcmp(confW{iDB,1},WallConfigure{iENV,iWALL})
                WallTypeTemp = WallType{iDB,1};
                check = 1;
                break
            end
        end
        if check == 0
            error('�O�ǃ^�C�v��������܂���')
        end
        
        if strcmp(WallTypeTemp,'Air')
            WallTypeNum(iENV,iWALL) = 1;
        elseif strcmp(WallTypeTemp,'Ground')
            WallTypeNum(iENV,iWALL) = 2;
        elseif strcmp(WallTypeTemp,'Internal')
            WallTypeNum(iENV,iWALL) = 3;
        end
        
        % �����(�u���C���h�ԍ���t����)
        switch Blind{iENV,iWALL}
            case {'True'}
                WindowType{iENV,iWALL} = strcat(INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowType,'_1');
            case {'False'}
                WindowType{iENV,iWALL} = strcat(INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowType,'_0');
        end
        
        % EXPS(= ���ʁ{�݁@newHASP�p)
        EXPSdata{iENV,iWALL} = strcat(Direction{iENV,iWALL});
        
    end
end


%----------------------------------
% �󒲋@�̃p�����[�^

numOfAHUSET = length(INPUT.AirConditioningSystem.AirHandlingUnitSet);  % �󒲋@�Q�̐�

ahuSetName = cell(numOfAHUSET,1);
numOfAHUele  = zeros(numOfAHUSET,1);
ahuRef_cooling  = cell(numOfAHUSET,1);
ahuRef_heating  = cell(numOfAHUSET,1);
ahuPump_cooling = cell(numOfAHUSET,1);
ahuPump_heating = cell(numOfAHUSET,1);

for iAHUSET = 1:numOfAHUSET
    
    % �󒲋@�Q����
    ahuSetName{iAHUSET,1} = INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).ATTRIBUTE.Name;
    
    % �󒲋@�Q�̒��Ɋ܂܂��󒲋@�v�f�̐�
    numOfAHUele(iAHUSET) = length(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit);
    
    % �M���ڑ��i��[�j
    ahuRef_cooling{iAHUSET}  = ...
        strcat(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).HeatSourceSetRef.ATTRIBUTE.Cooling,'_C');
    % �M���ڑ��i�g�[�j
    ahuRef_heating{iAHUSET}  = ...
        strcat(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).HeatSourceSetRef.ATTRIBUTE.Heating,'_H');
    % �|���v�ڑ��i��[�j
    ahuPump_cooling{iAHUSET} = ...
        strcat(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).SecondaryPumpRef.ATTRIBUTE.Cooling,'_C');
    % �|���v�ڑ��i�g�[�j
    ahuPump_heating{iAHUSET} = ...
        strcat(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).SecondaryPumpRef.ATTRIBUTE.Heating,'_H');
    
    for iAHU = 1:numOfAHUele(iAHUSET)
        
        % �󒲋@�^�C�v
        ahueleType{iAHUSET,iAHU}  = ...
            INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.Type;
        
        % �䐔
        ahueleCount(iAHUSET,iAHU) = ...
            mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.Count,1);
        
        % ��i��[�\�� [kW]
        ahueleQcmax(iAHUSET,iAHU) = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.CoolingCapacity,0);
        % ��i�g�[�\�� [kW]
        ahueleQhmax(iAHUSET,iAHU) = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.HeatingCapacity,0);
        % ���C���� [m3/h]
        ahueleVsa(iAHUSET,iAHU)   = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.SupplyAirVolume,0);
        % ���C�t�@������d�� [kW]
        ahueleEfsa(iAHUSET,iAHU)  = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.SupplyFanPower,0);
        % �ҋC�t�@������d�� [kW]
        ahueleEfra(iAHUSET,iAHU)  = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.ReturnFanPower,0);
        % �O�C�t�@������d�� [kW]
        ahueleEfoa(iAHUSET,iAHU)  = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirFanPower,0);
        % �r�C�t�@������d�� [kW]
        ahueleEfex(iAHUSET,iAHU)  = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.ExitFanPower,0);
        
        % �����ʐ���
        ahueleFlowControl{iAHUSET,iAHU}        = ...
            INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.FlowControl;
        % VAV�ŏ��J�x
        ahueleMinDamperOpening(iAHUSET,iAHU)   = ...
            mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.MinDamperOpening,1);
        
        % �O�C�J�b�g����
        ahueleOACutCtrl{iAHUSET,iAHU}          = ...
            INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirCutControl;
        % �O�C��[����
        ahueleFreeCoolingCtrl{iAHUSET,iAHU}    = ...
            INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.FreeCoolingControl;
        
        % �S�M�����@����
        ahueleHeatExchangeCtrl{iAHUSET,iAHU}   = ...
            INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchanger;
        % �S�M���o�C�p�X�L��
        ahueleHeatExchangeBypass{iAHUSET,iAHU} = ...
            INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerBypass;
        % �S�M������
        ahueleHeatExchangeEff(iAHUSET,iAHU)    = ...
            mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerEfficiency,0);
        % �S�M�𓮗�
        ahueleHeatExchangePower(iAHUSET,iAHU)  = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerPower,0);
        % �S�M�𕗗� [m3/h]
        ahueleHeatExchangeVolume(iAHUSET,iAHU) = ...
            ahueleCount(iAHUSET,iAHU) .* mytfunc_null2value(INPUT.AirConditioningSystem.AirHandlingUnitSet(iAHUSET).AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerVolume,0);
        
    end
    
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

numOfRefs = 2*length(INPUT.AirConditioningSystem.HeatSourceSet);  % numOfRefs: �M���Q�̐�

refsetID           = cell(1,numOfRefs);        % refsetID: �M���Q����
refsetMode         = cell(1,numOfRefs);        % refsetMode: �^�]���[�h�iCooling or Heating)
refsetSupplyMode   = cell(1,numOfRefs);        % refsetSupplyMode: �≷���������̗L��
refsetStorage      = cell(1,numOfRefs);        % refsetStorage: �~�M�������
refsetStorageSize  = zeros(1,numOfRefs);        % refsetStorageSize: �~�M���e�� [MJ]
refsetQuantityCtrl = cell(1,numOfRefs);        % refsetQuantityCtrl: �䐔����̗L��
refsetRnum         = zeros(1,numOfRefs);       % refsetRnum: �M���Q�ɑ�����M���@�̑��䐔
refset_Count       = zeros(numOfRefs,10);      % refset_Count: ����M���@�̑䐔
refset_Type        = cell(numOfRefs,10);       % refset_Type: �M���@�̋@��
refset_Capacity    = zeros(numOfRefs,10);      % refset_Capacity: �M���@��̒�i�\��
refset_MainPower   = zeros(numOfRefs,10);      % refset_MainPower: �M����@�̒�i����G�l���M�[
refset_SubPower    = zeros(numOfRefs,10);      % refset_SubPower: �M����@�̒�i����d��
refset_PrimaryPumpPower = zeros(numOfRefs,10); % refset_PrimaryPumpPower: �ꎟ�|���v�̒�i����d��
refset_CTCapacity       = zeros(numOfRefs,10); % refset_CTCapacity: ��p����i�\��
refset_CTFanPower       = zeros(numOfRefs,10); % refset_CTFanPower: ��p���t�@���̒�i����d��
refset_CTPumpPower      = zeros(numOfRefs,10); % refset_CTPumpPower: ��p���|���v�̒�i����d��
refset_SupplyTemp       = zeros(numOfRefs,10); % refset_SupplyTemp: �������x

storageEffratio =  zeros(1,numOfRefs);        % �~�M������

for iREF = 1:numOfRefs/2
    
    refsetMode{2*iREF-1}         = 'Cooling';             % �^�]���[�h
    refsetMode{2*iREF}           = 'Heating';             % �^�]���[�h
    refsetID{2*iREF-1}           = strcat(INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.Name,'_C');  % �M���Q����
    refsetID{2*iREF}             = strcat(INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.Name,'_H');  % �M���Q����
    refsetSupplyMode{2*iREF-1}   = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.CHmode;             % �≷���������̗L��
    refsetSupplyMode{2*iREF}     = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.CHmode;             % �≷���������̗L��
    refsetQuantityCtrl{2*iREF-1} = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityControl;    % �䐔����
    refsetQuantityCtrl{2*iREF}   = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityControl;    % �䐔����
    refsetStorage{2*iREF-1}      = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.StorageMode;        % �~�M����
    refsetStorage{2*iREF}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.StorageMode;        % �~�M����
    refsetStorageSize(2*iREF-1)  = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.StorageSize,0);        % �~�M�e�� [MJ]
    refsetStorageSize(2*iREF)    = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.StorageSize,0);        % �~�M�e�� [MJ]    
    
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
                refset_Count(2*iREF-1,rr)      ...
                    = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Cooling,0);      % �䐔
                refset_Type{2*iREF-1,rr}       ...
                    = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
                refset_Capacity(2*iREF-1,rr)   ...
                    = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Cooling,0);   % ��i�\��
                refset_MainPower(2*iREF-1,rr)  ...
                    = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Cooling,0);  % ��i����G�l���M�[
                refset_SubPower(2*iREF-1,rr)   ...
                    = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Cooling,0);   % ��i��@�d��
                refset_PrimaryPumpPower(2*iREF-1,rr) ...
                    = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Cooling,0);  % �ꎟ�|���v��i�d��
                refset_CTCapacity(2*iREF-1,rr) ...
                    = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity_Cooling,0);  % ��p���\��
                refset_CTFanPower(2*iREF-1,rr) ...
                    = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower_Cooling,0);  % ��p���t�@���d��
                refset_CTPumpPower(2*iREF-1,rr) ...
                    = refset_Count(2*iREF-1,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower_Cooling,0); % ��p��
                refset_SupplyTemp(2*iREF-1,rr) ...
                    = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SupplyWaterTemp_Cooling,5);   % �������x�i��[�j
            end
        end
        
        % �g�[
        for rr = 1:10
            if INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order_Heating == rr
                refset_Count(2*iREF,rr)       ...
                    = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count_Heating,0);      % �䐔
                refset_Type{2*iREF,rr}        ...
                    = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % �M���@��
                refset_Capacity(2*iREF,rr)    ...
                    = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity_Heating,0);   % ��i�\��
                refset_MainPower(2*iREF,rr)   ...
                    = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower_Heating,0);  % ��i����G�l���M�[
                refset_SubPower(2*iREF,rr)    ...
                    = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower_Heating,0);   % ��i��@�d��
                refset_PrimaryPumpPower(2*iREF,rr) ...
                    = refset_Count(2*iREF,rr) * mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower_Heating,0);  % �ꎟ�|���v��i�d��
                refset_SupplyTemp(2*iREF,rr)  ...
                    = mytfunc_null2value(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SupplyWaterTemp_Heating,50);   % �������x�i�g�[�j
            end
        end
    end
        
end

% �~�M������
for iREF = 1:numOfRefs
    switch refsetStorage{iREF}
        case {'Charge_others','Charge_water_mixing'}
            storageEffratio(iREF) = 0.80;
        case {'Charge_water_stratificated'}
            storageEffratio(iREF) = 0.90;
        case {'Charge_ice'}
            storageEffratio(iREF) = 1.0;
        case {'Discharge','None'}
            storageEffratio(iREF) = NaN;  % ���u���i���̏����Œu�������j
        otherwise
            error('�~�M���^�C�v���s���ł�')
    end
end

% �~�M����Łu���M�v���[�h�ł���ꍇ
% �M���@��ɔM�����@(HEX)�����邩���������A�Ȃ���Βǉ��B
% ����ɉ^�]���ʂ�1�����炷�B
for iREF = 1:numOfRefs
       
    if strcmp(refsetStorage(iREF),'Discharge')
        
        % ���M���ɂ́A�K���u�䐔���䂠��v�ɂ���B(2013/04/18�ǉ�)
        refsetQuantityCtrl{iREF} = 'True';
        
        % �~�M������������
        for iDB = 1:numOfRefs
            if strcmp(refsetID(iDB),refsetID(iREF)) && ...
                    ( strcmp(refsetStorage(iDB),'Charge_others') || strcmp(refsetStorage(iDB),'Charge_water_mixing') || strcmp(refsetStorage(iDB),'Charge_water_stratificated') || strcmp(refsetStorage(iDB),'Charge_ice') )
                storageEffratio(iREF) = storageEffratio(iDB);    % �~�M�������X�V
            end
        end
        
        % �~�M�e�ʂ��󔒂ł������ꍇ�͌������đ��
        if refsetStorageSize(iREF) == 0
            for iDB = 1:numOfRefs
                if strcmp(refsetID(iDB),refsetID(iREF)) && ...
                        ( strcmp(refsetStorage(iDB),'Charge_others') || strcmp(refsetStorage(iDB),'Charge_water_mixing') || strcmp(refsetStorage(iDB),'Charge_water_stratificated') || strcmp(refsetStorage(iDB),'Charge_ice') )
                    refsetStorageSize(iREF) = refsetStorageSize(iDB);
                end
            end
        end
        
        check = 0;
        for iREFSUB = 1:length(refset_Type(iREF,:))
            if strcmp(refset_Type(iREF,iREFSUB),'HEX')
                
                % �M�����@�̑傫�����`�F�b�N
                tmpCapacity = (storageEffratio(iREF))*refsetStorageSize(iREF)/8*(1000/3600);  % 8���ԉ^�]�����ۂ�kW
                if refset_Capacity(iREF,iREFSUB) > tmpCapacity
                    refset_Capacity(iREF,iREFSUB) = tmpCapacity;
                end
                check = 1;
            end
        end
        
        % ���M�p���u�������ꍇ
        if check == 0
            
            refset_Count(iREF,2:11)       = refset_Count(iREF,1:10);
            refset_Type(iREF,2:11)        = refset_Type(iREF,1:10);
            refset_Capacity(iREF,2:11)    = refset_Capacity(iREF,1:10);
            refset_MainPower(iREF,2:11)   = refset_MainPower(iREF,1:10);
            refset_SubPower(iREF,2:11)    = refset_SubPower(iREF,1:10);
            refset_PrimaryPumpPower(iREF,2:11) = refset_PrimaryPumpPower(iREF,1:10);
            refset_CTCapacity(iREF,2:11)  = refset_CTCapacity(iREF,1:10);
            refset_CTFanPower(iREF,2:11)  = refset_CTFanPower(iREF,1:10);
            refset_CTPumpPower(iREF,2:11) = refset_CTPumpPower(iREF,1:10);
            refset_SupplyTemp(iREF,2:11)  = refset_SupplyTemp(iREF,1:10);
            
            % ���z�M�����@��ǉ�
            refset_Count(iREF,1)       = 1;
            refset_Type{iREF,1}        = 'HEX';
            refset_Capacity(iREF,1)    = (storageEffratio(iREF))*refsetStorageSize(iREF)/8*(1000/3600);  % 8���ԉ^�]�����ۂ�kW�i�b��j
            refset_MainPower(iREF,1)   = 0;
            refset_SubPower(iREF,1)    = 0;
            refset_PrimaryPumpPower(iREF,1) = 0;
            refset_CTCapacity(iREF,1)  = 0;
            refset_CTFanPower(iREF,1)  = 0;
            refset_CTPumpPower(iREF,1) = 0;
            if strcmp(refsetMode(iREF),'Cooling')
                refset_SupplyTemp(iREF,1)  = 7;
            elseif strcmp(refsetMode(iREF),'Heating')
                refset_SupplyTemp(iREF,1)  = 42;
            end
            
            % �䐔�����ǉ�
            refsetRnum(iREF) = refsetRnum(iREF) + 1;
            
        end
    end
end


