% mytfunc_readXMLSetting.m
%                                                  2011/01/01 by Masato Miyata
%------------------------------------------------------------------------------
% ÈGlî[gBFÝèt@CiXMLt@CjðÇÝÞB
%------------------------------------------------------------------------------

% XMLt@CÇÝ
INPUT = xml_read(INPUTFILENAME);

% ModelÌ®«
climateAREA  = INPUT.ATTRIBUTE.Region; % nææª
BuildingArea = INPUT.ATTRIBUTE.Area;   % °ÊÏ [m2]
BuildingType = INPUT.ATTRIBUTE.Type;   % ¨pr


%----------------------------------
% ºvfÌp[^

numOfRooomEs = length(INPUT.Rooms.Room);
for iROOMEL = 1:numOfRooomEs
    roomElementName{iROOMEL}   = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.ID;     % ºID
    roomElementType{iROOMEL}   = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.Type;   % ºpr
    roomElementArea(iROOMEL)   = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.Area;   % ºÊÏ
    roomElementCount(iROOMEL)  = 1;  % º
    roomElementFloorHeight(iROOMEL) = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.FloorHeight; % K
    roomElementHeight(iROOMEL) = INPUT.Rooms.Room(iROOMEL).ATTRIBUTE.Height; % º
end
    
%----------------------------------
% ó²ºÌp[^
numOfRoooms = length(INPUT.AirConditioningSystem.AirConditioningRoom);
for iROOM = 1:numOfRoooms
    
    roomName{iROOM}   = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).ATTRIBUTE.ID;           % ó²ºID
    roomElements{iROOM}   = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).ATTRIBUTE.RoomIDs;  % ºÌQoa,b,c}
    EnvelopeRef{iROOM} = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).ATTRIBUTE.EnvelopeID;  % OçID
    
    % ó²@ID@¡nE¢Î
    for iAHU = 1:2
        if strcmp(INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.Load,'Room')
            % º×ð·éó²@ID
            roomAHU_Qroom{iROOM} = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.ID;
        elseif strcmp(INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.Load,'OutsideAir')
            % º×ð·éó²@ID
            roomAHU_Qoa{iROOM} = INPUT.AirConditioningSystem.AirConditioningRoom(iROOM).AirHandlingUnitRef(iAHU).ATTRIBUTE.ID;
        end
    end
    
end

%----------------------------------
% Oç
numOfENVs = length(INPUT.AirConditioningSystem.Envelope);
for iENV = 1:numOfENVs
    envelopeID{iENV} = INPUT.AirConditioningSystem.Envelope(iENV).ATTRIBUTE.ID;
    numOfWalls(iENV) = length(INPUT.AirConditioningSystem.Envelope(iENV).Wall);
    for iWALL = 1:numOfWalls(iENV)
        WallConfigure{iENV,iWALL} = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WallConfigure;  % OÇíÞ
        WallArea(iENV,iWALL)      = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WallArea;       % OçÊÏ [m2]
        WindowType{iENV,iWALL}    = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowType;     % íÞ
        WindowArea(iENV,iWALL)    = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.WindowArea;     % ÊÏ [m2]
        Direction{iENV,iWALL}     = INPUT.AirConditioningSystem.Envelope(iENV).Wall(iWALL).ATTRIBUTE.Direction;      % ûÊ
    end
end


