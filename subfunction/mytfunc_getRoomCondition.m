% mytfunc_getRoomCondition.m
%--------------------------------------------------------------------------
% ���g�p�����f�[�^�x�[�X���玞�n��^�]���Ԃ��쐬����B
%--------------------------------------------------------------------------

function [opeMode_V,opeMode_L,opeMode_HW] = ...
    mytfunc_getRoomCondition(perDB_RoomType,perDB_RoomOpeCondition,perDB_calendar,buildingType,roomType)
 
% buildingType = 'Office';
% roomType = '�@�B��';


check = 0;  % �󒲎��A��󒲎��ŏ����𕪂���

opeMode_L = zeros(365,24);
opeMode_V = zeros(365,24);
opeMode_HW = zeros(365,24);


% �f�[�^�x�[�X�iperDB_RoomType.csv�j�̌���
for iDB = 2:size(perDB_RoomType,1)
    if strcmp(perDB_RoomType(iDB,2),buildingType) &&...
            strcmp(perDB_RoomType(iDB,5),roomType)
        
        
        % �J�����_�[�ԍ�
        if strcmp(cell2mat(perDB_RoomType(iDB,7)),'A') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'1')
            roomClarendarNum = 1;
        elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'B') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'2')
            roomClarendarNum = 2;
        elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'C') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'3')
            roomClarendarNum = 3;
        elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'D') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'4')
            roomClarendarNum = 4;
        elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'E') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'5')
            roomClarendarNum = 5;
        elseif strcmp(cell2mat(perDB_RoomType(iDB,7)),'F') || strcmp(cell2mat(perDB_RoomType(iDB,7)),'6')
            roomClarendarNum = 6;
        else
            perDB_RoomType(iDB,7)
            error('�J�����_�[�i���o�[���s���ł�')
        end
        
        % WSC�p�^�[��
        if strcmp(perDB_RoomType(iDB,8),'WSC1')
            roomWSC = 1;
            check = 1;
        elseif strcmp(perDB_RoomType(iDB,8),'WSC2')
            roomWSC = 2;
            check = 1;
        elseif isempty(perDB_RoomType{iDB,8})  % ��󒲎�
            roomWSC = 1;
            check = 2;
        else
            perDB_RoomType(iDB,8)
            error('WSC�p�^�[�����s���ł��B')
        end
        
        % �N�ԋ󒲎���
        timeAC  = str2double(perDB_RoomType(iDB,22));
        % �N�Ԋ��C����
        timeV  = str2double(perDB_RoomType(iDB,26));
        % �N�ԏƖ�����
        timeL  = str2double(perDB_RoomType(iDB,23));
        % �N�ԋ�������
        timeHW = str2double(perDB_RoomType(iDB,32));
        
        % �ȉ��͋󒲎��̂�
        if check == 1
            
            % �e���̋󒲊J�n�E�I������
            roomTime_start_p1_1  = str2double(cell2mat(perDB_RoomType(iDB,14))); % �p�^�[��1_�󒲊J�n����(1)
            roomTime_stop_p1_1   = str2double(cell2mat(perDB_RoomType(iDB,15))); % �p�^�[��1_�󒲏I������(1)
            roomTime_start_p1_2  = str2double(cell2mat(perDB_RoomType(iDB,16))); % �p�^�[��1_�󒲊J�n����(2)
            roomTime_stop_p1_2   = str2double(cell2mat(perDB_RoomType(iDB,17))); % �p�^�[��1_�󒲏I������(2)
            roomTime_start_p2_1  = str2double(cell2mat(perDB_RoomType(iDB,18))); % �p�^�[��2_�󒲊J�n����(1)
            roomTime_stop_p2_1   = str2double(cell2mat(perDB_RoomType(iDB,19))); % �p�^�[��2_�󒲏I������(1)
            roomTime_start_p2_2  = str2double(cell2mat(perDB_RoomType(iDB,20))); % �p�^�[��2_�󒲊J�n����(2)
            roomTime_stop_p2_2   = str2double(cell2mat(perDB_RoomType(iDB,21))); % �p�^�[��2_�󒲏I������(2)
            
            % �p�^�[���P
            if isnan(roomTime_start_p1_2)
                roomTime_start_p1  = roomTime_start_p1_1;
                roomTime_stop_p1   = roomTime_stop_p1_1;
                roomDayMode = 1; % �g�p���ԑсi�P�F���A�Q�F��A�O�F�I���j
            else
                roomTime_start_p1  = roomTime_start_p1_2;  % �����܂����ꍇ
                roomTime_stop_p1   = roomTime_stop_p1_1;
                roomDayMode = 2; % �g�p���ԑсi�P�F���A�Q�F��A�O�F�I���j
            end
            
            if roomTime_start_p1 == 0 && roomTime_stop_p1 == 24
                roomDayMode = 0; % �g�p���ԑсi�P�F���A�Q�F��A�O�F�I���j
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
            
            % �O�C������ [m3/h/m2]
            roomVoa_m3hm2 = str2double(cell2mat(perDB_RoomType(iDB,13)));
            
            % �@�픭�M�� [W/m2]
            roomEnergyOAappUnit = str2double(cell2mat(perDB_RoomType(iDB,11)));
            
            % �Ɩ����M�� [W/m2]
            roomEnergyLight = str2double(cell2mat(perDB_RoomType(iDB,9)));
            
            % �l�̔��M�� [�l/m2 * W/�l = W/m2]
            switch cell2mat(perDB_RoomType(iDB,12))
                case '1'
                    roomEnergyPerson = str2double(cell2mat(perDB_RoomType(iDB,10)))*92;
                case '2'
                    roomEnergyPerson = str2double(cell2mat(perDB_RoomType(iDB,10)))*106;
                case '3'
                    roomEnergyPerson = str2double(cell2mat(perDB_RoomType(iDB,10)))*119;
                case '4'
                    roomEnergyPerson = str2double(cell2mat(perDB_RoomType(iDB,10)))*131;
                case '5'
                    roomEnergyPerson = str2double(cell2mat(perDB_RoomType(iDB,10)))*145;
                otherwise
                    perDB_RoomType(iDB,10)
                    error('��Ƌ��x�w�����s���ł��B')
            end
            
            % �������M�ʂ̎����ϓ�
            roomKey = perDB_RoomType(iDB,1);  % �����L�[
            
            for iDB2 = 2:size(perDB_RoomOpeCondition,1)
                
                % �������g�p��
                if strcmp(perDB_RoomOpeCondition(iDB2,1),roomKey) &&...
                        strcmp(perDB_RoomOpeCondition(iDB2,4),'1')
                    if strcmp(perDB_RoomOpeCondition(iDB2,5),'1')
                        roomScheduleACratio(1,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'2')
                        roomScheduleACratio(2,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'3')
                        roomScheduleACratio(3,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    else
                        error('���g�p�p�^�[�����s���ł�')
                    end
                end
                
                % �@�픭�M���x�䗦
                if strcmp(perDB_RoomOpeCondition(iDB2,1),roomKey) &&...
                        strcmp(perDB_RoomOpeCondition(iDB2,4),'4')
                    if strcmp(perDB_RoomOpeCondition(iDB2,5),'1')
                        roomScheduleOAapp(1,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'2')
                        roomScheduleOAapp(2,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'3')
                        roomScheduleOAapp(3,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    else
                        error('���g�p�p�^�[�����s���ł�')
                    end
                end
                
                % �Ɩ����M���x�䗦
                if strcmp(perDB_RoomOpeCondition(iDB2,1),roomKey) &&...
                        strcmp(perDB_RoomOpeCondition(iDB2,4),'2')
                    if strcmp(perDB_RoomOpeCondition(iDB2,5),'1')
                        roomScheduleLight(1,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'2')
                        roomScheduleLight(2,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'3')
                        roomScheduleLight(3,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    else
                        error('���g�p�p�^�[�����s���ł�')
                    end
                end
                
                % �l�̔��M���x
                if strcmp(perDB_RoomOpeCondition(iDB2,1),roomKey) &&...
                        strcmp(perDB_RoomOpeCondition(iDB2,4),'3')
                    if strcmp(perDB_RoomOpeCondition(iDB2,5),'1')
                        roomSchedulePerson(1,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'2')
                        roomSchedulePerson(2,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    elseif strcmp(perDB_RoomOpeCondition(iDB2,5),'3')
                        roomSchedulePerson(3,:) = str2double(perDB_RoomOpeCondition(iDB2,8:31));
                    else
                        error('���g�p�p�^�[�����s���ł�')
                    end
                end
                
            end
            
            % �e���̉^�]���Ԃ̊��蓖��
            for dd=1:365
                if strcmp(perDB_calendar{1+dd,roomClarendarNum+2},'1')  % �^�]�p�^�[���P
                    roomTime_start(dd) = roomTime_start_p1;
                    roomTime_stop(dd)   = roomTime_stop_p1;
                    roomDailyOpePattern(dd) = 1;
                elseif strcmp(perDB_calendar{1+dd,roomClarendarNum+2},'2')  % �^�]�p�^�[���Q
                    roomTime_start(dd) = roomTime_start_p2;
                    roomTime_stop(dd)   = roomTime_stop_p2;
                    roomDailyOpePattern(dd) = 2;
                    
                elseif strcmp(perDB_calendar{1+dd,roomClarendarNum+2},'3')  % �^�]�p�^�[���R
                    
                    if roomWSC == 1
                        roomTime_start(dd)  = 0;
                        roomTime_stop(dd)   = 0;
                    elseif roomWSC == 2
                        roomTime_start(dd)  = roomTime_start_p2;
                        roomTime_stop(dd)   = roomTime_stop_p2;
                    end
                    roomDailyOpePattern(dd) = 3;
                    
                end
            end
            
            % �����ʂ̊��蓖��
            
            for dd = 1:365
                
                if strcmp(perDB_calendar{1+dd,roomClarendarNum+2},'1')  % �^�]�p�^�[���P
                    
                    % ���C
                    if timeV == timeAC
                        opeMode_V(dd,:) = roomScheduleACratio(1,:);
                    elseif timeV == timeL
                        opeMode_V(dd,:) = roomScheduleLight(1,:);
                    elseif timeV == 0
                        opeMode_V(dd,:) = zeros(1,24);
                    else
                        error('���C�^�]���Ԃ���܂�܂���')
                    end
                    % �Ɩ�
                    opeMode_L(dd,:) = roomScheduleLight(1,:);
                    % ����
                    opeMode_HW(dd,:) = roomScheduleACratio(1,:);
                    
                elseif strcmp(perDB_calendar{1+dd,roomClarendarNum+2},'2')  % �^�]�p�^�[���Q
                    
                    % ���C
                    if timeV == timeAC
                        opeMode_V(dd,:) = roomScheduleACratio(2,:);
                    elseif timeV == timeL
                        opeMode_V(dd,:) = roomScheduleLight(2,:);
                    elseif timeV == 0
                        opeMode_V(dd,:) = zeros(1,24);
                    else
                        error('���C�^�]���Ԃ���܂�܂���')
                    end
                    % �Ɩ�
                    opeMode_L(dd,:) = roomScheduleLight(2,:);
                    % ����
                    opeMode_HW(dd,:) = roomScheduleACratio(2,:);
                    
                elseif strcmp(perDB_calendar{1+dd,roomClarendarNum+2},'3')  % �^�]�p�^�[���R
                    
                    % ���C
                    if timeV == timeAC
                        opeMode_V(dd,:) = roomScheduleACratio(3,:);
                    elseif timeV == timeL
                        opeMode_V(dd,:) = roomScheduleLight(3,:);
                    elseif timeV == 0
                        opeMode_V(dd,:) = zeros(1,24);
                    else
                        error('���C�^�]���Ԃ���܂�܂���')
                    end
                    % �Ɩ�
                    opeMode_L(dd,:) = roomScheduleLight(3,:);
                    % ����
                    opeMode_HW(dd,:) = roomScheduleACratio(3,:);
                    
                end
                
            end
            
            % �����i�����_�ȉ��͎g��Ȃ��j
            for dd = 1:365
                for hh = 1:24
                    if opeMode_V(dd,hh) > 0
                        opeMode_V(dd,hh) = 1;
                    end
                    if opeMode_L(dd,hh) > 0
                        opeMode_L(dd,hh) = 1;
                    end
                    if opeMode_HW(dd,hh) > 0
                        opeMode_HW(dd,hh) = 1;
                    end
                end
            end
            
            % �����͋ϓ��Ɋ���U��
            for dd = 1:365
                if sum(opeMode_HW(dd,:)) ~= 0
                    tmp = 1/sum(opeMode_HW(dd,:));
                    for hh = 1:24
                        if opeMode_HW(dd,hh) ~= 0
                            opeMode_HW(dd,hh) = tmp;
                        end
                    end
                end
            end
            
        end
        
    end
end

if check == 2 % ��󒲎��̏ꍇ
    opeMode_V = ones(365,24).* (timeV / 8760);
    opeMode_L = ones(365,24).* (timeL / 8760);
end


if check == 0
    error('���p�r %s ��������܂���',strcat(buildingType,':',roomType))
end












