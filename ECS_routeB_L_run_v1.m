% ECS_routeB_L_run_v1.m
%                                          by Masato Miyata 2011/04/05
%----------------------------------------------------------------------
% �����v�Z�v���O����
%----------------------------------------------------------------------
function y = ECS_routeB_L_run_v1(inputfilename,OutputOption)

% clear
% clc
% tic
% inputfilename = 'output.xml';
% OutputOption = 'ON';

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

% �Ɩ���
numofUnit  = length(model.LightingSystems.LightingUnit);

BldgType   = cell(1,numofUnit);
RoomType   = cell(1,numofUnit);
RoomFloor  = cell(1,numofUnit);
RoomName   = cell(1,numofUnit);
RoomArea   = zeros(1,numofUnit);
RoomWidth  = zeros(1,numofUnit);
RoomDepth  = zeros(1,numofUnit);
RoomHeight = zeros(1,numofUnit);
RoomIndex  = zeros(1,numofUnit);
Count      = ones(1,numofUnit);
Power      = zeros(1,numofUnit);
ControlFlag_C1 = cell(1,numofUnit);
ControlFlag_C2 = cell(1,numofUnit);
ControlFlag_C3 = cell(1,numofUnit);
ControlFlag_C4 = cell(1,numofUnit);
UnitType = cell(1,numofUnit);
UnitName = cell(1,numofUnit);

for iUNIT = 1:numofUnit
    
    BldgType{iUNIT}     = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.BldgType;
    RoomFloor{iUNIT}    = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomFloor;
    RoomName{iUNIT}    = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomName;
    RoomType{iUNIT}     = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomType;
    RoomArea(iUNIT)     = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomArea;
    if strcmp(model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomWidth,'Null') == 0
        RoomWidth(iUNIT)    = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomWidth;
    end
    if strcmp(model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomDepth,'Null') == 0
        RoomDepth(iUNIT)    = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomDepth;
    end
    if strcmp(model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomHeight,'Null') == 0
        RoomHeight(iUNIT)   = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomHeight;
    end
    if strcmp(model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomIndex,'Null') == 0
        RoomIndex(iUNIT)    = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.RoomIndex;
    end
    if strcmp(model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.Count,'Null') == 0
        Count(iUNIT)        = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.Count;
    end
    Power(iUNIT)        = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.Power;
    
    ControlFlag_C1{iUNIT} = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C1;
    ControlFlag_C2{iUNIT} = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C2;
    ControlFlag_C3{iUNIT} = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C3;
    ControlFlag_C4{iUNIT} = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.ControlFlag_C4;
    
    % ���j�b�g�^�C�v
    UnitType{iUNIT} = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.UnitType;
    UnitName{iUNIT} = model.LightingSystems.LightingUnit(iUNIT).ATTRIBUTE.UnitName;
    
end

%% �e���̏Ɩ����Ԃ�T��
timeL = zeros(1,numofUnit);
Es    = zeros(1,numofUnit);

for iUNIT = 1:numofUnit
    
    % �W�����g�p������T��
    for iDB = 1:length(perDB_RoomType)
        if strcmp(perDB_RoomType{iDB,2},BldgType{iUNIT}) && ...
                strcmp(perDB_RoomType{iDB,5},RoomType{iUNIT})
            
            % �Ɩ����� [hour]
            timeL(iUNIT) = str2double(perDB_RoomType(iDB,23));
            
            % ��ݒ����d�� [kW]
            Es(iUNIT) = str2double(perDB_RoomType(iDB,25));
            
        end
    end
    
end

%% ���w���␳�W���̌���
hosei_RI = ones(1,numofUnit);

