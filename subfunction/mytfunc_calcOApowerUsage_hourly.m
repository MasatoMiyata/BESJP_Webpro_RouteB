% mytscript_calcOApowerUsage.m
%                                             by Masato Miyata
%---------------------------------------------------------------
% �ȃG�l��FOA�@��̏���d�͗ʂ��v�Z���� [MJ/m2]
%---------------------------------------------------------------
function y = mytfunc_calcOApowerUsage_hourly(BldgType,RoomType,perDB_RoomType,perDB_calendar)

% % �e�X�g�p
% clear
% clc
% BldgType = 'Office';
% RoomType = '������';

% �f�[�^�x�[�X�̓ǂݍ���
mytscript_readDBfiles;     % CSV�t�@�C���ǂݍ���

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
RoomTypeOAtime = zeros(length(RoomTypeNAME),3,24);
for iROOM = 1:length(RoomTypeNAME)

    for iDB = 2:size(perDB_RoomOpeCondition,1)
        if strcmp(RoomTypeKey(iROOM),perDB_RoomOpeCondition(iDB,1)) && ...
                strcmp(perDB_RoomOpeCondition(iDB,4),'4')
            
            if strcmp(perDB_RoomOpeCondition(iDB,5),'1')
                RoomTypeOAtime(iROOM,1,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'2')
                RoomTypeOAtime(iROOM,2,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            elseif strcmp(perDB_RoomOpeCondition(iDB,5),'3')
                RoomTypeOAtime(iROOM,3,:) = str2double(perDB_RoomOpeCondition(iDB,8:31));
            end
            
        end
    end
end

% ���M�ʔN�ώZ�l�̌v�Z
RoomOAComsumption = zeros(8760,length(RoomTypeNAME));

for iROOM = 1:length(RoomTypeNAME)
    if isnan(RoomTypeOA(iROOM)) == 0
        
        % �`�F�b�N
        if RoomTypeOA(iROOM) > 0 && sum(RoomTypeOAtime(iROOM,1,:)) == 0 || ...
                RoomTypeOA(iROOM) == 0 && sum(RoomTypeOAtime(iROOM,1,:)) > 0
            RoomTypeBLDG(iROOM)
            RoomTypeNAME(iROOM)
            RoomTypeOA(iROOM)
            RoomTypeOAtime(iROOM,1)
            error('��������')
        end
        
        for dd = 1:365
            for hh = 1:24
                
                nn = 24*(dd-1)+hh;
                
                % ���M�� [W/m2] * ���^�]���� [h] ���@[MWh/m2�N]
                RoomOAComsumption(nn,iROOM) = RoomTypeOA(iROOM).*RoomTypeOAtime(iROOM,RoomTypeCLND(dd,iROOM),hh)./1000000;
            end
        end
    end
end

y = RoomOAComsumption;

% �ꎟ�G�l���Z MJ/m2
% y = round(RoomOAComsumption .* 9760/3600);

% �����Z��ɂ��Ă͂O�ɂ���B
% if strcmp(RoomTypeBLDG,'ApartmentHouse')
%     y = 0;
% end