%----------------------------------
% ó²@Ìp[^

numOfAHUs = length(INPUT.AirConditioningSystem.AirHandlingUnit);
for iAHU = 1:numOfAHUs
    
    ahuName{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.ID;    % ó²@ID
    ahuType{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Type;  % ó²@^Cv
    
    ahuCount(iAHU) = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.Count;  % ä
    
    ahuQcmax(iAHU) = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.CoolingCapacity;  % èiâ[\Í
    ahuQhmax(iAHU) = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatingCapacity;  % èig[\Í
    ahuVsa(iAHU)   = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.SupplyAirVolume;  % CÊ
    ahuEfsa(iAHU)  = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.SupplyFanPower;   % Ct@ÁïdÍ
    ahuEfra(iAHU)  = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.ReturnFanPower;   % ÒCt@ÁïdÍ
    ahuEfoa(iAHU)  = ahuCount(iAHU) * INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirFanPower;   % OCt@ÁïdÍ
    
    ahuFlowControl{iAHU}       = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.FlowControl;           % Ê§ä
    ahuMinDamperOpening(iAHU)  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.MinDamperOpening;      % VAVÅ¬Jx
    ahuOACutCtrl{iAHU}         = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.OutsideAirCutControl;  % OCJbg§ä
    ahuFreeCoolingCtrl{iAHU}   = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.FreeCoolingControl;    % OCâ[§ä
    ahuHeatExchangeCtrl{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchanger;          % SMð·@§ä
    ahuHeatExchangeEff(iAHU)   = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerEfficiency;  % SMðø¦
    ahuHeatExchangePower(iAHU) = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).ATTRIBUTE.HeatExchangerPower;    % SMð®Í
    
    ahuRef_cooling{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).HeatSourceSetRef.ATTRIBUTE.CoolingID;  % M¹Ú±iâ[j
    ahuRef_heating{iAHU}  = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).HeatSourceSetRef.ATTRIBUTE.HeatingID;  % M¹Ú±ig[j
    ahuPump_cooling{iAHU} = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).SecondaryPumpRef.ATTRIBUTE.CoolingID;  % |vÚ±iâ[j
    ahuPump_heating{iAHU} = INPUT.AirConditioningSystem.AirHandlingUnit(iAHU).SecondaryPumpRef.ATTRIBUTE.HeatingID;  % |vÚ±ig[j
    
end


%----------------------------------
% |vÌp[^
if isfield(INPUT.AirConditioningSystem,'SecondaryPump')
    numOfPumps = length(INPUT.AirConditioningSystem.SecondaryPump);
    for iPUMP = 1:numOfPumps
        pumpName{iPUMP}         = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.ID;          % |v¼Ì
        pumpMode{iPUMP}         = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Mode;        % |v^][h
        pumpCount(iPUMP)        = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.Count;       % |vä
        pumpFlow(iPUMP)         = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedFlow;   % |v¬Ê
        pumpPower(iPUMP)        = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.RatedPower;  % |vèidÍ
        pumpFlowCtrl{iPUMP}     = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.FlowControl; % |v¬Ê§ä
        pumpQuantityCtrl{iPUMP} = INPUT.AirConditioningSystem.SecondaryPump(iPUMP).ATTRIBUTE.QuantityControl; % |vä§ä
    end
else
    numOfPumps = 0;
end


%----------------------------------
% M¹Ìp[^

numOfRefs = length(INPUT.AirConditioningSystem.HeatSourceSet);
for iREF = 1:numOfRefs
    
    refsetID{iREF}           = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.ID;               % M¹Q¼Ì
    refsetMode{iREF}         = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.Mode;             % ^][h
    refsetStorage{iREF}      = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.ThermalStorage;   % ~M§ä
    refsetQuantityCtrl{iREF} = INPUT.AirConditioningSystem.HeatSourceSet(iREF).ATTRIBUTE.QuantityControl;  % ä§ä
    
    refsetRnum(iREF) = length(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource);  % M¹@íÌiÅå3j
    for iREFSUB = 1:refsetRnum(iREF)
        if strcmp(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order,'First')
            refset_Count(iREF,1)       = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count;      % ä
            refset_Type{iREF,1}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % M¹@í
            refset_Capacity(iREF,1)    = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity;   % èi\Í
            refset_MainPower(iREF,1)   = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower;  % èiÁïGlM[
            refset_SubPower(iREF,1)    = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower;   % èiâ@dÍ
            refset_PrimaryPumpPower(iREF,1) = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower;  % ê|vèidÍ
            refset_CTCapacity(iREF,1)  = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity;  % âp\Í
            refset_CTFanPower(iREF,1)  = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower;  % âpt@dÍ
            refset_CTPumpPower(iREF,1) = refset_Count(iREF,1) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower; % âp
        elseif strcmp(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order,'Second')
            refset_Count(iREF,2)       = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count;      % ä
            refset_Type{iREF,2}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % M¹@í
            refset_Capacity(iREF,2)    = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity;   % èi\Í
            refset_MainPower(iREF,2)   = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower;  % èiÁïGlM[
            refset_SubPower(iREF,2)    = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower;   % èiâ@dÍ
            refset_PrimaryPumpPower(iREF,2) = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower;  % ê|vèidÍ
            refset_CTCapacity(iREF,2)  = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity;  % âp\Í
            refset_CTFanPower(iREF,2)  = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower;  % âpt@dÍ
            refset_CTPumpPower(iREF,2) = refset_Count(iREF,2) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower; % âp
        elseif strcmp(INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Order,'Third')
            refset_Count(iREF,3)       = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Count;      % ä
            refset_Type{iREF,3}        = INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Type;       % M¹@í
            refset_Capacity(iREF,3)    = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.Capacity;   % èi\Í
            refset_MainPower(iREF,3)   = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.MainPower;  % èiÁïGlM[
            refset_SubPower(iREF,3)    = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.SubPower;   % èiâ@dÍ
            refset_PrimaryPumpPower(iREF,3) = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.PrimaryPumpPower;  % ê|vèidÍ
            refset_CTCapacity(iREF,3)  = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTCapacity;  % âp\Í
            refset_CTFanPower(iREF,3)  = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTFanPower;  % âpt@dÍ
            refset_CTPumpPower(iREF,3) = refset_Count(iREF,3) * INPUT.AirConditioningSystem.HeatSourceSet(iREF).HeatSource(iREFSUB).ATTRIBUTE.CTPumpPower; % âp
        end
    end
    
end