for iUNIT = 1:numofUnit
    
    % ���w���̌v�Z
    if RoomIndex(iUNIT) == 0 || isempty(RoomIndex(iUNIT))
        if RoomHeight(iUNIT)*(RoomWidth(iUNIT)+RoomDepth(iUNIT)) ~= 0
            RoomIndex(iUNIT) = (RoomWidth(iUNIT)*RoomDepth(iUNIT)) / ...
                ( RoomHeight(iUNIT)*(RoomWidth(iUNIT)+RoomDepth(iUNIT)) );
        else
            RoomIndex(iUNIT) = 2.5;  % �f�t�H���g�l
        end
    end
    
    % ���w���␳�W�� hosei_RI
    if isnan(RoomIndex(iUNIT)) == 0
        if RoomIndex(iUNIT) < 0.75
            hosei_RI(iUNIT) = 0.50;
        elseif RoomIndex(iUNIT) < 0.95
            hosei_RI(iUNIT) = 0.60;
        elseif RoomIndex(iUNIT) < 1.25
            hosei_RI(iUNIT) = 0.70;
        elseif RoomIndex(iUNIT) < 1.75
            hosei_RI(iUNIT) = 0.80;
        elseif RoomIndex(iUNIT) < 2.50
            hosei_RI(iUNIT) = 0.90;
        elseif RoomIndex(iUNIT) < 4.30
            hosei_RI(iUNIT) = 1.00;
        else
            hosei_RI(iUNIT) = 1.1;
        end
        
    end
end


%% ����␳�W���̌���

% hosei_C1 = ones(1,numofUnit);
% hosei_C2 = ones(1,numofUnit);
% hosei_C3 = ones(1,numofUnit);
% hosei_C4 = ones(1,numofUnit);
% hosei_C1_name = cell(1,numofUnit);
% hosei_C2_name = cell(1,numofUnit);
% hosei_C3_name = cell(1,numofUnit);
% hosei_C4_name = cell(1,numofUnit);

for iUNIT = 1:numofUnit
    
    % �ݎ����m����
    if strcmp(ControlFlag_C1(iUNIT),'None')
        hosei_C1(iUNIT) = 1.0;
        hosei_C1_name{iUNIT} = ' ';
    elseif strcmp(ControlFlag_C1(iUNIT),'dimmer')
        hosei_C1(iUNIT) = 0.80;
        hosei_C1_name{iUNIT} = '�L��(��)';
    elseif strcmp(ControlFlag_C1(iUNIT),'onoff')
        hosei_C1(iUNIT) = 0.70;
        hosei_C1_name{iUNIT} = '�L��(�_��)';
    elseif strcmp(ControlFlag_C1(iUNIT),'sensing64')
        hosei_C1(iUNIT) = 0.95;
        hosei_C1_name{iUNIT} = '��(6.4m)';
    elseif strcmp(ControlFlag_C1(iUNIT),'sensing32')
        hosei_C1(iUNIT) = 0.85;
        hosei_C1_name{iUNIT} = '��(3.2m)';
    elseif strcmp(ControlFlag_C1(iUNIT),'eachunit')
        hosei_C1(iUNIT) = 0.80;
        hosei_C1_name{iUNIT} = '��(��)';
    else
        error('�ݎ����m����̕������s���ł�')
    end
    
    % �^�C���X�P�W���[������
    if strcmp(ControlFlag_C2(iUNIT),'None')
        hosei_C2(iUNIT) = 1.0;
        hosei_C2_name{iUNIT} = ' ';
    elseif strcmp(ControlFlag_C2(iUNIT),'dimmer')
        hosei_C2(iUNIT) = 0.95;
        hosei_C2_name{iUNIT} = '����';
    elseif strcmp(ControlFlag_C2(iUNIT),'onoff')
        hosei_C2(iUNIT) = 0.90;
        hosei_C2_name{iUNIT} = '�_��';
    else
        error('�^�C���X�P�W���[������̕������s���ł�')
    end
    
    % �����Ɠx�␳����
    if strcmp(ControlFlag_C3(iUNIT),'None')
        hosei_C3(iUNIT) = 1.0;
        hosei_C3_name{iUNIT} = ' ';
    elseif strcmp(ControlFlag_C3(iUNIT),'True')
        hosei_C3(iUNIT) = 0.85;
        hosei_C3_name{iUNIT} = '�L';
    else
        ControlFlag_C3(iUNIT)
        error('�����Ɠx�␳����̕������s���ł�')
    end
    
    % ���邳���m����
    if strcmp(ControlFlag_C4(iUNIT),'None')
        hosei_C4(iUNIT) = 1.0;
        hosei_C4_name{iUNIT} = ' ';
    elseif strcmp(ControlFlag_C4(iUNIT),'dimmer')
        hosei_C4(iUNIT) = 0.8;
        hosei_C4_name{iUNIT} = '�_��';
    elseif strcmp(ControlFlag_C4(iUNIT),'eachSideWithBlind')
        hosei_C4(iUNIT) = 0.9;
        hosei_C4_name{iUNIT} = '����VB��';
    elseif strcmp(ControlFlag_C4(iUNIT),'eachSideWithoutBlind')
        hosei_C4(iUNIT) = 0.85;
        hosei_C4_name{iUNIT} = '����VB�L';
    elseif strcmp(ControlFlag_C4(iUNIT),'bothSidesWithBlind')
        hosei_C4(iUNIT) = 0.85;
        hosei_C4_name{iUNIT} = '����VB��';
    elseif strcmp(ControlFlag_C4(iUNIT),'bothSidesWithoutBlind')
        hosei_C4(iUNIT) = 0.8;
        hosei_C4_name{iUNIT} = '����VB�L';
    else
        error('���邳���m����̕������s���ł�')
    end
    
end

%% �G�l���M�[����ʌv�Z

% �]���l Edesign [MJ/�N]
Edesign_noRI = 9760.*Power.*Count.*timeL.*(hosei_C1.*hosei_C2.*hosei_C3.*hosei_C4) ./1000000;
Edesign = 9760.*Power.*Count.*timeL.*hosei_RI.*(hosei_C1.*hosei_C2.*hosei_C3.*hosei_C4) ./1000000;

% �]���l Edesign_m2 [MJ/m2�N]
Edesign_m2 = sum(Edesign)/sum(RoomArea);

