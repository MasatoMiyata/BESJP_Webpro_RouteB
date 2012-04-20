% mytfunc_systemDef.m
%                                                  2011/01/01 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�FXML�t�@�C���̏�����Ƀf�[�^�x�[�X������𔲂��o���B
%------------------------------------------------------------------------------

% �C�ۃf�[�^
for iDB = 2:size(DB_climateArea,1)
    if strcmp(perDB_climateArea(iDB,2),climateAREA)
        climateDatabase = perDB_climateArea(iDB,6);
    end
end


%----------------------------------
% �󒲎��̃p�����[�^
for iROOM = 1:numOfRoooms

    % �����p�r�Ǝ��p�r���X�g������
    roomTime_start_p1_1 = [];
    for iDB = 2:size(perDB_RoomType,1)
        if strcmp(perDB_RoomType(iDB,2),buildingType{iROOM}) &&...
                strcmp(perDB_RoomType(iDB,5),roomType{iROOM})
            
            % �e���̋󒲊J�n�E�I������
            roomTime_start_p1_1 = str2double(cell2mat(perDB_RoomType(iDB,14))); % �p�^�[��1_�󒲊J�n����(1)
            roomTime_stop_p1_1   = str2double(cell2mat(perDB_RoomType(iDB,15))); % �p�^�[��1_�󒲏I������(1)
            roomTime_start_p1_2 = str2double(cell2mat(perDB_RoomType(iDB,16))); % �p�^�[��1_�󒲊J�n����(2)
            roomTime_stop_p1_2   = str2double(cell2mat(perDB_RoomType(iDB,17))); % �p�^�[��1_�󒲏I������(2)
            roomTime_start_p2_1 = str2double(cell2mat(perDB_RoomType(iDB,18))); % �p�^�[��2_�󒲊J�n����(1)
            roomTime_stop_p2_1   = str2double(cell2mat(perDB_RoomType(iDB,19))); % �p�^�[��2_�󒲏I������(1)
            roomTime_start_p2_2 = str2double(cell2mat(perDB_RoomType(iDB,20))); % �p�^�[��2_�󒲊J�n����(2)
            roomTime_stop_p2_2   = str2double(cell2mat(perDB_RoomType(iDB,21))); % �p�^�[��2_�󒲏I������(2)
            
            % �J�����_�[�ԍ�
            if strcmp(cell2mat(perDB_RoomType(iDB,7)),'A') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'1')
                roomClarendarNum(iROOM) = 1;
            elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'B') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'2')
                roomClarendarNum(iROOM) = 2;
            elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'C') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'3')
                roomClarendarNum(iROOM) = 3;
            elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'D') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'4')
                roomClarendarNum(iROOM) = 4;
            elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'E') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'5')
                roomClarendarNum(iROOM) = 5;
            elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'F') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'6')
                roomClarendarNum(iROOM) = 6;
            else
                perDB_RoomType(iDB,7)
                error('�J�����_�[�i���o�[���s���ł�')
            end
            
            % �O�C������ [m3/h/m2]
            roomVoa_m3hm2(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,13)));
        end
    end
    if isempty(roomTime_start_p1_1)
        buildingType{iROOM}
        roomType{iROOM}
        error('���p�r��������܂���')
    end
    
    % �p�^�[���P
    if isnan(roomTime_start_p1_2)
        roomTime_start_p1  = roomTime_start_p1_1;
        roomTime_stop_p1   = roomTime_stop_p1_1;
        roomDayMode(iROOM) = 1; % �g�p���ԑсi�P�F���A�Q�F��A�O�F�I���j
    else
        roomTime_start_p1  = roomTime_start_p1_2;  % �����܂����ꍇ
        roomTime_stop_p1   = roomTime_stop_p1_1;
        roomDayMode(iROOM) = 2; % �g�p���ԑсi�P�F���A�Q�F��A�O�F�I���j
    end
    
    if roomTime_start_p1 == 0 && roomTime_stop_p1 == 24
        roomDayMode(iROOM) = 0; % �g�p���ԑсi�P�F���A�Q�F��A�O�F�I���j
    end
    
    % �p�^�[���Q
    if isnan(roomTime_start_p2_1)  % NaN�ł���΃p�^�[��2�͋�OFF
        roomTime_start_p2  = 0;
        roomTime_stop_p2   = 0;
    else
        if isnan(roomTime_start_p2_2)
            roomTime_start_p2  = roomTime_start_p2_1;
            roomTime_stop_p2   = roomTime_stop_p2_1;
        else
            roomTime_start_p2  = roomTime_start_p2_2;  % �����܂����ꍇ
            roomTime_stop_p2   = roomTime_stop_p2_1;
        end
    end
    
    % �e���̉^�]���Ԃ̊��蓖��
    for dd=1:365
        if strcmp(perDB_calendar{1+dd,roomClarendarNum(iROOM)+2},'1')  % �^�]�p�^�[���P
            roomTime_start(dd,iROOM) = roomTime_start_p1;
            roomTime_stop(dd,iROOM)   = roomTime_stop_p1;
        elseif strcmp(perDB_calendar{1+dd,roomClarendarNum(iROOM)+2},'2')  % �^�]�p�^�[���Q
            roomTime_start(dd,iROOM) = roomTime_start_p2;
            roomTime_stop(dd,iROOM)   = roomTime_stop_p2;
        elseif strcmp(perDB_calendar{1+dd,roomClarendarNum(iROOM)+2},'3')  % �^�]�p�^�[���R
            roomTime_start(dd,iROOM) = 0;
            roomTime_stop(dd,iROOM)   = 0;
        end
    end
    
    % �O�C������� [m3/h] �� [kg/s]  <������������>
    roomVoa(iROOM) = roomVoa_m3hm2(iROOM).*1.293./3600.*roomArea(iROOM);
    
end

% �󒲖ʐ�
roomAreaTotal = sum(roomArea);


%----------------------------------
% �󒲋@�̃p�����[�^

% �󒲋@���X�g�̍쐬
ahuID = {};
for iAHU = 1:numOfAHUsTemp
    if iAHU == 1
        ahuID = [ahuID; ahueleID(iAHU)];
    else
        check = 0;
        for iDB = 1:length(ahuID)
            if strcmp(ahuID(iDB),ahueleID(iAHU))
                check = 1;
            end
        end
        if check == 0
            ahuID = [ahuID; ahueleID(iAHU)];
        end
    end
end

numOfAHUs = length(ahuID);
ahuName  = cell(1,numOfAHUs);
ahuQcmax = zeros(1,numOfAHUs);
ahuQhmax = zeros(1,numOfAHUs);
ahuVsa   = zeros(1,numOfAHUs);
ahuEfan  = zeros(1,numOfAHUs);
ahuFanVAV = zeros(1,numOfAHUs);
ahuFanVAVmin = ones(1,numOfAHUs);
ahuOAcut  = zeros(1,numOfAHUs);
ahuOAcool = zeros(1,numOfAHUs);
ahuTypeNum = zeros(1,numOfAHUs);
ahuaexE    = zeros(1,numOfAHUs);
ahuaexV    = zeros(1,numOfAHUs);
AEXbypass  = zeros(1,numOfAHUs);
ahuaexeff  = zeros(1,numOfAHUs);
ahuaex     = zeros(1,numOfAHUs);
ahuRef_cooling  = cell(1,numOfAHUs);
ahuRef_heating  = cell(1,numOfAHUs);
ahuPump_cooling = cell(1,numOfAHUs);
ahuPump_heating = cell(1,numOfAHUs);

for iAHU = 1:numOfAHUs
    
    % ��v���郆�j�b�g��T��
    for iAHUELE = 1:numOfAHUsTemp
        if strcmp(ahuID(iAHU),ahueleID(iAHUELE))
            
            switch ahueleType{iAHUELE}
                case {'AHU','FCU','UNIT'}
                    
                    % AHUtype
                    if isempty(ahueleType{iAHUELE})
                        switch ahueleType{iAHUELE}
                            case 'AHU'
                                ahuTypeNum(iAHU) = 1;
                            case 'FCU'
                                ahuTypeNum(iAHU) = 2;
                            case 'UNIT'
                                ahuTypeNum(iAHU) = 3;
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    end
                    
                    % �t�@������d�� [kW]
                    ahuEfan(iAHU) = ahuEfan(iAHU) + ahueleEfsa(iAHUELE) + ahueleEfra(iAHUELE) + ahueleEfoa(iAHUELE) + ahueleEfex(iAHUELE);
                    
                    % 
                    ahuQcmax(iAHU) = ahuQcmax(iAHU) + ahueleQcmax(iAHUELE);
                    ahuQhmax(iAHU) = ahuQhmax(iAHU) + ahueleQhmax(iAHUELE);
                    ahuVsa(iAHU)   = ahuVsa(iAHU)   + ahueleVsa(iAHUELE);
                    
                    % VAV����
                    if isempty(ahueleFlowControl{iAHUELE})
                        switch ahueleFlowControl{iAHUELE}
                            case 'CAV'
                                ahuFanVAV(iAHU)    = 0;
                                ahuFanVAVmin(iAHU) = 1;
                            case 'VAV'
                                ahuFanVAV(iAHU) = 1;
                                if ahueleMinDamperOpening(iAHUELE) >= 0 && ahueleMinDamperOpening(iAHUELE) <= 1
                                    ahuFanVAVmin(iAHU) = ahueleMinDamperOpening(iAHUELE);  % VAV�ŏ����ʔ� [-]
                                else
                                    error('VAV�ŏ��J�x�̐ݒ肪�s���ł�')
                                end
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    end
                    
                    % �O�C�J�b�g
                    if isempty(ahueleOACutCtrl{iAHUELE})
                        switch ahueleOACutCtrl{iAHUELE}
                            case 'False'
                                ahuOAcut(iAHU) = 0;
                            case 'True'
                                ahuOAcut(iAHU) = 1;
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    end
                    
                    % �O�C��[
                    if isempty(ahueleFreeCoolingCtrl{iAHUELE})
                        switch ahueleFreeCoolingCtrl{iAHUELE}
                            case 'False'
                                ahuOAcool(iAHU) = 0;
                            case 'True'
                                ahuOAcool(iAHU) = 1;
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    end
                    
                    % �S�M������
                    if strcmp(ahueleHeatExchangeCtrl{iAHUELE},'True')
                        
                        ahuaex(iAHU) = 1;
                        
                        if ahueleHeatExchangeEff(iAHUELE) >= 0 && ahueleHeatExchangeEff(iAHUELE) <= 1
                            if ahuaexeff(iAHU) == 0
                                ahuaexeff(iAHU) = ahueleHeatExchangeEff(iAHUELE);
                            else
                                ahuaexeff(iAHU) = mean([ahuaexeff(iAHU),ahueleHeatExchangeEff(iAHUELE)]);   % �S�M�����@����
                            end
                        else
                            error('�S�M���������̐ݒ肪�s���ł��B')
                        end
                        
                        if strcmp(ahueleHeatExchangeBypass{iAHUELE},'True')
                            AEXbypass(iAHU) = 1;
                        end
                        
                        ahuaexE(iAHU)   = ahuaexE(iAHU) + ahueleHeatExchangePower(iAHUELE);  % �S�M�����@�̓���
                        ahuaexV(iAHU)   = ahuaexV(iAHU) + ahueleHeatExchangeVolume(iAHUELE); % �S�M�����@�̕���
                        
                    end
                    
                    if isempty(ahuRef_cooling{iAHU})
                        ahuRef_cooling{iAHU}  = ahueleRef_cooling{iAHUELE};
                    end
                    if isempty(ahuRef_heating{iAHU})
                        ahuRef_heating{iAHU}  = ahueleRef_heating{iAHUELE};
                    end
                    if isempty(ahuPump_cooling{iAHU})
                        ahuPump_cooling{iAHU} = ahuelePump_cooling{iAHUELE};
                    end
                    if isempty(ahuPump_heating{iAHU})
                        ahuPump_heating{iAHU} = ahuelePump_heating{iAHUELE};
                    end
                    
                case {'AEX'}
                   
                    % �t�@������d�� [kW]
                    ahuEfan(iAHU) = ahuEfan(iAHU) + ahueleEfsa(iAHUELE) + ahueleEfra(iAHUELE) + ahueleEfoa(iAHUELE) + ahueleEfex(iAHUELE);
                    
                    % �S�M������
                    if strcmp(ahueleHeatExchangeCtrl{iAHUELE},'True')
                        
                        ahuaex(iAHU) = 1;
                        
                        if ahueleHeatExchangeEff(iAHUELE) >= 0 && ahueleHeatExchangeEff(iAHUELE) <= 1
                            if ahuaexeff(iAHU) == 0
                                ahuaexeff(iAHU) = ahueleHeatExchangeEff(iAHUELE);
                            else
                                ahuaexeff(iAHU) = mean([ahuaexeff(iAHU),ahueleHeatExchangeEff(iAHUELE)]);   % �S�M�����@����
                            end
                        else
                            error('�S�M���������̐ݒ肪�s���ł��B')
                        end
                        
                        if strcmp(ahueleHeatExchangeBypass{iAHUELE},'True')
                            AEXbypass(iAHU) = 1;
                        end
                        
                        ahuaexE(iAHU)   = ahuaexE(iAHU) + ahueleHeatExchangePower(iAHUELE);  % �S�M�����@�̓���
                        ahuaexV(iAHU)   = ahuaexV(iAHU) + ahueleHeatExchangeVolume(iAHUELE); % �S�M�����@�̕���
                        
                    end
                    
                    
            end
            
        end
    end
    
    % �ڑ���
    tmpQroomSet = {};
    tmpQoaSet   = {};
    tmpVoa      = 0;
    for iROOM = 1:length(roomName)
        if strcmp(ahuID(iAHU),roomAHU_Qroom(iROOM))
            tmpQroomSet = [tmpQroomSet,roomName(iROOM)];  % �����׏����p
        end
        if strcmp(ahuID(iAHU),roomAHU_Qoa(iROOM))
            tmpQoaSet = [tmpQoaSet,roomName(iROOM)];      % �O�C���׏����p
            tmpVoa    = tmpVoa + roomVoa(iROOM);          % �O�C����� [kg/s]
        end
    end
    ahuQroomSet{iAHU,:} = tmpQroomSet;  % �����׏����Ώ�
    ahuQoaSet{iAHU,:}   = tmpQoaSet;    % �O�C���׏����Ώ�
    ahuQallSet{iAHU,:}  = [ahuQroomSet{iAHU,:},ahuQoaSet{iAHU,:}];
    ahuVoa(iAHU)        = tmpVoa;
    
    
    % �r���}���Ή��i���z�񎟃|���v�������ǉ��j
    if strcmp(ahuPump_cooling{iAHU},'Null_C') % �␅�|���v
        
        % ���z�|���v(��)��ǉ��i�M�����́{VirtualPump�j
        ahuPump_cooling{iAHU} = strcat(ahuRef_cooling{iAHU},'_VirtualPump');
        
        % �|���v���X�g�ɂȂ���ΐV�K�ǉ�
        multipumpFlag = 0;
        for iPUMP = 1:numOfPumps
            if strcmp(pumpName{iPUMP},ahuPump_cooling{iAHU})
                multipumpFlag = 1;
                break
            end
        end
        if multipumpFlag == 0
            numOfPumps = numOfPumps + 1;
            iPUMP = numOfPumps;
            pumpName{iPUMP}     = ahuPump_cooling{iAHU}; % �|���v����
            pumpSystem{iPUMP}   = '';
            pumpMode{iPUMP}     = 'Cooling';             % �|���v�^�]���[�h
            pumpCount(iPUMP)    = 0;                     % �|���v�䐔
            pumpFlow(iPUMP)     = 0;                     % �|���v����
            pumpPower(iPUMP)    = 0;                     % �|���v��i�d��
            pumpFlowCtrl{iPUMP} = 'CWV';                 % �|���v���ʐ���
            pumpQuantityCtrl{iPUMP} = 'False';            % �䐔����
            pumpdelT(iPUMP)     = 0;
            pumpMinValveOpening(iPUMP) = 1;
        end
    end
    
    if strcmp(ahuPump_heating{iAHU},'Null_H') % �����|���v
        
        % ���z�|���v(��)��ǉ��i�M�����́{VirtualPump�j
        ahuPump_heating{iAHU} = strcat(ahuRef_heating{iAHU},'_VirtualPump');
        
        % �|���v���X�g�ɂȂ���ΐV�K�ǉ�
        multipumpFlag = 0;
        for iPUMP = 1:numOfPumps
            if strcmp(pumpName{iPUMP},ahuPump_heating{iAHU})
                multipumpFlag = 1;
                break
            end
        end
        if multipumpFlag == 0
            numOfPumps = numOfPumps + 1;
            iPUMP = numOfPumps;
            pumpName{iPUMP}     = ahuPump_heating{iAHU}; % �|���v����
            pumpSystem{iPUMP}   = '';
            pumpMode{iPUMP}     = 'Heating';             % �|���v�^�]���[�h
            pumpCount(iPUMP)    = 0;                     % �|���v�䐔
            pumpFlow(iPUMP)     = 0;                     % �|���v����
            pumpPower(iPUMP)    = 0;                     % �|���v��i�d��
            pumpFlowCtrl{iPUMP} = 'CWV';                 % �|���v���ʐ���
            pumpQuantityCtrl{iPUMP} = 'False';           % �䐔����
            pumpdelT(iPUMP)     = 0;
            pumpMinValveOpening(iPUMP) = 1;
        end
    end

end


%----------------------------------
% �|���v�̃p�����[�^

for iPUMP = 1:numOfPumps
    
    Td_PUMP(iPUMP) = pumpdelT(iPUMP);
    
    pumpVWVmin(iPUMP) = pumpMinValveOpening(iPUMP);
    
    % �|���v�^�]���[�h
    switch pumpMode{iPUMP}
        case 'Cooling'
            PUMPtype(iPUMP) = 1;
        case 'Heating'
            PUMPtype(iPUMP) = 2;
        otherwise
            error('XML�t�@�C�����s���ł�')
    end
    
    % VWV����
    switch pumpFlowCtrl{iPUMP}
        case 'CWV'
            PUMPvwv(iPUMP) = 0;
        case 'VWV'
            PUMPvwv(iPUMP) = 1;
        otherwise
            error('XML�t�@�C�����s���ł�')
    end
    
    % �䐔����
    switch pumpQuantityCtrl{iPUMP}
        case 'False'
            PUMPnumctr(iPUMP) = 0;
        case 'True'
            PUMPnumctr(iPUMP) = 1;
        otherwise
            error('XML�t�@�C�����s���ł�')
    end
    
    % �ڑ��󒲋@
    tmpAHUSet = {};
    for iAHU = 1:numOfAHUs
        if PUMPtype(iPUMP) == 1
            if strcmp(pumpName{iPUMP},ahuPump_cooling(iAHU)) % �␅�|���v
                tmpAHUSet = [tmpAHUSet,ahuID(iAHU)];
            end
        elseif PUMPtype(iPUMP) == 2
            if strcmp(pumpName{iPUMP},ahuPump_heating(iAHU)) % �����|���v
                tmpAHUSet = [tmpAHUSet,ahuID(iAHU)];
            end
        end
    end
    PUMPahuSet{iPUMP,:} = tmpAHUSet;
    
end


%----------------------------------
% �M���̃p�����[�^

for iREF = 1:numOfRefs
    
    % ��i�ő�\�́i�S�䐔���v�j
    QrefrMax(iREF) = nansum(refset_Capacity(iREF,:));
    
    % �^�]���[�h
    switch refsetMode{iREF}
        case 'Cooling'
            REFtype(iREF) = 1;
            TC(iREF) = refsetSupplyTemp(iREF); % �������x [��]
        case 'Heating'
            REFtype(iREF) = 2;
            TC(iREF) = refsetSupplyTemp(iREF); % �������x [��]
        otherwise
            error('XML�t�@�C�����s���ł�')
    end
    
    % �䐔����
    switch refsetQuantityCtrl{iREF}
        case 'True'
            REFnumctr(iREF) = 1;
        case 'False'
            REFnumctr(iREF) = 0;
        otherwise
            error('XML�t�@�C�����s���ł�')
    end
    
    % �~�M����
    switch refsetStorage{iREF}
        case 'True'
            REFstrage(iREF) = 1;
        case 'False'
            REFstrage(iREF) = 0;
        otherwise
            error('XML�t�@�C�����s���ł�')
    end
    
    % �ڑ��|���v
    tmpPUMPSet = {};
    for iAHU = 1:numOfAHUs
        if REFtype(iREF) == 1
            if strcmp(refsetID(iREF),ahuRef_cooling(iAHU))
                
                tmpPUMPSet = [tmpPUMPSet,ahuPump_cooling(iAHU)];
            end
        elseif REFtype(iREF) == 2
            if strcmp(refsetID(iREF),ahuRef_heating(iAHU))
                tmpPUMPSet = [tmpPUMPSet,ahuPump_heating(iAHU)];
            end
        end
    end
    REFpumpSet{iREF,:} = tmpPUMPSet;
    
    % �M������
    for iREFSUB = 1:refsetRnum(iREF)
        
        % �M�����
        tmprefset = refset_Type{iREF,iREFSUB};
        
        refmatch = 0;
        if isempty(tmprefset) == 0
            for iDB = 2:size(perDB_refList,1)
                if strcmp(perDB_refList(iDB,1),tmprefset)
                    % �R����ށ{�ꎟ�G�l���M�[���Z
                    switch perDB_refList{iDB,3}
                        case '�d��'
                            refInputType(iREF,iREFSUB) = 1;
                            refset_MainPowerELE(iREF,iREFSUB) = (9760/3600)*refset_MainPower(iREF,iREFSUB);
                        case '�K�X'
                            refInputType(iREF,iREFSUB) = 2;
                            refset_MainPowerELE(iREF,iREFSUB) = (45000/3600)*refset_MainPower(iREF,iREFSUB);
                        case '�d��'
                            refInputType(iREF,iREFSUB) = 3;
                            refset_MainPowerELE(iREF,iREFSUB) = (41000/3600)*refset_MainPower(iREF,iREFSUB);
                        case '����'
                            refInputType(iREF,iREFSUB) = 4;
                            refset_MainPowerELE(iREF,iREFSUB) = (37000/3600)*refset_MainPower(iREF,iREFSUB);
                        case '�t���Ζ��K�X'
                            refInputType(iREF,iREFSUB) = 5;
                            refset_MainPowerELE(iREF,iREFSUB) = (50000/3600)*refset_MainPower(iREF,iREFSUB);
                        case '�n��F���C'
                            refInputType(iREF,iREFSUB) = 6;
                            refset_MainPowerELE(iREF,iREFSUB) = (1.36)*refset_MainPower(iREF,iREFSUB);
                        case '�n��F����'
                            refInputType(iREF,iREFSUB) = 7;
                            refset_MainPowerELE(iREF,iREFSUB) = (1.36)*refset_MainPower(iREF,iREFSUB);
                        case '�n��F�␅'
                            refInputType(iREF,iREFSUB) = 8;
                            refset_MainPowerELE(iREF,iREFSUB) = (1.36)*refset_MainPower(iREF,iREFSUB);
                        otherwise
                            error('�M���F�R����ނ̐ݒ肪�s���ł�')
                    end
                    
                    % ��p����
                    switch perDB_refList{iDB,4}
                        case '����'
                            refHeatSourceType(iREF,iREFSUB) = 1;
                        case '���'
                            refHeatSourceType(iREF,iREFSUB) = 2;
                    end
                                        
                    % �����Ȑ�
                    tN = '';
                    for i=1:4
                        if i == 1 && REFtype(iREF) == 1
                            tN = 'Cq';  % �\�͔�����i��j
                        elseif i == 1 && REFtype(iREF) == 2
                            tN = 'Hp';  % �\�͔�����i���j
                        elseif i == 2 && REFtype(iREF) == 1
                            tN = 'Cp';  % ���͔�����i��j
                        elseif i == 2 && REFtype(iREF) == 2
                            tN = 'Hq';  % ���͔�����i���j
                        elseif i == 3 && REFtype(iREF) == 1
                            tN = 'Cx';  % �������ד����i��j
                        elseif i == 3 && REFtype(iREF) == 2
                            tN = 'Hx';  % �������ד����i���j
                        elseif i == 4 && REFtype(iREF) == 1
                            tN = 'Cw';  % �������x�����i��j
                        elseif i == 4 && REFtype(iREF) == 2
                            tN = 'Hw';  % �������x�����i���j
                        end

                        % �����Ȑ��^�C�v�̓ǂݍ���
                        if REFtype(iREF) == 1
                            eval(['refPerC_',tN,'{iREF,iREFSUB} = perDB_refList(iDB,4+i);'])
                        elseif REFtype(iREF) == 2
                            eval(['refPerC_',tN,'{iREF,iREFSUB} = perDB_refList(iDB,8+i);'])
                        end
                            
                            
                        % ���\�Ȑ��̌W���̓ǂݍ���
                        eval(['tmpPerC = refPerC_',tN,'{iREF,iREFSUB};'])
                        tmpcoeff = [];
                        for iDB2 = 1:size(perDB_refCurve,1)
                            if strcmp(perDB_refCurve(iDB2,2),tmpPerC)
                                tmpcoeff(1,1) = str2double(perDB_refCurve(iDB2,6));  % 4��̌W��
                                tmpcoeff(1,2) = str2double(perDB_refCurve(iDB2,7));  % 3��̌W��
                                tmpcoeff(1,3) = str2double(perDB_refCurve(iDB2,8));  % 2��̌W��
                                tmpcoeff(1,4) = str2double(perDB_refCurve(iDB2,9));  % 1��̌W��
                                tmpcoeff(1,5) = str2double(perDB_refCurve(iDB2,10)); % �ؕ�
                                tmpcoeff(1,6) = str2double(perDB_refCurve(iDB2,4));  % x�̍ŏ��l
                                tmpcoeff(1,7) = str2double(perDB_refCurve(iDB2,5));  % x�̍ő�l
                            end
                        end
                        if isempty(tmpcoeff)
                            error('�M��������������܂���')
                        end
                        
                        % �ۑ�
                        if i == 1
                            RerPerC_q_coeffi(iREF,iREFSUB,:) = tmpcoeff(1:5);
                            RerPerC_q_min(iREF,iREFSUB) = tmpcoeff(6);
                            RerPerC_q_max(iREF,iREFSUB) = tmpcoeff(7);
                        elseif i == 2
                            RerPerC_p_coeffi(iREF,iREFSUB,:) = tmpcoeff(1:5);
                            RerPerC_p_min(iREF,iREFSUB) = tmpcoeff(6);
                            RerPerC_p_max(iREF,iREFSUB) = tmpcoeff(7);
                        elseif i == 3
                            RerPerC_x_coeffi(iREF,iREFSUB,:) = tmpcoeff(1:5);
                            RerPerC_x_min(iREF,iREFSUB) = tmpcoeff(6);
                            RerPerC_x_max(iREF,iREFSUB) = tmpcoeff(7);
                        elseif i == 4
                            RerPerC_w_coeffi(iREF,iREFSUB,:) = tmpcoeff(1:5);
                            RerPerC_w_min(iREF,iREFSUB) = tmpcoeff(6);
                            RerPerC_w_max(iREF,iREFSUB) = tmpcoeff(7);
                        end
                        
                    end
                    
                    refmatch = 1; % �����ς݂̏؋�
                    
                end
            end
        end
        
        % ����W��(default 1.2)
        RefTEIGEN(iREF,iREFSUB) = 1.2;
        
        if strcmp(tmprefset,'Rtype10') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        elseif strcmp(tmprefset,'Rtype11') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        elseif strcmp(tmprefset,'Rtype12') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        elseif strcmp(tmprefset,'Rtype13') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        elseif strcmp(tmprefset,'Rtype14') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        elseif strcmp(tmprefset,'Rtype15') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        elseif strcmp(tmprefset,'Rtype16') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        elseif strcmp(tmprefset,'Rtype17') && REFtype(iREF) == 2
            RefTEIGEN(iREF,iREFSUB) = 1.0;
        end
        
        if refmatch == 0
            error('�M�����̂��s���ł�');
        end
    end
end


