% mytfunc_systemDef.m
%                                                  2011/04/25 by Masato Miyata
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
            
            % �������M�� [W/m2]
            roomEnergyOAappUnit(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,11)));
            
            % WSC�p�^�[��
            if strcmp(perDB_RoomType(iDB,8),'WSC1')
                roomWSC(iROOM) = 1;
            elseif strcmp(perDB_RoomType(iDB,8),'WSC2')
                roomWSC(iROOM) = 2;
            else
                iROOM
                perDB_RoomType(iDB,8)
                error('WSC�p�^�[�����s���ł��B')
            end
            
            % �����L�[
            roomKey{iROOM} = perDB_RoomType(iDB,1);
            % �������M�ʂ̎����ϓ�
            for iDB2 = 2:size(perDB_RoomOpeCondition,1)
                
                % �@�픭�M���x�䗦
                if strcmp(perDB_RoomOpeCondition(iDB2,1),roomKey{iROOM}) &&...
                        strcmp(perDB_RoomOpeCondition(iDB2,4),'4')
                    if strcmp(perDB_RoomOpeCondition(iDB2,5),'1')
                        roomScheduleOAapp(iROOM,1,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'2')
                        roomScheduleOAapp(iROOM,2,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'3')
                        roomScheduleOAapp(iROOM,3,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    else
                        error('���g�p�p�^�[�����s���ł�')
                    end
                end
                
                % �Ɩ����M���x�䗦
                if strcmp(perDB_RoomOpeCondition(iDB2,1),roomKey{iROOM}) &&...
                        strcmp(perDB_RoomOpeCondition(iDB2,4),'2')
                    if strcmp(perDB_RoomOpeCondition(iDB2,5),'1')
                        roomScheduleLight(iROOM,1,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'2')
                        roomScheduleLight(iROOM,2,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'3')
                        roomScheduleLight(iROOM,3,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    else
                        error('���g�p�p�^�[�����s���ł�')
                    end
                end
                
            end

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
            roomDailyOpePattern(dd,iROOM) = 1;
        elseif strcmp(perDB_calendar{1+dd,roomClarendarNum(iROOM)+2},'2')  % �^�]�p�^�[���Q
            roomTime_start(dd,iROOM) = roomTime_start_p2;
            roomTime_stop(dd,iROOM)   = roomTime_stop_p2;
            roomDailyOpePattern(dd,iROOM) = 2;
        elseif strcmp(perDB_calendar{1+dd,roomClarendarNum(iROOM)+2},'3')  % �^�]�p�^�[���R
            
            if roomWSC(iROOM) == 1
                roomTime_start(dd,iROOM)  = 0;
                roomTime_stop(dd,iROOM)   = 0;
            elseif roomWSC(iROOM) == 2
                roomTime_start(dd,iROOM)  = roomTime_start_p2;
                roomTime_stop(dd,iROOM)   = roomTime_stop_p2;
            end
            roomDailyOpePattern(dd,iROOM) = 3;
        end
    end
    
    % �O�C������� [m3/h] �� [kg/s]
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
ahuType  = cell(1,numOfAHUs);
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
ahuFreeCoolingCtrl = cell(1,numOfAHUs);
ahuHeatExchangeCtrl = cell(1,numOfAHUs);
ahuOACutCtrl = cell(1,numOfAHUs);
ahuFlowControl = cell(1,numOfAHUs);

for iAHU = 1:numOfAHUs
    
    % ��v���郆�j�b�g��T��
    for iAHUELE = 1:numOfAHUsTemp
        if strcmp(ahuID(iAHU),ahueleID(iAHUELE))

            switch ahueleType{iAHUELE}
                case {'AHU','FCU','UNIT'}
                                        
                    % AHUtype
                    if isempty(ahueleType{iAHUELE}) == 0
                        switch ahueleType{iAHUELE}
                            case 'AHU'
                                ahuType{iAHU}    = '�󒲋@';
                                ahuTypeNum(iAHU) = 1;
                            case 'FCU'
                                ahuType{iAHU}    = 'FCU';
                                ahuTypeNum(iAHU) = 2;
                            case 'UNIT'
                                ahuType{iAHU}    = 'UNIT';
                                ahuTypeNum(iAHU) = 3;
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    end
                    
                    % �t�@������d�� [kW]
                    ahuEfan(iAHU) = ahuEfan(iAHU) + ahueleEfsa(iAHUELE) + ahueleEfra(iAHUELE) + ahueleEfoa(iAHUELE) + ahueleEfex(iAHUELE);
                    
                    % ��[�\�́A�g�[�\�́A���C���ʂ𑫂�
                    ahuQcmax(iAHU) = ahuQcmax(iAHU) + ahueleQcmax(iAHUELE);
                    ahuQhmax(iAHU) = ahuQhmax(iAHU) + ahueleQhmax(iAHUELE);
                    ahuVsa(iAHU)   = ahuVsa(iAHU)   + ahueleVsa(iAHUELE);
                    
                    % VAV����
                    if isempty(ahueleFlowControl{iAHUELE}) == 0
                        switch ahueleFlowControl{iAHUELE}
                            case 'CAV'
                                ahuFlowControl{iAHU} = '�蕗��';
                                ahuFanVAV(iAHU)    = 0;
                                ahuFanVAVmin(iAHU) = 1;
                            case 'VAV'
                                ahuFlowControl{iAHU} = '�ϕ���';
                                ahuFanVAV(iAHU) = 1;
                                if ahueleMinDamperOpening(iAHUELE) >= 0 && ahueleMinDamperOpening(iAHUELE) <= 1
                                    ahuFanVAVmin(iAHU) = ahueleMinDamperOpening(iAHUELE);  % VAV�ŏ����ʔ� [-]
                                else
                                    error('VAV�ŏ��J�x�̐ݒ肪�s���ł�')
                                end
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    else
                        ahuFlowControl{iAHU} = '�蕗��';
                    end
                    
                    
                    % �O�C�J�b�g
                    if isempty(ahueleOACutCtrl{iAHUELE}) == 0
                        switch ahueleOACutCtrl{iAHUELE}
                            case 'False'
                                ahuOACutCtrl{iAHU} = '��';
                                ahuOAcut(iAHU) = 0;
                            case 'True'
                                ahuOACutCtrl{iAHU} = '�L';
                                ahuOAcut(iAHU) = 1;
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    else
                         ahuOACutCtrl{iAHU} = '��';   
                    end
                    
                    % �O�C��[
                    if isempty(ahueleFreeCoolingCtrl{iAHUELE}) == 0
                        switch ahueleFreeCoolingCtrl{iAHUELE}
                            case 'False'
                                ahuFreeCoolingCtrl{iAHU} = '��';
                                ahuOAcool(iAHU) = 0;
                            case 'True'
                                ahuFreeCoolingCtrl{iAHU} = '�L';
                                ahuOAcool(iAHU) = 1;
                            otherwise
                                error('XML�t�@�C�����s���ł�')
                        end
                    else
                        ahuFreeCoolingCtrl{iAHU} = '��';
                    end
                    
                    % �S�M������
                    if strcmp(ahueleHeatExchangeCtrl{iAHUELE},'True')
                        
                        ahuHeatExchangeCtrl{iAHU} = '�L';
                        ahuaex(iAHU) = 1;
                        
                        if ahueleHeatExchangeEff(iAHUELE) >= 0 && ahueleHeatExchangeEff(iAHUELE) <= 1
                            if ahuaexeff(iAHU) == 0
                                ahuaexeff(iAHU) = ahueleHeatExchangeEff(iAHUELE);
                            else
                                % �����䂠��ꍇ�̌����́A��Ԉ������̂��g���B
                                if ahuaexeff(iAHU) > ahueleHeatExchangeEff(iAHUELE)
                                    ahuaexeff(iAHU) = ahueleHeatExchangeEff(iAHUELE);
                                end
                            end
                        else
                            error('�S�M���������̐ݒ肪�s���ł��B')
                        end
                        
                        if strcmp(ahueleHeatExchangeBypass{iAHUELE},'True')
                            AEXbypass(iAHU) = 1;
                        end
                        
                        ahuaexE(iAHU)   = ahuaexE(iAHU) + ahueleHeatExchangePower(iAHUELE);  % �S�M�����@�̓���
                        ahuaexV(iAHU)   = ahuaexV(iAHU) + ahueleHeatExchangeVolume(iAHUELE); % �S�M�����@�̕���
                    else
                        ahuHeatExchangeCtrl{iAHU} = '��';
                    end
                    
                    if isempty(ahueleRef_cooling{iAHU}) == 0
                        ahuRef_cooling{iAHU}  = ahueleRef_cooling{iAHUELE};
                    end
                    if isempty(ahueleRef_heating{iAHU}) == 0
                        ahuRef_heating{iAHU}  = ahueleRef_heating{iAHUELE};
                    end
                    if isempty(ahuelePump_cooling{iAHU}) == 0
                        ahuPump_cooling{iAHU} = ahuelePump_cooling{iAHUELE};
                    end
                    if isempty(ahuelePump_heating{iAHU}) == 0
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
                                % �����䂠��ꍇ�̌����́A��Ԉ������̂��g���B
                                if ahuaexeff(iAHU) > ahueleHeatExchangeEff(iAHUELE)
                                    ahuaexeff(iAHU) = ahueleHeatExchangeEff(iAHUELE);
                                end
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
    tmpSahu     = 0;
    for iROOM = 1:length(roomName)
        if strcmp(ahuID(iAHU),roomAHU_Qroom(iROOM))
            tmpQroomSet = [tmpQroomSet,roomID(iROOM)];  % �����׏����p
        end
        if strcmp(ahuID(iAHU),roomAHU_Qoa(iROOM))
            tmpQoaSet = [tmpQoaSet,roomID(iROOM)];      % �O�C���׏����p
            tmpVoa    = tmpVoa + roomVoa(iROOM);          % �O�C����� [kg/s]
            tmpSahu   = tmpSahu + roomArea(iROOM);
        end
    end
    ahuQroomSet{iAHU,:} = tmpQroomSet;  % �����׏����Ώ�
    ahuQoaSet{iAHU,:}   = tmpQoaSet;    % �O�C���׏����Ώ�
    ahuQallSet{iAHU,:}  = [ahuQroomSet{iAHU,:},ahuQoaSet{iAHU,:}];
    ahuVoa(iAHU)        = tmpVoa;
    ahuS(iAHU)          = tmpSahu;  % �󒲌n�����Ƃ̋󒲑Ώۖʐ� [m2]
    ahuATF_C(iAHU)      = ahuQcmax(iAHU)/ahuEfan(iAHU); % ��[��ATF(��[�\�́^�t�@�����́j
    ahuATF_H(iAHU)      = ahuQhmax(iAHU)/ahuEfan(iAHU); % ��[��ATF(�g�[�\�́^�t�@�����́j
    ahuFratio(iAHU)     = ahuEfan(iAHU)/ahuS(iAHU)*1000;     % �P�ʏ��ʐς�����̃t�@���d�� [W/m2]
    
                                        
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
    tmpSpump  = 0;
    for iAHU = 1:numOfAHUs
        if PUMPtype(iPUMP) == 1
            if strcmp(pumpName{iPUMP},ahuPump_cooling(iAHU)) % �␅�|���v
                tmpAHUSet = [tmpAHUSet,ahuID(iAHU)];
                tmpSpump  = tmpSpump + ahuS(iAHU);
            end
        elseif PUMPtype(iPUMP) == 2
            if strcmp(pumpName{iPUMP},ahuPump_heating(iAHU)) % �����|���v
                tmpAHUSet = [tmpAHUSet,ahuID(iAHU)];
                tmpSpump  = tmpSpump + ahuS(iAHU);
            end
        end
    end
    PUMPahuSet{iPUMP,:} = tmpAHUSet;
    pumpS(iPUMP)        = tmpSpump;    % �|���v�n�����Ƃ̋󒲑Ώۖʐ�
    
end


%----------------------------------
% �M���̃p�����[�^

xXratioMX = ones(numOfRefs,3).*NaN;
    
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
    tmpSref    = 0;
    for iAHU = 1:numOfAHUs
        if REFtype(iREF) == 1
            if strcmp(refsetID(iREF),ahuRef_cooling(iAHU))
                
                tmpPUMPSet = [tmpPUMPSet,ahuPump_cooling(iAHU)];
                tmpSref    = tmpSref + ahuS(iAHU);
            end
        elseif REFtype(iREF) == 2
            if strcmp(refsetID(iREF),ahuRef_heating(iAHU))
                tmpPUMPSet = [tmpPUMPSet,ahuPump_heating(iAHU)];
                tmpSref    = tmpSref + ahuS(iAHU);
            end
        end
    end
    REFpumpSet{iREF,:} = tmpPUMPSet;
    refS(iREF)         = tmpSref;
    
    % �M������
    for iREFSUB = 1:refsetRnum(iREF)
        
        % �M�����
        tmprefset = refset_Type{iREF,iREFSUB};
        
        refmatch = 0;
        
        % �f�[�^�x�[�X������
        if isempty(tmprefset) == 0
            
            % �Y������ӏ������ׂĔ����o��
            refParaSetALL = {};
            for iDB = 2:size(perDB_refList,1)
                if strcmp(perDB_refList(iDB,1),tmprefset)
                    refParaSetALL = [refParaSetALL;perDB_refList(iDB,:)];
                end
            end
            if isempty(refParaSetALL)
                error('�M�� %s �̓�����������܂���',tmprefset)
            end
            
            % �R����ށ{�ꎟ�G�l���M�[���Z [kW]
            switch refParaSetALL{1,3}
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
                case '���C'
                    refInputType(iREF,iREFSUB) = 6;
                    refset_MainPowerELE(iREF,iREFSUB) = (1.36/3600)*refset_MainPower(iREF,iREFSUB);
                case '����'
                    refInputType(iREF,iREFSUB) = 7;
                    refset_MainPowerELE(iREF,iREFSUB) = (1.36/3600)*refset_MainPower(iREF,iREFSUB);
                case '�␅'
                    refInputType(iREF,iREFSUB) = 8;
                    refset_MainPowerELE(iREF,iREFSUB) = (1.36/3600)*refset_MainPower(iREF,iREFSUB);
                otherwise
                    error('�M�� %s �̔R����ʂ��s���ł�',tmprefset)
            end
            
            % ��p����
            switch refParaSetALL{1,4}
                case '����'
                    refHeatSourceType(iREF,iREFSUB) = 1;
                case '���'
                    refHeatSourceType(iREF,iREFSUB) = 2;
                case '�R��'
                    refHeatSourceType(iREF,iREFSUB) = 1;
            end
            
            % �\�͔�A���͔�̕ϐ�
            if refHeatSourceType(iREF,iREFSUB) == 1 && REFtype(iREF) == 1   % ����^��[
                xT = TctwC;   % ��p�����x
            elseif refHeatSourceType(iREF,iREFSUB) == 1 && REFtype(iREF) == 2   % ����^�g�[
                xT = ToadbH;  % �������x
            elseif refHeatSourceType(iREF,iREFSUB) == 2 && REFtype(iREF) == 1   % ���^��[
                xT = ToadbC;  % �������x
            elseif refHeatSourceType(iREF,iREFSUB) == 2 && REFtype(iREF) == 2   % ���^�g�[
                xT = ToawbH;  % �������x
            else
                error('���[�h���s���ł�')
            end
            
            xTALL(iREF,iREFSUB,:) = xT;
            
            % �\�͔�Ɠ��͔�
            for iPQXW = 1:4
                
                if iPQXW == 1
                    PQname = '�\�͔�';
                    Vname  = 'xQratio';
                elseif iPQXW == 2
                    PQname = '���͔�';
                    Vname  = 'xPratio';
                elseif iPQXW == 3
                    PQname = '�������ד���';
                elseif iPQXW == 4
                    PQname = '�������x����';
                end
                
                % �f�[�^�x�[�X����Y���ӏ��𔲂��o���F�j
                paraQ = {};
                for iDB = 1:size(refParaSetALL,1)
                    if strcmp(refParaSetALL(iDB,5),refsetMode{iREF}) && strcmp(refParaSetALL(iDB,6),PQname)
                        paraQ = [paraQ;  refParaSetALL(iDB,:)];
                    end
                end
                
                % �l�̔����o��
                tmpdata   = [];
                tmpdataMX = [];
                if isempty(paraQ) == 0
                    for iDBQ = 1:size(paraQ,1)
                        for iLIST = 2:size(perDB_refCurve,1)
                            if strcmp(paraQ(iDBQ,9),perDB_refCurve(iLIST,2))
                                % �ŏ��l�A�ő�l�A����W���A�p�����[�^�ix4,x3,x2,x1,a�j
                                tmpdata = [tmpdata;str2double(paraQ(iDBQ,[7,8,10])),str2double(perDB_refCurve(iLIST,4:8))];
                                
                                if iPQXW == 3
                                    if isempty(tmpdataMX)
                                        tmpdataMX = str2double(paraQ(iDBQ,12));
                                    end
                                end
                            end
                        end
                    end
                end
                
                % �W���i����W�����݁j
                if iPQXW == 1 || iPQXW == 2
                    for i = 1:6
                        eval(['',Vname,'(iREF,iREFSUB,i) = mytfunc_REFparaSET(tmpdata,xT(i));'])
                    end
                    
                elseif iPQXW == 3
                    if isempty(tmpdata) == 0
                        for iX = 1:size(tmpdata,1)
                            RerPerC_x_min(iREF,iREFSUB,iX)    = tmpdata(iX,1);
                            RerPerC_x_max(iREF,iREFSUB,iX)    = tmpdata(iX,2);
                            RerPerC_x_coeffi(iREF,iREFSUB,iX,1)  = tmpdata(iX,4);
                            RerPerC_x_coeffi(iREF,iREFSUB,iX,2)  = tmpdata(iX,5);
                            RerPerC_x_coeffi(iREF,iREFSUB,iX,3)  = tmpdata(iX,6);
                            RerPerC_x_coeffi(iREF,iREFSUB,iX,4)  = tmpdata(iX,7);
                            RerPerC_x_coeffi(iREF,iREFSUB,iX,5)  = tmpdata(iX,8);
                        end
                    else
                        RerPerC_x_min(iREF,iREFSUB,1)    = 0;
                        RerPerC_x_max(iREF,iREFSUB,1)    = 0;
                        RerPerC_x_coeffi(iREF,iREFSUB,1,1)  = 0;
                        RerPerC_x_coeffi(iREF,iREFSUB,1,2)  = 0;
                        RerPerC_x_coeffi(iREF,iREFSUB,1,3)  = 0;
                        RerPerC_x_coeffi(iREF,iREFSUB,1,4)  = 0;
                        RerPerC_x_coeffi(iREF,iREFSUB,1,5)  = 1;
                    end
                    if isempty(tmpdataMX) == 0
                        xXratioMX(iREF,iREFSUB) = tmpdataMX;
                    end
                    
                elseif iPQXW == 4
                    if isempty(tmpdata) == 0
                        RerPerC_w_min(iREF,iREFSUB)    = tmpdata(1,1);
                        RerPerC_w_max(iREF,iREFSUB)    = tmpdata(1,2);
                        RerPerC_w_coeffi(iREF,iREFSUB,1)  = tmpdata(1,4);
                        RerPerC_w_coeffi(iREF,iREFSUB,2)  = tmpdata(1,5);
                        RerPerC_w_coeffi(iREF,iREFSUB,3)  = tmpdata(1,6);
                        RerPerC_w_coeffi(iREF,iREFSUB,4)  = tmpdata(1,7);
                        RerPerC_w_coeffi(iREF,iREFSUB,5)  = tmpdata(1,8);
                    else
                        RerPerC_w_min(iREF,iREFSUB)       = 0;
                        RerPerC_w_max(iREF,iREFSUB)       = 0;
                        RerPerC_w_coeffi(iREF,iREFSUB,1)  = 0;
                        RerPerC_w_coeffi(iREF,iREFSUB,2)  = 0;
                        RerPerC_w_coeffi(iREF,iREFSUB,3)  = 0;
                        RerPerC_w_coeffi(iREF,iREFSUB,4)  = 0;
                        RerPerC_w_coeffi(iREF,iREFSUB,5)  = 1;
                    end
                    
                end
                
            end
            
            refmatch = 1; % �����ς݂̏؋�
            
        end
        
        if isempty(tmprefset)== 0 && refmatch == 0
            error('�M�����̂��s���ł�');
        end
        
    end
    
end





