% mytscript_calcOApowerUsage.m
%                                             by Masato Miyata
%---------------------------------------------------------------
% OA�@��̏���d�͂��u���̑��ꎟ�G�l���M�[����� MJ/m2�v���v�Z����i���P�ʁj�B
%---------------------------------------------------------------
% Eothers_perArea : ���̑��ꎟ�G�l���M�[����ʌ��P�� [MJ/m2]
% Eothers_MWh_hourly_perArea : ���̑�����d�͌��P�� [MWh/m2]
%---------------------------------------------------------------
function [Eothers_perArea,Eothers_MWh_hourly_perArea,Schedule_AC_hour, Schedule_LT_hour,Schedule_OA_hour] = ...
    mytfunc_calcOApowerUsage(BldgType,RoomType,perDB_RoomType,perDB_calendar,perDB_RoomOpeCondition)

% % �e�X�g�p
% clear
% clc
% BldgType = 'Office';
% RoomType = '������';
% mytscript_readDBfiles;     % CSV�t�@�C���ǂݍ���

check = 0;

% ���p�r����
for iDB = 1:length(perDB_RoomType)
    
    if strcmp(BldgType,perDB_RoomType(iDB,2)) && strcmp(RoomType,perDB_RoomType(iDB,5))
        
        check = 1;
        RoomTypeKey  = perDB_RoomType(iDB,1);  % ���p�r�L�[
        RoomTypeBLDG = perDB_RoomType(iDB,2);  % �����p�r����
        RoomTypeNAME = perDB_RoomType(iDB,5);  % ���p�r����
        RoomTypeCLNDPTN = perDB_RoomType(iDB,7);  % �J�����_�[
        RoomTypeOA   = str2double(perDB_RoomType(iDB,11)); % OA�@�픭�M�� [W/m2]
        
    end
end

if check == 0
    error('�����p�r�E���p�r���s���ł�')
end


% �J�����_�[�p�^�[��
RoomTypeCLND = zeros(365,length(RoomTypeNAME));
for iROOM = 1:length(RoomTypeCLNDPTN)
    if strcmp(RoomTypeCLNDPTN(iROOM),'A')
        RoomTypeCLND(:,iROOM) = str2double(perDB_calendar(2:end,3));
    elseif strcmp(RoomTypeCLNDPTN(iROOM),'B')
        RoomTypeCLND(:,iROOM) = str2double(perDB_calendar(2:end,4));
    elseif strcmp(RoomTypeCLNDPTN(iROOM),'C')
        RoomTypeCLND(:,iROOM) = str2double(perDB_calendar(2:end,5));
    elseif strcmp(RoomTypeCLNDPTN(iROOM),'D')
        RoomTypeCLND(:,iROOM) = str2double(perDB_calendar(2:end,6));
    elseif strcmp(RoomTypeCLNDPTN(iROOM),'E')
        RoomTypeCLND(:,iROOM) = str2double(perDB_calendar(2:end,7));
    elseif strcmp(RoomTypeCLNDPTN(iROOM),'F')
        RoomTypeCLND(:,iROOM) = str2double(perDB_calendar(2:end,8));
    else
        error('�J�����_�[�p�^�[�����s���ł�')
    end
end


% �X�P�W���[������
% perDB_RoomOpeCondition �ɂ͋󒲎������Ȃ��ɂ��Ƃɒ���
RoomTypeOAtime = zeros(length(RoomTypeNAME),3);

RoomTypeOAtime_hour = zeros(length(RoomTypeNAME),3,24);
RoomTypeACtime_hour = zeros(length(RoomTypeNAME),3,24);
RoomTypeLTtime_hour = zeros(length(RoomTypeNAME),3,24);

for iROOM = 1:length(RoomTypeNAME)
    
    for iDB = 2:size(perDB_RoomOpeCondition,1)
        
        % �@�픭�M���x�䗦�̒��o
        if strcmp(RoomTypeKey(iROOM),perDB_RoomOpeCondition(iDB,1)) && ...
                strcmp(perDB_RoomOpeCondition(iDB,4),'4')  % �u4�v�� �@�픭�M���x�䗦
            
            if strcmp(perDB_RoomOpeCondition(iDB,5),'1')
                RoomTypeOAtime(iROOM,1) = sum(str2double(perDB_RoomOpeCondition(iDB,8:31)));
                RoomTypeOAtime_hour(iROOM,1,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'2')
                RoomTypeOAtime(iROOM,2) = sum(str2double(perDB_RoomOpeCondition(iDB,8:31)));
                RoomTypeOAtime_hour(iROOM,2,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'3')
                RoomTypeOAtime(iROOM,3) = sum(str2double(perDB_RoomOpeCondition(iDB,8:31)));
                RoomTypeOAtime_hour(iROOM,3,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            end
            
        end
        
        % �󒲎��Ԃ̒��o
        if strcmp(RoomTypeKey(iROOM),perDB_RoomOpeCondition(iDB,1)) && ...
                strcmp(perDB_RoomOpeCondition(iDB,4),'1')  % �u1�v�� �������g�p��
            
            if strcmp(perDB_RoomOpeCondition(iDB,5),'1')
                RoomTypeACtime_hour(iROOM,1,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'2')
                RoomTypeACtime_hour(iROOM,2,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'3')
                RoomTypeACtime_hour(iROOM,3,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            end
            
        end

        % �Ɩ��_�����Ԃ̒��o
        if strcmp(RoomTypeKey(iROOM),perDB_RoomOpeCondition(iDB,1)) && ...
                strcmp(perDB_RoomOpeCondition(iDB,4),'2')  % �u2�v�� �Ɩ����M���x�䗦
            
            if strcmp(perDB_RoomOpeCondition(iDB,5),'1')
                RoomTypeLTtime_hour(iROOM,1,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'2')
                RoomTypeLTtime_hour(iROOM,2,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'3')
                RoomTypeLTtime_hour(iROOM,3,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            end
            
        end
        
    end
end

% ���M�ʔN�ώZ�l�̌v�Z
RoomOAComsumption = zeros(length(RoomTypeNAME),1);
RoomOA_MWh_hour   = zeros(8760,length(RoomTypeNAME));

Schedule_AC_hour = zeros(8760, length(RoomTypeNAME));  % �󒲃X�P�W���[��
Schedule_LT_hour = zeros(8760, length(RoomTypeNAME));  % �Ɩ����M�X�P�W���[��
Schedule_OA_hour = zeros(8760, length(RoomTypeNAME));  % �@�픭�M�X�P�W���[��

for iROOM = 1:length(RoomTypeNAME)
    if isnan(RoomTypeOA(iROOM)) == 0
        
        % �`�F�b�N
        if RoomTypeOA(iROOM) > 0 && RoomTypeOAtime(iROOM,1) == 0 || ...
                RoomTypeOA(iROOM) == 0 && RoomTypeOAtime(iROOM,1) > 0
            RoomTypeBLDG(iROOM)
            RoomTypeNAME(iROOM)
            RoomTypeOA(iROOM)
            RoomTypeOAtime(iROOM,1)
            error('�W������v���܂���')
        end
        
        for dd = 1:365
            
            % ���M�� [W/m2] * ���^�]���� [h] ���@[MJ/m2�N]
            RoomOAComsumption(iROOM) = RoomOAComsumption(iROOM) + ...
                RoomTypeOA(iROOM).*RoomTypeOAtime(iROOM,RoomTypeCLND(dd,iROOM))./1000000.*3600;
            
            % �R�W�F�l�v�Z�p ����d�͗ʂ������ʂɎZ�o�B
            for hh = 1:24
                nn = 24*(dd-1)+hh;
                
                % ���M�� [W/m2] * ���^�]���� [h] ���@[MWh/m2�N]
                RoomOA_MWh_hour(nn,iROOM) = RoomTypeOA(iROOM).*RoomTypeOAtime_hour(iROOM,RoomTypeCLND(dd,iROOM),hh)./1000000;
                
                if RoomTypeACtime_hour(iROOM,RoomTypeCLND(dd,iROOM),hh) > 0
                    Schedule_AC_hour(nn,iROOM) = 1;
                else
                    Schedule_AC_hour(nn,iROOM) = 0;
                end
                Schedule_LT_hour(nn,iROOM) = RoomTypeLTtime_hour(iROOM,RoomTypeCLND(dd,iROOM),hh);
                Schedule_OA_hour(nn,iROOM) = RoomTypeOAtime_hour(iROOM,RoomTypeCLND(dd,iROOM),hh);
                
            end
            
            
        end
    end
end

% �ꎟ�G�l���Z MJ/m2
Eothers_perArea = round(RoomOAComsumption .* 9760/3600);
Eothers_MWh_hourly_perArea = RoomOA_MWh_hour;

% �����Z��ɂ��Ă͂O�ɂ���B
if strcmp(RoomTypeBLDG,'ApartmentHouse')
    Eothers_perArea = 0;
end


