% mytfunc_systemDef.m
%                                                  2011/04/25 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�FXML�t�@�C���̏�����Ƀf�[�^�x�[�X������𔲂��o���B
%------------------------------------------------------------------------------

% �C�ۃf�[�^
for iDB = 2:size(DB_climateArea,1)
    if strcmp(perDB_climateArea(iDB,1),climateAREA) ...
            || strcmp(perDB_climateArea(iDB,2),climateAREA)
        
        climateDatabase = perDB_climateArea(iDB,6);
        % �ܓx
        phi   = str2double(perDB_climateArea(iDB,4));
        % �o�x
        longi = str2double(perDB_climateArea(iDB,5));
        
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
            roomTime_start_p1_1  = str2double(cell2mat(perDB_RoomType(iDB,14))); % �p�^�[��1_�󒲊J�n����(1)
            roomTime_stop_p1_1   = str2double(cell2mat(perDB_RoomType(iDB,15))); % �p�^�[��1_�󒲏I������(1)
            roomTime_start_p1_2  = str2double(cell2mat(perDB_RoomType(iDB,16))); % �p�^�[��1_�󒲊J�n����(2)
            roomTime_stop_p1_2   = str2double(cell2mat(perDB_RoomType(iDB,17))); % �p�^�[��1_�󒲏I������(2)
            roomTime_start_p2_1  = str2double(cell2mat(perDB_RoomType(iDB,18))); % �p�^�[��2_�󒲊J�n����(1)
            roomTime_stop_p2_1   = str2double(cell2mat(perDB_RoomType(iDB,19))); % �p�^�[��2_�󒲏I������(1)
            roomTime_start_p2_2  = str2double(cell2mat(perDB_RoomType(iDB,20))); % �p�^�[��2_�󒲊J�n����(2)
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
            
            % �@�픭�M�� [W/m2]
            roomEnergyOAappUnit(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,11)));
            
            % �Ɩ�
            roomEnergyLight(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,9)));
            % �l�� [�l/m2 * W/�l = W/m2]
            switch cell2mat(perDB_RoomType(iDB,12))
                case '1'
                    roomEnergyPerson(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,10)))*92;
                case '2'
                    roomEnergyPerson(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,10)))*106;
                case '3'
                    roomEnergyPerson(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,10)))*119;
                case '4'
                    roomEnergyPerson(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,10)))*131;
                case '5'
                    roomEnergyPerson(iROOM) = str2double(cell2mat(perDB_RoomType(iDB,10)))*145;
                otherwise
                    iROOM
                    perDB_RoomType(iDB,10)
                    error('��Ƌ��x�w�����s���ł��B')
            end
            
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
                
                % �l�̔��M���x
                if strcmp(perDB_RoomOpeCondition(iDB2,1),roomKey{iROOM}) &&...
                        strcmp(perDB_RoomOpeCondition(iDB2,4),'3')
                    if strcmp(perDB_RoomOpeCondition(iDB2,5),'1')
                        roomSchedulePerson(iROOM,1,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'2')
                        roomSchedulePerson(iROOM,2,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'3')
                        roomSchedulePerson(iROOM,3,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
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
ahuType    = cell(numOfAHUSET,1);
ahuTypeNum = zeros(numOfAHUSET,1);
ahuQcmax   = zeros(numOfAHUSET,1);
ahuQhmax   = zeros(numOfAHUSET,1);
ahuVsa     = zeros(numOfAHUSET,1);
ahuaexE    = zeros(numOfAHUSET,1);
ahuaexV    = zeros(numOfAHUSET,1);

for iAHU = 1:numOfAHUSET
    
    for iAHUele = 1:numOfAHUele(iAHU)
        
        % �󒲋@�^�C�v���u�󒲋@�v�̂Ƃ�ahuTypeNum���P�Ƃ���B
        if strcmp(ahueleType{iAHU,iAHUele},'AHU')
            ahuTypeNum(iAHU) = 1;
            ahuType{iAHU}    = '�󒲋@';
        end
        if ahuTypeNum(iAHU) == 0
            ahuType{iAHU}    = '�󒲋@�ȊO';
        end
         
        % �t�@������d�� [kW]
        ahuEfan(iAHU,iAHUele) = ahueleEfsa(iAHU,iAHUele) + ahueleEfra(iAHU,iAHUele) + ...
            ahueleEfoa(iAHU,iAHUele) + ahueleEfex(iAHU,iAHUele);
        
        % ��[�\�́A�g�[�\�́A���C���ʂ𑫂�
        ahuQcmax(iAHU) = ahuQcmax(iAHU) + ahueleQcmax(iAHU,iAHUele);
        ahuQhmax(iAHU) = ahuQhmax(iAHU) + ahueleQhmax(iAHU,iAHUele);
        ahuVsa(iAHU)   = ahuVsa(iAHU)   + ahueleVsa(iAHU,iAHUele);   % [m3/h]
        
        % ���ʐ�������̌��ʗ�
        if isempty(ahueleFlowControl{iAHU,iAHUele}) == 0 && ...
                strcmp(ahueleFlowControl(iAHU,iAHUele),'VAV_INV')
            
            % ���ʐ�������i�o�͗p�j
            ahuFlowControl{iAHU,iAHUele} = '��]������';
            % ���ʐ�������i0: �蕗�ʁA1: �ϕ��ʁj
            ahuFanVAV(iAHU,iAHUele) = 1;
            
            % �ŏ��J�x
            if ahueleMinDamperOpening(iAHU,iAHUele) >= 0 && ahueleMinDamperOpening(iAHU,iAHUele) < 1
                ahuFanVAVmin(iAHU,iAHUele) = ahueleMinDamperOpening(iAHU,iAHUele);  % VAV�ŏ����ʔ� [-]
            elseif ahueleMinDamperOpening(iAHU,iAHUele) == 1
                ahuFanVAVmin(iAHU,iAHUele)    = 1;
            else
                error('VAV�ŏ��J�x�̐ݒ肪�s���ł�')
            end
            
            % �G�l���M�[������� ahuFanVAVfunc
            check = 0;
            for iDB = 2:size(perDB_flowControl,1)
                if strcmp(perDB_flowControl(iDB,2),ahueleFlowControl(iAHU,iAHUele))
                    
                    a4 = str2double(perDB_flowControl(iDB,4));
                    a3 = str2double(perDB_flowControl(iDB,5));
                    a2 = str2double(perDB_flowControl(iDB,6));
                    a1 = str2double(perDB_flowControl(iDB,7));
                    a0 = str2double(perDB_flowControl(iDB,8));
                    
                    for iL = 1:length(aveL)
                        if aveL(iL) < ahuFanVAVmin(iAHU,iAHUele)
                            ahuFanVAVfunc(iAHU,iAHUele,iL) = ...
                                a4 .* ahuFanVAVmin(iAHU,iAHUele).^4 + a3 .* ahuFanVAVmin(iAHU,iAHUele).^3 + ...
                                a2 .* ahuFanVAVmin(iAHU,iAHUele).^2 + a1 .* ahuFanVAVmin(iAHU,iAHUele) + a0;
                        else
                            ahuFanVAVfunc(iAHU,iAHUele,iL) = ...
                                a4 .* aveL(iL).^4 + a3 .* aveL(iL).^3 + a2 .* aveL(iL).^2 + a1 .* aveL(iL) + a0;
                        end
                    end
                    
                    % �ߕ��ׂ̍ۂ̏���
                    ahuFanVAVfunc(iAHU,iAHUele,end) = 1.2;
                    
                    check = 1;
                end
            end
            
            % �ŏ��J�x
            if ahueleMinDamperOpening(iAHU,iAHUele) == 1
                % �ŏ��J�x��1�̎���VAV�Ƃ݂͂Ȃ��Ȃ��B
                ahuFanVAVfunc(iAHU,iAHUele,end) = 1.2;
                ahuFanVAVmin(iAHU,iAHUele)      = 1;
            end
            
            if check == 0
                error('VAV�̃G�l���M�[���������������܂���')
            end
            
        else
            
            % ���ʐ�������i�o�͗p�j
            ahuFlowControl{iAHU,iAHUele}   = '�蕗��';
            % ���ʐ�������i0: �蕗�ʁA1: �ϕ��ʁj
            ahuFanVAV(iAHU,iAHUele)        = 0;
            % �G�l���M�[�������
            ahuFanVAVfunc(iAHU,iAHUele,:)  = ones(1,length(aveL));
            % �ߕ��ׂ̍ۂ̏���
            ahuFanVAVfunc(iAHU,iAHUele,end) = 1.2;
            % �ŏ��J�x
            ahuFanVAVmin(iAHU,iAHUele)     = 1;
            
        end
        
        
        % �O�C�J�b�g
        if isempty(ahueleOACutCtrl{iAHU,iAHUele}) == 0
            switch ahueleOACutCtrl{iAHU,iAHUele}
                case {'False', 'Null'}
                    ahueleOAcut(iAHU,iAHUele) = 0;
                case 'True'
                    ahueleOAcut(iAHU,iAHUele) = 1;
                otherwise
                    ahueleOACutCtrl{iAHU,iAHUele}
                    error('XML�t�@�C�����s���ł�')
            end
        else
            ahueleOAcut(iAHU,iAHUele) = 0;
        end
        
        
        % �O�C��[
        if isempty(ahueleFreeCoolingCtrl{iAHU,iAHUele}) == 0
            switch ahueleFreeCoolingCtrl{iAHU,iAHUele}
                case {'False','Null'}
                    ahueleOAcool(iAHU,iAHUele) = 0;
                case 'True'
                    ahueleOAcool(iAHU,iAHUele) = 1;
                otherwise
                    error('XML�t�@�C�����s���ł�')
            end
        else
            ahueleOAcool(iAHU,iAHUele) = 0;
        end
        
        % �S�M������i�L���A�����A�o�C�p�X�L���j
        if isempty(ahueleHeatExchangeCtrl{iAHU,iAHUele}) == 0
            switch ahueleHeatExchangeCtrl{iAHU,iAHUele}
                case {'False','Null'}
                    ahueleaex(iAHU,iAHUele) = 0;
                    ahueleaexeff(iAHU,iAHUele) = 0;
                    ahuelebypass(iAHU,iAHUele) = 0;
                case 'True'
                    ahueleaex(iAHU,iAHUele) = 1;
                    
                    if ahueleHeatExchangeEff(iAHU,iAHUele) >= 0 && ahueleHeatExchangeEff(iAHU,iAHUele) <= 1
                        ahueleaexeff(iAHU,iAHUele) = ahueleHeatExchangeEff(iAHU,iAHUele);
                    else
                        error('�S�M���������̐ݒ肪�s���ł��B')
                    end
                    
                    switch ahueleHeatExchangeBypass{iAHU,iAHUele}
                        case {'False','Null'}
                            ahuelebypass(iAHU,iAHUele) = 0;
                        case 'True'
                            ahuelebypass(iAHU,iAHUele) = 1;
                        otherwise
                            error('XML�t�@�C�����s���ł�')
                    end
                otherwise
                    error('XML�t�@�C�����s���ł�')
            end
        else
            ahueleaex(iAHU,iAHUele) = 0;
            ahueleaexeff(iAHU,iAHUele) = 0;
            ahuelebypass(iAHU,iAHUele) = 0;
        end
        
        % �S�M������i���́A���ʁj
        ahuaexE(iAHU)   = ...
            ahuaexE(iAHU) + ahueleHeatExchangePower(iAHU,iAHUele);  % �S�M�����@�̓���
        ahuaexV(iAHU)   = ...
            ahuaexV(iAHU) + ahueleHeatExchangeVolume(iAHU,iAHUele); % �S�M�����@�̕���
        
        
    end
    
    
    % �󒲋@�Q�Ƃ��Đ��䂪�L���ł��邩�ǂ���(1�ł�true�ł���΂���Ƃ݂Ȃ�)
    
    % �O�C�J�b�g
    if sum(ahueleOAcut(iAHU,:)) > 0
        ahuOAcut(iAHU) = 1;
        ahuOACutCtrl{iAHU} = '�L';
    else
        ahuOAcut(iAHU) = 0;
        ahuOACutCtrl{iAHU} = '��';
    end
    
    % �O�C��[
    if sum(ahueleOAcool(iAHU,:)) > 0
        ahuOAcool(iAHU) = 1;
        ahuFreeCoolingCtrl{iAHU} = '�L';
    else
        ahuOAcool(iAHU) = 0;
        ahuFreeCoolingCtrl{iAHU} = '��';
    end
    
    % �S�M������
    if sum(ahueleaex(iAHU,:)) > 0
        ahuaex(iAHU) = 1;
        ahuHeatExchangeCtrl{iAHU} = '�L';
        
        % �S�M���������i�Œ�̂��̂��̗p����j
        ahuaexeff(iAHU) = 0;
        for iAHUele = 1:numOfAHUele(iAHU)
            if ahueleaexeff(iAHU,iAHUele) ~= 0
                if ahuaexeff(iAHU) == 0
                    ahuaexeff(iAHU) = ahueleaexeff(iAHU,iAHUele);
                elseif ahueleaexeff(iAHU,iAHUele) < ahuaexeff(iAHU)
                    ahuaexeff(iAHU) = ahueleaexeff(iAHU,iAHUele);
                end
            end
        end
        
        % �S�M���������̕␳�i20150930�j
        if aexCoeffiModifyOn == 1
            aexCeff = 1 - ((1/0.85)-1)*(1-ahuaexeff(iAHU))/ahuaexeff(iAHU);
            aexCtol = 0.95;
            aexCbal = 0.67;
            ahuaexeff(iAHU) = ahuaexeff(iAHU) * aexCeff * aexCtol * aexCbal;
            
%         elseif aexCoeffiModifyOn == 2  % ���ؗp
%             aexCeff = 1 - ((1/0.85)-1)*(1-ahuaexeff(iAHU))/ahuaexeff(iAHU);
%             aexCtol = 0.95;
%             aexCbal = 1.00;
%             ahuaexeff(iAHU) = ahuaexeff(iAHU) * aexCeff * aexCtol * aexCbal;
%             
%         elseif aexCoeffiModifyOn == 3  % ���ؗp
%             ahuaexeff(iAHU) = 0;
        end
        
        if sum(ahuelebypass(iAHU,:)) > 0
            AEXbypass(iAHU) = 1;
        else
            AEXbypass(iAHU) = 0;
        end
    else
        ahuaex(iAHU) = 0;
        ahuHeatExchangeCtrl{iAHU} = '��';
        ahuaexeff(iAHU) = 0;
        AEXbypass(iAHU) = 0;
    end
    
    
    % �ڑ���
    tmpQroomSet = {};
    tmpQoaSet   = {};
    tmpVoa      = 0;
    tmpSahu     = 0;
    for iROOM = 1:length(roomName)
        if strcmp(ahuSetName(iAHU),roomAHU_Qroom(iROOM))
            tmpQroomSet = [tmpQroomSet,roomID(iROOM)];  % �����׏����p
        end
        if strcmp(ahuSetName(iAHU),roomAHU_Qoa(iROOM))
            tmpQoaSet = [tmpQoaSet,roomID(iROOM)];      % �O�C���׏����p
            tmpVoa    = tmpVoa + roomVoa(iROOM);          % �O�C����� [kg/s]
            tmpSahu   = tmpSahu + roomArea(iROOM);
        end
    end
    ahuQroomSet{iAHU,:} = tmpQroomSet;  % �����׏����Ώێ�
    ahuQoaSet{iAHU,:}   = tmpQoaSet;    % �O�C���׏����Ώێ�
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
            pumpMode{iPUMP}     = 'Cooling';             % �|���v�^�]���[�h
            pumpdelT(iPUMP)     = 0;
            pumpQuantityCtrl{iPUMP} = 'False';            % �䐔����
            pumpsetPnum(iPUMP)  = 1;
            
            pumpFlow(iPUMP,1)     = 0;                     % �|���v����
            pumpPower(iPUMP,1)    = 0;                     % �|���v��i�d��
            pumpFlowCtrl{iPUMP,1} = 'CWV';                 % �|���v���ʐ���
            pumpMinValveOpening(iPUMP,1) = 1;
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
            pumpMode{iPUMP}     = 'Heating';             % �|���v�^�]���[�h
            pumpdelT(iPUMP)     = 0;
            pumpQuantityCtrl{iPUMP} = 'False';           % �䐔����
            pumpsetPnum(iPUMP)  = 1;
            
            pumpFlow(iPUMP,1)     = 0;                     % �|���v����
            pumpPower(iPUMP,1)    = 0;                     % �|���v��i�d��
            pumpFlowCtrl{iPUMP,1} = 'CWV';                 % �|���v���ʐ���
            pumpMinValveOpening(iPUMP,1) = 1;
        end
    end

end



%----------------------------------
% �|���v�̃p�����[�^

for iPUMP = 1:numOfPumps
        
    % �|���v�^�]���[�h
    switch pumpMode{iPUMP}
        case 'Cooling'
            PUMPtype(iPUMP) = 1;
        case 'Heating'
            PUMPtype(iPUMP) = 2;
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
    
    for iPUMPSUB = 1:pumpsetPnum(iPUMP)
        
        % VWV����
        switch pumpFlowCtrl{iPUMP,iPUMPSUB}
            case {'CWV', 'Null'}
                PUMPvwv(iPUMP,iPUMPSUB) = 0;
                Pump_VWVcoeffi(iPUMP,iPUMPSUB,1) = 0;  % 4���̌W��
                Pump_VWVcoeffi(iPUMP,iPUMPSUB,2) = 0;  % 3���̌W��
                Pump_VWVcoeffi(iPUMP,iPUMPSUB,3) = 0;  % 2���̌W��
                Pump_VWVcoeffi(iPUMP,iPUMPSUB,4) = 0;  % 1���̌W��
                Pump_VWVcoeffi(iPUMP,iPUMPSUB,5) = 1;  % �ؕ�
                
            otherwise
                
                PUMPvwv(iPUMP,iPUMPSUB) = 1;
                
                % ���ʌW�� Pump_VWVcoeffi
                check = 0;
                for iDB = 2:size(perDB_flowControl,1)
                    if strcmp(perDB_flowControl(iDB,2),pumpFlowCtrl{iPUMP,iPUMPSUB})
                        Pump_VWVcoeffi(iPUMP,iPUMPSUB,1) = str2double(perDB_flowControl(iDB,4));  % 4���̌W��
                        Pump_VWVcoeffi(iPUMP,iPUMPSUB,2) = str2double(perDB_flowControl(iDB,5));  % 3���̌W��
                        Pump_VWVcoeffi(iPUMP,iPUMPSUB,3) = str2double(perDB_flowControl(iDB,6));  % 2���̌W��
                        Pump_VWVcoeffi(iPUMP,iPUMPSUB,4) = str2double(perDB_flowControl(iDB,7));  % 1���̌W��
                        Pump_VWVcoeffi(iPUMP,iPUMPSUB,5) = str2double(perDB_flowControl(iDB,8));  % �ؕ�
                        check = 1;
                    end
                end
                
                % VWV���̍ŏ�����
                if pumpMinValveOpening(iPUMP,iPUMPSUB) >= 0 && pumpMinValveOpening(iPUMP,iPUMPSUB) < 1
                    pumpVWVmin(iPUMP,iPUMPSUB) = pumpMinValveOpening(iPUMP,iPUMPSUB);
                elseif pumpMinValveOpening(iPUMP,iPUMPSUB) == 1
                    % �ŏ��J�x��1�̎���VWV�Ƃ݂͂Ȃ��Ȃ��B
                    Pump_VWVcoeffi(iPUMP,iPUMPSUB,1) = 0;  % 4���̌W��
                    Pump_VWVcoeffi(iPUMP,iPUMPSUB,2) = 0;  % 3���̌W��
                    Pump_VWVcoeffi(iPUMP,iPUMPSUB,3) = 0;  % 2���̌W��
                    Pump_VWVcoeffi(iPUMP,iPUMPSUB,4) = 0;  % 1���̌W��
                    Pump_VWVcoeffi(iPUMP,iPUMPSUB,5) = 1;  % �ؕ�
                    pumpVWVmin(iPUMP,iPUMPSUB) = 1;
                else
                    error('VWV�̍ŏ��J�x�̐ݒ肪�s���ł�')
                end
                
                if check == 0
                    error('XML�t�@�C�����s���ł�')
                end
        end
        
    end
    
    % �ڑ��󒲋@
    tmpAHUSet = {};
    tmpSpump  = 0;
    for iAHU = 1:numOfAHUSET
        if PUMPtype(iPUMP) == 1
            if strcmp(pumpName{iPUMP},ahuPump_cooling(iAHU)) % �␅�|���v
                tmpAHUSet = [tmpAHUSet,ahuSetName(iAHU)];
                tmpSpump  = tmpSpump + ahuS(iAHU);
            end
        elseif PUMPtype(iPUMP) == 2
            if strcmp(pumpName{iPUMP},ahuPump_heating(iAHU)) % �����|���v
                tmpAHUSet = [tmpAHUSet,ahuSetName(iAHU)];
                tmpSpump  = tmpSpump + ahuS(iAHU);
            end
        end
    end
    
    PUMPahuSet{iPUMP,:} = tmpAHUSet;
    pumpS(iPUMP)        = tmpSpump;    % �|���v�n�����Ƃ̋󒲑Ώۖʐ�
    
end


%----------------------------------
% �M���̃p�����[�^

QrefrMax  = zeros(1,numOfRefs);  % �e�Q�̒�i�ő�\�́i�S�䐔���v�j
REFtype   = zeros(1,numOfRefs);  % �Q�̉^�]���[�h�i�P�F��[�A�Q�F�g�[�j
% TC        = zeros(1,numOfRefs);  % �������x [��]
REFnumctr = zeros(1,numOfRefs);  % �䐔����̗L���i�O�F�Ȃ��A�P�F����j
REFstorage = zeros(1,numOfRefs);  % �~�M����̗L���i�O�F�Ȃ��A�P�F����j
refS      = zeros(1,numOfRefs);  % �M���Q�ʂ̋󒲖ʐ� [m2]
REFCHmode = zeros(1,numOfRefs);  % ��g�����^�]�̗L���i�O�F�Ȃ��A�P�F����j

xXratioMX = ones(numOfRefs,3,3).*NaN;

for iREF = 1:numOfRefs
    
    % ��i�ő�\�́i�S�䐔���v�j
    QrefrMax(iREF) = nansum(refset_Capacity(iREF,:));
    
    % �^�]���[�h
    switch refsetMode{iREF}
        case 'Cooling'
            REFtype(iREF) = 1;
        case 'Heating'
            REFtype(iREF) = 2;
        otherwise
            error('�M���Q�̉^�]���[�h %s �͕s���ł�',refsetMode{iREF})
    end
    
    % ��g�����^�]
    switch refsetSupplyMode{iREF}
        case 'True'
            REFCHmode(iREF) = 1;
        case 'False'
            REFCHmode(iREF) = 0;
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
        case {'Charge_others','Charge_water_mixing',...
                'Charge_water_stratificated','Charge_ice'}
            REFstorage(iREF) = 1;
        case 'Discharge'
            REFstorage(iREF) = -1;
        case {'Null','None'}
            REFstorage(iREF) = 0;
        otherwise
            error('XML�t�@�C�����s���ł�')
    end
    
    % �ڑ��|���v
    tmpPUMPSet = {};
    tmpSref    = 0;
    for iAHU = 1:numOfAHUSET
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
    refS(iREF)         = tmpSref;     % �M���Q�ʂ̋󒲖ʐ� [m2]    
    
end


% �e�󒲋@�����ǎ���(0�Ȃ��g�ؑցA1�Ȃ��g����)
AHUCHmode_C = zeros(numOfAHUSET,1);
AHUCHmode_H = zeros(numOfAHUSET,1);
AHUCHmode   = zeros(numOfAHUSET,1);
for iAHU = 1:numOfAHUSET
    for iDB = 1:numOfRefs
        if strcmp(ahuRef_cooling{iAHU},refsetID{iDB})
            AHUCHmode_C(iAHU) = REFCHmode(iDB);
        end
        if strcmp(ahuRef_heating{iAHU},refsetID{iDB})
            AHUCHmode_H(iAHU) = REFCHmode(iDB);
        end
    end
    
    % �����Ƃ���g�����Ȃ�A���̋󒲋@�͗�g�����^�]�\�Ƃ���B
    if AHUCHmode_C(iAHU) == 1 && AHUCHmode_H(iAHU) == 1
        AHUCHmode(iAHU) = 1;
    end
end






