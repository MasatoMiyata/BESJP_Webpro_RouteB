% ECS_routeB_L_run.m
%                                          by Masato Miyata 2011/04/20
%----------------------------------------------------------------------
% �ȃG�l��F�Ɩ��v�Z�v���O����
%----------------------------------------------------------------------
% ����
%  inputfilename : XML�t�@�C������
%  OutputOption  : �o�͐���iON: �ڍ׏o�́AOFF: �ȈՏo�́j
% �o��
%  y(1) : �]���l [MWh/�N]
%  y(2) : �]���l [MWh/m2/�N]
%  y(3) : �]���l [MJ/�N]
%  y(4) : �]���l [MJ/m2/�N]
%  y(5) : ��l [MWh/�N]
%  y(6) : ��l [MWh/m2/�N]
%  y(7) : ��l [MJ/�N]
%  y(8) : ��l [MJ/m2/�N]
%  y(9) : BEI (=�]���l/��l�j [-]
%----------------------------------------------------------------------
% function y = ECS_routeB_L_run(inputfilename,OutputOption)

clear
clc
inputfilename = 'output.xml';
addpath('./subfunction/')
OutputOption = 'ON';


%% �ݒ�
model = xml_read(inputfilename);

switch OutputOption
    case 'ON'
        OutputOptionVar = 1;
    case 'OFF'
        OutputOptionVar = 0;
    otherwise
        error('OutputOption���s���ł��BON �� OFF �Ŏw�肵�ĉ������B')
end