% ��l Estandard [MJ/�N]
Estandard = 9760.*Es.*RoomArea.*timeL./1000000;
Estandard_m2 = sum(Estandard)/sum(RoomArea);

y(1) = sum(Edesign);
y(2) = Edesign_m2;


%% �ȈՏo��
% �o�͂���t�@�C����
if isempty(strfind(inputfilename,'/'))
    eval(['resfilenameS = ''calcRES_L_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(inputfilename,'/');
    eval(['resfilenameS = ''calcRES_L',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end
csvwrite(resfilenameS,y);


%% �ڍ׏o��

if OutputOptionVar == 1
    
    % �o�͂���t�@�C����
    if isempty(strfind(inputfilename,'/'))
        eval(['resfilenameD = ''calcRESdetail_L_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(inputfilename,'/');
        eval(['resfilenameD = ''calcRESdetail_L_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % ���ʊi�[�p�ϐ�
    rfc = {};
    rfc = mytfunc_oneLinecCell(rfc,RoomFloor);
    rfc = mytfunc_oneLinecCell(rfc,RoomName);
    rfc = mytfunc_oneLinecCell(rfc,RoomType);
    rfc = mytfunc_oneLinecCell(rfc,RoomHeight);
    rfc = mytfunc_oneLinecCell(rfc,RoomWidth);
    rfc = mytfunc_oneLinecCell(rfc,RoomDepth);
    rfc = mytfunc_oneLinecCell(rfc,RoomArea);
    rfc = mytfunc_oneLinecCell(rfc,RoomIndex);
    rfc = mytfunc_oneLinecCell(rfc,hosei_RI);
    
    rfc = mytfunc_oneLinecCell(rfc,UnitType);
    rfc = mytfunc_oneLinecCell(rfc,UnitName);
    
    rfc = mytfunc_oneLinecCell(rfc,Power);
    rfc = mytfunc_oneLinecCell(rfc,Count);
    rfc = mytfunc_oneLinecCell(rfc,(Power.*Count)./RoomArea);
    rfc = mytfunc_oneLinecCell(rfc,Es);
    
    rfc = mytfunc_oneLinecCell(rfc,hosei_C1_name);
    rfc = mytfunc_oneLinecCell(rfc,hosei_C2_name);
    rfc = mytfunc_oneLinecCell(rfc,hosei_C3_name);
    rfc = mytfunc_oneLinecCell(rfc,hosei_C4_name);
    rfc = mytfunc_oneLinecCell(rfc,hosei_C1.*hosei_C2.*hosei_C3.*hosei_C4);
    rfc = mytfunc_oneLinecCell(rfc,timeL);
    
    rfc = mytfunc_oneLinecCell(rfc,Edesign);
    rfc = mytfunc_oneLinecCell(rfc,Edesign_noRI);
    rfc = mytfunc_oneLinecCell(rfc,Estandard);
    rfc = mytfunc_oneLinecCell(rfc,Edesign./Estandard);
    
    % �o��
    fid = fopen(resfilenameD,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i});
    end
    fclose(fid);
    
end

