% ECS_routeB_HW_run_v1.m
%                                          by Masato Miyata 2011/03/06
%----------------------------------------------------------------------
% �����v�Z�v���O����
%----------------------------------------------------------------------
% function E_eqpSUMperAREA = ECS_routeB_HW_run_v1(climateAREA,buildingType,filename_HWroom,filename_HWequipment)

clear
clc
% �n��
climateAREA = 'IVa';
% �����p�r
buildingType = '�a�@��';
% �t�@�C�����w��
filename_HWroom      = '�ȃG�l����[�gB_����_���V�[�g.csv';
filename_HWequipment = '�ȃG�l����[�gB_����_�@��V�[�g.csv';

% �f�[�^�x�[�X�t�@�C��
filename_calendar             = './database/CALENDAR.csv';   % �J�����_�[
filename_ClimateArea          = './database/AREA.csv';       % �n��敪
filename_RoomTypeList         = './database/ROOM_SPEC.csv';  % ���p�r���X�g
filename_roomOperateCondition = './database/ROOM_COND.csv';  % �W�����g�p����
filename_refList              = './database/REFLIST.csv';    % �M���@�탊�X�g
filename_performanceCurve     = './database/REFCURVE.csv';   % �M������

mytscript_readDBfiles;

ULLLIST = [0.159,0.191,0.191,0.599;
    0.189,0.213,0.231,0.838;
    0.218,0.270,0.270,1.077;
    0.242,0.303,0.303,1.282;
    0.237,0.354,0.354,1.610;
    0.257,0.388,0.388,1.832;
    0.296,0.457,0.457,2.281;
    0.346,0.472,0.548,2.876;
    0.387,0.532,0.621,3.359;
    0.466,0.651,0.651,4.309;
    0.464,0.770,0.770,5.270;
    0.528,0.774,0.889,6.228];

% �C�ۃf�[�^�̓ǂݍ���
switch climateAREA
    case 'Ia'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_Ia.dat');
        WIN = [1:120,305:365]; MID = [121:181,274:304]; SUM = [182:273];
        TWdata = 0.6639.*OAdataAll(:,1) + 3.466;
    case 'Ib'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_Ib.dat');
        WIN = [1:120,305:365]; MID = [121:181,274:304]; SUM = [182:273];
        TWdata = 0.6639.*OAdataAll(:,1) + 3.466;
    case 'II'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_II.dat');
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        TWdata = 0.6054.*OAdataAll(:,1) + 4.515;
    case 'III'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_III.dat');
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        TWdata = 0.6054.*OAdataAll(:,1) + 4.515;
    case 'IVa'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_IVa.dat');
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        TWdata = 0.8660.*OAdataAll(:,1) + 1.665;
    case 'IVb'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_IVb.dat');
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        TWdata = 0.8516.*OAdataAll(:,1) + 2.473;
    case 'V'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_V.dat');
        WIN = [1:90,335:365]; MID = [91:151,274:334]; SUM = [152:273];
        TWdata = 0.9223.*OAdataAll(:,1) + 2.097;
    case 'VI'
        [OAdataAll,OAdataDay,OAdataNgt,OAdataHourly] = mytfunc_weathdataRead('weathdat/weath_VI.dat');
        WIN = [1:90]; MID = [91:120,305:365]; SUM = [121:304];
        TWdata = 0.6921.*OAdataAll(:,1) + 7.167;
    otherwise
        error('�n��R�[�h���s���ł�')
end

% �G�߈ˑ��ϐ��̒�`�i�����ݒ艷�x�j
Troom = zeros(365,1);
for iWIN = 1:length(WIN)
    Troom(WIN(iWIN),1) = 22;
end
for iMID = 1:length(MID)
    Troom(MID(iMID),1) = 24; % ���Ԋ�
end
for iSUM = 1:length(SUM)
    Troom(SUM(iSUM),1) = 26; % �Ċ�
end


%% CSV�t�@�C���̓ǂݍ���

% % �������Ɋւ�����
% hwRoomInfoCSV = textread(filename_HWroom,'%s','delimiter','\n','whitespace','');
% 
% hwRoomInfoCell = {};
% for i=1:length(hwRoomInfoCSV)
%     conma = strfind(hwRoomInfoCSV{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             hwRoomInfoCell{i,j} = hwRoomInfoCSV{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             hwRoomInfoCell{i,j}   = hwRoomInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%             hwRoomInfoCell{i,j+1} = hwRoomInfoCSV{i}(conma(j)+1:end);
%         else
%             hwRoomInfoCell{i,j} = hwRoomInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end
% 
% for iROOM = 11:size(hwRoomInfoCell,1)
%     % ������
%     roomName{iROOM-10} = strcat(hwRoomInfoCell(iROOM,1),'_',hwRoomInfoCell(iROOM,2));
%     % ���p�r
%     roomType{iROOM-10} = hwRoomInfoCell(iROOM,3);
%     % ���ʐ� [m2]
%     roomArea(iROOM-10) = str2double(hwRoomInfoCell(iROOM,4));
%     % �ߓ����̗L��
%     if strcmp(hwRoomInfoCell(iROOM,6),'��') == 1
%         roomWsave(iROOM-10) = 1;
%     else
%         roomWsave(iROOM-10) = 0;
%     end
%     % �ڑ��@�탊�X�g
%     tmpHWequip = {};
%     for iEQP = 1:length(hwRoomInfoCell(iROOM,:))-7
%         if isempty(hwRoomInfoCell{iROOM,7+iEQP}) == 0
%             tmpHWequip = [tmpHWequip,hwRoomInfoCell(iROOM,7+iEQP)];
%         end
%     end
%     roomEquipSet{iROOM-10,:} =  tmpHWequip;
% end

% % �����@��Ɋւ�����
% hwequipInfoCSV = textread(filename_HWequipment,'%s','delimiter','\n','whitespace','');
% 
% hwequipInfoCell = {};
% for i=1:length(hwequipInfoCSV)
%     conma = strfind(hwequipInfoCSV{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             hwequipInfoCell{i,j} = hwequipInfoCSV{i}(1:conma(j)-1);
%         elseif j == length(conma)
%             hwequipInfoCell{i,j}   = hwequipInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%             hwequipInfoCell{i,j+1} = hwequipInfoCSV{i}(conma(j)+1:end);
%         else
%             hwequipInfoCell{i,j} = hwequipInfoCSV{i}(conma(j-1)+1:conma(j)-1);
%         end
%     end
% end
% 
% for iEQP = 11:size(hwequipInfoCell,1)
%     % �@��R�[�h
%     equipID(iEQP-10) = hwequipInfoCell(iEQP,1);
%     % �@��R�[�h
%     equipName(iEQP-10) = strcat(hwequipInfoCell(iEQP,2),'_',hwequipInfoCell(iEQP,3));
%     % �䐔
%     equipNum(iEQP-10) = str2double(hwequipInfoCell(iEQP,4));
%     % ���M�e�� [kW/��]
%     equipPower(iEQP-10) = str2double(hwequipInfoCell(iEQP,5));
%     % �M������ [-]
%     equipEffi(iEQP-10) = str2double(hwequipInfoCell(iEQP,6));
%     % �ۉ��d�l
%     if strcmp(hwequipInfoCell(iEQP,7),'�ۉ��d�l�P')
%         equipInsulation(iEQP-10) = 1;
%     elseif strcmp(hwequipInfoCell(iEQP,7),'�ۉ��d�l�Q')
%         equipInsulation(iEQP-10) = 2;
%     elseif strcmp(hwequipInfoCell(iEQP,7),'�ۉ��d�l�R')
%         equipInsulation(iEQP-10) = 3;
%     else
%         equipInsulation(iEQP-10) = 4;
%     end
%     % �ڑ����a
%     equipPipeSize(iEQP-10) = str2double(hwequipInfoCell(iEQP,8));
%     if equipPipeSize(iEQP-10) <= 13
%         ULLnum(iEQP-10) = 1;
%     elseif equipPipeSize(iEQP-10) <= 20
%         ULLnum(iEQP-10) = 2;
%     elseif equipPipeSize(iEQP-10) <= 25
%         ULLnum(iEQP-10) = 3;
%     elseif equipPipeSize(iEQP-10) <= 30
%         ULLnum(iEQP-10) = 4;
%     elseif equipPipeSize(iEQP-10) <= 40
%         ULLnum(iEQP-10) = 5;
%     elseif equipPipeSize(iEQP-10) <= 50
%         ULLnum(iEQP-10) = 6;
%     elseif equipPipeSize(iEQP-10) <= 60
%         ULLnum(iEQP-10) = 7;
%     elseif equipPipeSize(iEQP-10) <= 75
%         ULLnum(iEQP-10) = 8;
%     elseif equipPipeSize(iEQP-10) <= 80
%         ULLnum(iEQP-10) = 9;
%     elseif equipPipeSize(iEQP-10) <= 100
%         ULLnum(iEQP-10) = 10;
%     elseif equipPipeSize(iEQP-10) <= 125
%         ULLnum(iEQP-10) = 11;
%     else
%         ULLnum(iEQP-10) = 12;
%     end
%     
%     ULL(iEQP-10) = ULLLIST(ULLnum(iEQP-10),equipInsulation(iEQP-10));
%     
%     % ���z�M���p
%     if strcmp(hwequipInfoCell(iEQP,9),'�L')
%         equipSolar(iEQP-10) = 1;
%     else
%         equipSolar(iEQP-10) = 0;
%     end
% end


%% �e���̋�����[L/day]�����߂�B

Qsr_std      = zeros(1,length(roomName));
wscType      = zeros(1,length(roomName));
calenderP2   = zeros(1,length(roomName));
calenderType = zeros(365,length(roomName));
scheduleHW   = zeros(365,length(roomName));
Qsr_daily    = zeros(365,length(roomName));
Qs_daily     = zeros(365,length(roomName));
Qs_save      = zeros(365,length(roomName));

for iROOM = 1:length(roomName)
    
    % �W�����g�p������T��
    for iDB = 1:length(perDB_RoomType)
        if strcmp(perDB_RoomType{iDB,4},buildingType) && ...
                strcmp(perDB_RoomType{iDB,5},roomType{iROOM})
            
            % �W�����ώZ�����ʁ@Qs_std_day [L/day]
            if strcmp(perDB_RoomType{iDB,31},'[L/�l��]') || strcmp(perDB_RoomType{iDB,31},'[L/����]')
                Qsr_std(iROOM) = str2double(perDB_RoomType(iDB,10)) *...
                    str2double(perDB_RoomType(iDB,30)) * roomArea(iROOM);
            elseif strcmp(perDB_RoomType{iDB,31},'[L/�u��]')
                Qsr_std(iROOM) = str2double(perDB_RoomType(iDB,30)) * roomArea(iROOM);
            else
                error('�������ׂ�������܂���')
            end
            
            % �J�����_�[�p�^�[��
            if strcmp(perDB_RoomType(iDB,7),'A')
                calenderType(:,iROOM) = str2double(perDB_calendar(2:end,3));
            elseif strcmp(perDB_RoomType(iDB,7),'B')
                calenderType(:,iROOM) = str2double(perDB_calendar(2:end,4));
            elseif strcmp(perDB_RoomType(iDB,7),'C')
                calenderType(:,iROOM) = str2double(perDB_calendar(2:end,5));
            elseif strcmp(perDB_RoomType(iDB,7),'D')
                calenderType(:,iROOM) = str2double(perDB_calendar(2:end,6));
            elseif strcmp(perDB_RoomType(iDB,7),'E')
                calenderType(:,iROOM) = str2double(perDB_calendar(2:end,7));
            elseif strcmp(perDB_RoomType(iDB,7),'F')
                calenderType(:,iROOM) = str2double(perDB_calendar(2:end,8));
            else
                error('�J�����_�[�p�^�[�����s���ł�')
            end
            
            % �p�^�[��2�̔���i�ғ�����~���j
            if isempty(perDB_RoomType{iDB,18})
                calenderP2(iROOM) = 0;
            else
                calenderP2(iROOM) = 1;
            end
            
            % WSC�p�^�[��
            if strcmp(perDB_RoomType(iDB,8),'WSC1')
                wscType(iROOM) = 1;
            elseif strcmp(perDB_RoomType(iDB,8),'WSC2')
                wscType(iROOM) = 2;
            else
                error('WSC�p�^�[�����s���ł�')
            end
            
            % �����X�P�W���[��
            for dd = 1:365
                if calenderType(dd,iROOM) == 1
                    scheduleHW(dd,iROOM) = 1;
                elseif calenderType(dd,iROOM) == 2
                    if calenderP2(iROOM) == 1
                        scheduleHW(dd,iROOM) = 1;
                    else
                        scheduleHW(dd,iROOM) = 0;
                    end
                elseif calenderType(dd,iROOM) == 3
                    if wscType(iROOM) == 2 && calenderP2(iROOM) == 1
                        scheduleHW(dd,iROOM) = 1;
                    else
                        scheduleHW(dd,iROOM) = 0;
                    end
                else
                    error('�X�P�W���[���p�^�[�����s���ł�')
                end
            end
            
            % �W�����ώZ������ [L/day]
            Qsr_daily(:,iROOM) = scheduleHW(:,iROOM).* Qsr_std(iROOM);
            
            % �ߓ����l���������ώZ������[L/day]
            if roomWsave(iROOM) == 1
                Qs_save(:,iROOM)  = Qsr_daily(:,iROOM).*0.25;
                Qs_daily(:,iROOM) = Qsr_daily(:,iROOM).*(1-0.25);
            else
                Qs_daily(:,iROOM) = Qsr_daily(:,iROOM);
            end
            
        end
    end
    if Qsr_std(iROOM) == 0
        iROOM
        error('�������ׂ�������܂���')
    end
end


%% �e���M���̗e�ʔ�����߂�B

for iROOM = 1:length(roomName)
    
    % �����M�e�ʂ����߂�B
    equipPowerSum(iROOM) = 0;
    equipPowerEach = [];
    for iEQPLIST = 1:length(roomEquipSet{iROOM})
        % �@�탊�X�g��T�����A���M�e�ʂ𑫂��B
        check = 0;
        for iEQP = 1:length(equipID)
            if strcmp(roomEquipSet{iROOM}(iEQPLIST),equipID(iEQP))
                equipPowerEach = [equipPowerEach, equipPower(iEQP)*equipNum(iEQP)];
                equipPowerSum(iROOM) = equipPowerSum(iROOM) + equipPower(iEQP)*equipNum(iEQP);
                check = 1;
            end
        end
        if check == 0
            error('�@�킪������܂���')
        end
    end
    
    % �e�ʔ�
    for iEQPLIST = 1:length(roomEquipSet{iROOM})
        roomPowerRatio(iROOM,iEQPLIST) = equipPowerEach(iEQPLIST)./equipPowerSum(iROOM);
    end
    
end


%% �@��̃G�l���M�[����ʌv�Z
L_eqp = zeros(length(equipID));
Qsr_eqp_daily = zeros(365,length(equipID));
Qs_eqp_daily  = zeros(365,length(equipID));
Qs_solargain  = zeros(365,length(equipID));
Qh_eqp_daily  = zeros(365,length(equipID));
Qp_eqp        = zeros(365,length(equipID));
E_eqp         = zeros(365,length(equipID));
connect_Name   = cell(length(equipID));
connect_Power  = cell(length(equipID));

for iEQP = 1:length(equipID)
    
    % �ڑ����鎺��T��
    tmpconnectName = {};
    tmpconnectPower = {};
    for iROOM = 1:length(roomName)
        for iEQPLIST = 1:length(roomEquipSet{iROOM})
            if strcmp(equipID(iEQP),roomEquipSet{iROOM}(iEQPLIST))
                % �W�����ώZ������ [L/day]
                Qsr_eqp_daily(:,iEQP) = Qsr_eqp_daily(:,iEQP) + Qsr_daily(:,iROOM).*roomPowerRatio(iROOM,iEQPLIST);
                % ���ώZ������ [L/day]
                Qs_eqp_daily(:,iEQP)  = Qs_eqp_daily(:,iEQP) + Qs_daily(:,iROOM).*roomPowerRatio(iROOM,iEQPLIST);
                % ���ڑ��ۑ�
                tmpconnectName = [tmpconnectName,roomName{iROOM}];
                tmpconnectPower = [tmpconnectPower,num2str(roomPowerRatio(iROOM,iEQPLIST))];
            end
        end
    end
    connect_Name{iEQP} = tmpconnectName;
    connect_Power{iEQP} = tmpconnectPower;
    
    % ���z�M���p�ʁi����̉ۑ�j[KJ/day]
    Qs_solargain(:,iEQP) = zeros(365,1);
    
    % �������� [kJ/day]
    Qh_eqp_daily(:,iEQP) = 4.2.*Qs_eqp_daily(:,iEQP).*(43-TWdata);
    
    % �z�ǒ� [m]
    L_eqp(iEQP) = max(Qsr_eqp_daily(:,iEQP)).*7*0.001;
    
    % �z�ǔM���� [kJ/day]
    for dd = 1:365
        if Qh_eqp_daily(dd,iEQP) > 0
            Qp_eqp(dd,iEQP) = L_eqp(iEQP).*ULL(iEQP).*(60-(OAdataAll(dd,1)+Troom(dd,1))/2)*24*3600*0.001;
        end
    end
    
    % �N�ԏ���G�l���M�[����� [kJ/day]
    E_eqp(:,iEQP) = (Qh_eqp_daily(:,iEQP) + Qp_eqp(:,iEQP)*2.5 ) ./ equipEffi(iEQP);
    
end

% �������P�� [MJ/m2�N]
E_eqpSUM = sum(E_eqp)/1000;
E_eqpSUMperAREA = sum(sum(E_eqp))/sum(roomArea)/1000;



%% ���ʏo��

% ���ʏo��(��)
RES0 = [];
for iROOM = 1:length(roomName)
    RES0 = [RES0,Qsr_daily(:,iROOM),Qs_save(:,iROOM),Qs_daily(:,iROOM)];
end
RES1 = [Troom,OAdataAll(:,1),TWdata,(OAdataAll(:,1)+Troom)/2];
RES2 = [];
for iEQP = 1:length(equipID)
    RES2 = [RES2,Qsr_eqp_daily(:,iEQP),Qs_eqp_daily(:,iEQP),Qs_solargain(:,iEQP),Qh_eqp_daily(:,iEQP),Qp_eqp(:,iEQP),E_eqp(:,iEQP),NaN*ones(365,1)];
end


% �o�͂���t�@�C����
if isempty(strfind(filename_HWroom,'/'))
    eval(['resfilenameD = ''calcRESdetail_',filename_HWroom(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(filename_HWroom,'/');
    eval(['resfilenameD = ''calcRESdetail_',filename_HWroom(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end

% ���ʊi�[�p�ϐ�
rfc = {};

% ���ʂ̋�������
rfc = [rfc;'�ꎟ�G�l���M�[�����,'];
rfc = mytfunc_oneLinecCell(rfc,equipName);
rfc = mytfunc_oneLinecCell(rfc,E_eqpSUM);
rfc = mytfunc_oneLinecCell(rfc,sum(E_eqpSUM));
rfc = mytfunc_oneLinecCell(rfc,E_eqpSUMperAREA);

rfc = [rfc;'�������׌v�Z,'];

for iROOM = 1:length(roomName)
    
    tmproomWsave = {};
    if roomWsave(iROOM) == 1
        tmproomWsave = '�L';
    else
        tmproomWsave = '��';
    end
    rfc = [rfc; strcat(roomName{iROOM},',',roomType{iROOM},',',num2str(roomArea(iROOM)),',',tmproomWsave)];
    
    rfc = mytfunc_oneLinecCell(rfc,Qsr_daily(:,iROOM)');
    rfc = mytfunc_oneLinecCell(rfc,Qs_save(:,iROOM)');
    rfc = mytfunc_oneLinecCell(rfc,Qs_daily(:,iROOM)');
end

rfc = [rfc;'�G�l���M�[�v�Z�V�[�g,'];

for iEQP = 1:length(equipID)
    
    rfc = [rfc; strcat(equipID{iEQP},',',equipName{iEQP})];
    
    % ���ڑ�
    roomlist = [];
    for iROOM = 1:length(connect_Name{iEQP})
        roomlist = strcat(roomlist,connect_Name{iEQP}(iROOM),',');
    end
    rfc = [rfc;roomlist];
    
    ratiolist = [];
    for iROOM = 1:length(connect_Power{iEQP})
        ratiolist = strcat(ratiolist,connect_Power{iEQP}(iROOM),',');
    end
    rfc = [rfc;ratiolist];
    
    tmpequipInsulation = {};
    if equipInsulation(iEQP) == 1
        tmpequipInsulation = '�ۉ��d�l�P';
    elseif equipInsulation(iEQP) == 2
        tmpequipInsulation = '�ۉ��d�l�Q';
    elseif equipInsulation(iEQP) == 3
        tmpequipInsulation = '�ۉ��d�l�R';
    elseif equipInsulation(iEQP) == 4
        tmpequipInsulation = '����';
    end
    tmpequipSolar = {};
    if equipSolar(iEQP) == 1
        tmpequipSolar = '�L';
    elseif equipSolar(iEQP) == 0
        tmpequipSolar = '��';
    end
    
    rfc = [rfc; strcat(num2str(equipNum(iEQP)),',',num2str(equipPower(iEQP)),',',num2str(equipEffi(iEQP)),...
        ',',num2str(equipPipeSize(iEQP)),',SUS,',tmpequipInsulation,',',tmpequipSolar)];
    rfc = mytfunc_oneLinecCell(rfc,Troom');
    rfc = mytfunc_oneLinecCell(rfc,OAdataAll(:,1)');
    rfc = mytfunc_oneLinecCell(rfc,TWdata');
    rfc = mytfunc_oneLinecCell(rfc,(OAdataAll(:,1)+Troom)'./2);
    rfc = mytfunc_oneLinecCell(rfc,Qsr_eqp_daily(:,iEQP)');
    rfc = mytfunc_oneLinecCell(rfc,Qs_eqp_daily(:,iEQP)');
    rfc = mytfunc_oneLinecCell(rfc,Qs_solargain(:,iEQP)');
    rfc = mytfunc_oneLinecCell(rfc,Qh_eqp_daily(:,iEQP)');
    rfc = mytfunc_oneLinecCell(rfc,Qp_eqp(:,iEQP)');
    rfc = mytfunc_oneLinecCell(rfc,E_eqp(:,iEQP)');
    
end

%% �o��
fid = fopen(resfilenameD,'w+');
for i=1:size(rfc,1)
    fprintf(fid,'%s\r\n',rfc{i});
end
fclose(fid);