% �f�[�^�x�[�X�t�@�C��
filename_calendar             = './database/CALENDAR.csv';   % �J�����_�[
filename_ClimateArea          = './database/AREA.csv';       % �n��敪
filename_RoomTypeList         = './database/ROOM_SPEC.csv';  % ���p�r���X�g
filename_roomOperateCondition = './database/ROOM_COND.csv';  % �W�����g�p����
filename_refList              = './database/REFLIST.csv';    % �M���@�탊�X�g
filename_performanceCurve     = './database/REFCURVE.csv';   % �M������

% �f�[�^�x�[�X�ǂݍ���
mytscript_readDBfiles;


%% ��񒊏o

% �Ɩ�����
numOfRoom =  length(model.LightingSystems.LightingRoom);

BldgType   = cell(numOfRoom,1);
RoomType   = cell(numOfRoom,1);
RoomFloor  = cell(numOfRoom,1);
RoomName   = cell(numOfRoom,1);
RoomArea   = zeros(numOfRoom,1);
RoomWidth  = zeros(numOfRoom,1);
RoomDepth  = zeros(numOfRoom,1);
RoomHeight = zeros(numOfRoom,1);
RoomIndex  = zeros(numOfRoom,1);
numofUnit  = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    BldgType{iROOM}  = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.BldgType;
    RoomType{iROOM}  = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomType;
    RoomFloor{iROOM} = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomFloor;
    RoomName{iROOM}  = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomName;
    RoomArea(iROOM)  = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomArea;
    
    if strcmp(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomWidth,'Null') == 0
        RoomWidth(iROOM)    = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomWidth;
    end
    if strcmp(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomDepth,'Null') == 0
        RoomDepth(iROOM)    = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomDepth;
    end
    if strcmp(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomHeight,'Null') == 0
        RoomHeight(iROOM)   = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomHeight;
    end
    if strcmp(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomIndex,'Null') == 0
        RoomIndex(iROOM)    = model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomIndex;
    end
    
    numofUnit(iROOM)  = length(model.LightingSystems.LightingRoom(iROOM).LightingUnit);
    
    for iUNIT = 1:numofUnit(iROOM)
        
        if strcmp(model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.Count,'Null') == 0
            Count(iROOM,iUNIT) = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.Count;
        end
        Power(iROOM,iUNIT) = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.Power;
        
        ControlFlag_C1{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C1;
        ControlFlag_C2{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C2;
        ControlFlag_C3{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C3;
        ControlFlag_C4{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C4;
        ControlFlag_C5{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C5;
        
        % ���j�b�g�^�C�v
        UnitType{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.UnitType;
        UnitName{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.UnitName;
        
    end
end


%% �e���̏Ɩ����ԁE��l��T��
timeL = zeros(numOfRoom,1);
Es    = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    % �W�����g�p������T��
    for iDB = 1:length(perDB_RoomType)
        if strcmp(perDB_RoomType{iDB,2},BldgType{iROOM}) && ...
                strcmp(perDB_RoomType{iDB,5},RoomType{iROOM})
            
            % �Ɩ����� [hour]
            timeL(iROOM) = str2double(perDB_RoomType(iDB,23));
            
            % ��ݒ����d�� [kW]
            Es(iROOM) = str2double(perDB_RoomType(iDB,25));
            
        end
    end
    
end


%% ���w���␳�W���̌���
hosei_RI = ones(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    % ���w���̌v�Z
    if RoomIndex(iROOM) == 0 || isempty(RoomIndex(iROOM))
        if RoomHeight(iROOM)*(RoomWidth(iROOM)+RoomDepth(iROOM)) ~= 0
            RoomIndex(iROOM) = (RoomWidth(iROOM)*RoomDepth(iROOM)) / ...
                ( RoomHeight(iROOM)*(RoomWidth(iROOM)+RoomDepth(iROOM)) );
        else
            RoomIndex(iROOM) = 2.5;  % �f�t�H���g�l
        end
    end
    
    % ���w���␳�W�� hosei_RI
    if isnan(RoomIndex(iROOM)) == 0
        if RoomIndex(iROOM) < 0.75
            hosei_RI(iROOM) = 0.50;
        elseif RoomIndex(iROOM) < 0.95
            hosei_RI(iROOM) = 0.60;
        elseif RoomIndex(iROOM) < 1.25
            hosei_RI(iROOM) = 0.70;
        elseif RoomIndex(iROOM) < 1.75
            hosei_RI(iROOM) = 0.80;
        elseif RoomIndex(iROOM) < 2.50
            hosei_RI(iROOM) = 0.90;
        elseif RoomIndex(iROOM) < 4.30
            hosei_RI(iROOM) = 1.00;
        else
            hosei_RI(iROOM) = 1.1;
        end
        
    end
end


%% ����␳�W���̌���

for iROOM = 1:numOfRoom
    for iUNIT = 1:numofUnit(iROOM)
        
        % �ݎ����m����
        if strcmp(ControlFlag_C1(iROOM,iUNIT),'None')
            hosei_C1(iROOM,iUNIT) = 1.0;
            hosei_C1_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'dimmer')
            hosei_C1(iROOM,iUNIT) = 0.80;
            hosei_C1_name{iROOM,iUNIT} = '�L��(��)';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'onoff')
            hosei_C1(iROOM,iUNIT) = 0.70;
            hosei_C1_name{iROOM,iUNIT} = '�L��(�_��)';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'sensing64')
            hosei_C1(iROOM,iUNIT) = 0.95;
            hosei_C1_name{iROOM,iUNIT} = '��(6.4m)';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'sensing32')
            hosei_C1(iROOM,iUNIT) = 0.85;
            hosei_C1_name{iROOM,iUNIT} = '��(3.2m)';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'eachunit')
            hosei_C1(iROOM,iUNIT) = 0.80;
            hosei_C1_name{iROOM,iUNIT} = '��(��)';
        else
            error('�ݎ����m����̕������s���ł�')
        end
        
        % �^�C���X�P�W���[������
        if strcmp(ControlFlag_C2(iROOM,iUNIT),'None')
            hosei_C2(iROOM,iUNIT) = 1.0;
            hosei_C2_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'dimmer')
            hosei_C2(iROOM,iUNIT) = 0.95;
            hosei_C2_name{iROOM,iUNIT} = '����';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'onoff')
            hosei_C2(iROOM,iUNIT) = 0.90;
            hosei_C2_name{iROOM,iUNIT} = '�_��';
        else
            error('�^�C���X�P�W���[������̕������s���ł�')
        end
        
        % �����Ɠx�␳����
        if strcmp(ControlFlag_C3(iROOM,iUNIT),'None')
            hosei_C3(iROOM,iUNIT) = 1.0;
            hosei_C3_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C3(iROOM,iUNIT),'Timer')
            hosei_C3(iROOM,iUNIT) = 0.90;
            hosei_C3_name{iROOM,iUNIT} = '�^�C�}�[';
        elseif strcmp(ControlFlag_C3(iROOM,iUNIT),'Sensor')
            hosei_C3(iROOM,iUNIT) = 0.85;
            hosei_C3_name{iROOM,iUNIT} = '�Z���T�[';
        else
            ControlFlag_C3(iROOM,iUNIT)
            error('�����Ɠx�␳����̕������s���ł�')
        end
        
        % �������p����
        if strcmp(ControlFlag_C4(iROOM,iUNIT),'None')
            hosei_C4(iROOM,iUNIT) = 1.0;
            hosei_C4_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'eachSideWithBlind')
            hosei_C4(iROOM,iUNIT) = 0.9;
            hosei_C4_name{iROOM,iUNIT} = '����VB��';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'eachSideWithoutBlind')
            hosei_C4(iROOM,iUNIT) = 0.85;
            hosei_C4_name{iROOM,iUNIT} = '����VB�L';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'bothSidesWithBlind')
            hosei_C4(iROOM,iUNIT) = 0.85;
            hosei_C4_name{iROOM,iUNIT} = '����VB��';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'bothSidesWithoutBlind')
            hosei_C4(iROOM,iUNIT) = 0.8;
            hosei_C4_name{iROOM,iUNIT} = '����VB�L';
        else
            error('�������p����̕������s���ł�')
        end
        
        if strcmp(ControlFlag_C5(iROOM,iUNIT),'None')
            hosei_C5(iROOM,iUNIT) = 1;
            hosei_C5_name{iROOM,iUNIT} = '�@';
        elseif strcmp(ControlFlag_C5(iROOM,iUNIT),'dimmer')
            hosei_C5(iROOM,iUNIT) = 0.8;
            hosei_C5_name{iROOM,iUNIT} = '�_��';
        else
            error('���邳���m����̕������s���ł�')
        end
        
        hosei_ALL(iROOM,iUNIT) = hosei_C1(iROOM,iUNIT)*hosei_C2(iROOM,iUNIT)*...
            hosei_C3(iROOM,iUNIT)*hosei_C4(iROOM,iUNIT)*hosei_C5(iROOM,iUNIT);
        
    end
end

%% �G�l���M�[����ʌv�Z

% �]���l Edesign [MJ/�N]
Edesign_noRI_MWh = repmat(timeL,1,max(numofUnit)).*Power.*Count.*(hosei_C1.*hosei_C2.*hosei_C3.*hosei_C4.*hosei_C5) ./1000000;
Edesign_noRI_MJ  = 9760.*Edesign_noRI_MWh;
Edesign_MWh      = repmat(timeL,1,max(numofUnit)).*repmat(hosei_RI,1,max(numofUnit))...
    .*Power.*Count.*(hosei_C1.*hosei_C2.*hosei_C3.*hosei_C4.*hosei_C5) ./1000000;
Edesign_MJ       = 9760.*Edesign_MWh;

% �]���l Edesign_m2 [MJ/m2�N]
Edesign_MWh_m2 = sum(nansum(Edesign_MWh))/sum(RoomArea);
Edesign_MJ_m2  = sum(nansum(Edesign_MJ))/sum(RoomArea);

% ��l Estandard [MJ/�N]
Estandard_MWh = Es.*RoomArea.*timeL./1000000;
Estandard_MJ  = 9760.*Estandard_MWh;
Estandard_MWh_m2 = nansum(Estandard_MWh)/sum(RoomArea);
Estandard_MJ_m2  = nansum(Estandard_MJ)/sum(RoomArea);

% �o��
y(1) = sum(nansum(Edesign_MWh));
y(2) = Edesign_MWh_m2;
y(3) = sum(nansum(Edesign_MJ));
y(4) = Edesign_MJ_m2;
y(5) = sum(nansum(Estandard_MWh));
y(6) = Estandard_MWh_m2;
y(7) = nansum(Estandard_MJ);
y(8) = Estandard_MJ_m2;
y(9) = y(4)/y(8);


%% �ȈՏo��
% �o�͂���t�@�C����
if isempty(strfind(inputfilename,'/'))
    eval(['resfilenameS = ''calcRES_L_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(inputfilename,'/');
    eval(['resfilenameS = ''calcRES_L_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end
csvwrite(resfilenameS,y);


%% �ڍ׏o��

if OutputOptionVar == 1
    
    rfc = {};
    for iROOM = 1:numOfRoom
        for iUNIT = 1:numofUnit(iROOM)
            
            tmpdata = '';
            
            if iUNIT == 1
                tmpdata = strcat(RoomFloor(iROOM),',',...
                    RoomName(iROOM),',',...
                    BldgType(iROOM),',',...
                    RoomType(iROOM),',',...
                    num2str(RoomHeight(iROOM)),',',...
                    num2str(RoomWidth(iROOM)),',',...
                    num2str(RoomDepth(iROOM)),',',...
                    num2str(RoomArea(iROOM)),',',...
                    num2str(RoomIndex(iROOM)),',',...
                    num2str(hosei_RI(iROOM)),',',...
                    UnitType(iROOM,iUNIT),',',...
                    UnitName(iROOM,iUNIT),',',...
                    num2str(Power(iROOM,iUNIT)),',',...
                    num2str(Count(iROOM,iUNIT)),',',...
                    num2str((Power(iROOM,iUNIT)*Count(iROOM,iUNIT))/RoomArea(iROOM)),',',...
                    num2str(Es(iROOM)),',',...
                    hosei_C1_name(iROOM,iUNIT),',',...
                    hosei_C2_name(iROOM,iUNIT),',',...
                    hosei_C3_name(iROOM,iUNIT),',',...
                    hosei_C4_name(iROOM,iUNIT),',',...
                    hosei_C5_name(iROOM,iUNIT),',',...
                    num2str(hosei_ALL(iROOM,iUNIT)),',',...
                    num2str(timeL(iROOM)),',',...
                    num2str(Edesign_MJ(iROOM,iUNIT)),',',...
                    num2str(Edesign_noRI_MJ(iROOM,iUNIT)),',',...
                    num2str(Estandard_MJ(iROOM)),',',...
                    num2str(sum(Edesign_MJ(iROOM,:))./Estandard_MJ(iROOM)));
                
            else
                tmpdata = strcat(',',...
                    ',',...
                    ',',...
                    ',',...
                    ',',...
                    ',',...
                    ',',...
                    ',',...
                    ',',...
                    ',',...
                    UnitType(iROOM,iUNIT),',',...
                    UnitName(iROOM,iUNIT),',',...
                    num2str(Power(iROOM,iUNIT)),',',...
                    num2str(Count(iROOM,iUNIT)),',',...
                    num2str((Power(iROOM,iUNIT)*Count(iROOM,iUNIT))/RoomArea(iROOM)),',',...
                    ',',...
                    hosei_C1_name(iROOM,iUNIT),',',...
                    hosei_C2_name(iROOM,iUNIT),',',...
                    hosei_C3_name(iROOM,iUNIT),',',...
                    hosei_C4_name(iROOM,iUNIT),',',...
                    hosei_C5_name(iROOM,iUNIT),',',...
                    num2str(hosei_ALL(iROOM,iUNIT)),',',...
                    ',',...
                    num2str(Edesign_MJ(iROOM,iUNIT)),',',...
                    num2str(Edesign_noRI_MJ(iROOM,iUNIT)),',',...
                    ',',...
                    ' ');
                
            end
            
            rfc = [rfc;tmpdata];
            
        end
    end
    
    % �o�͂���t�@�C����
    if isempty(strfind(inputfilename,'/'))
        eval(['resfilenameD = ''calcRESdetail_L_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(inputfilename,'/');
        eval(['resfilenameD = ''calcRESdetail_L_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % �o��
    fid = fopen(resfilenameD,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i,:});
    end
    fclose(fid);
    
end

