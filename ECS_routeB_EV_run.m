% ECS_routeB_EV_run_v1.m
%                                          by Masato Miyata 2011/04/05
%----------------------------------------------------------------------
% ���~�@�v�Z�v���O����
%----------------------------------------------------------------------
function y = ECS_routeB_EV_run_v1(inputfilename,OutputOption)

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

% ���~�@�䐔
numofUnit  = length(model.Elevators.Elevator);

Name       = cell(1,numofUnit);
BldgType   = cell(1,numofUnit);
RoomType   = cell(1,numofUnit);
RoomFloor  = cell(1,numofUnit);
RoomName   = cell(1,numofUnit);
Count      = ones(1,numofUnit);
LoadLimit  = zeros(1,numofUnit);
Velocity   = zeros(1,numofUnit);
kControlT      = ones(1,numofUnit);
kControlT_name = cell(1,numofUnit);

for iUNIT = 1:numofUnit
    
    Name{iUNIT}        = model.Elevators.Elevator(iUNIT).ATTRIBUTE.Name;
    BldgType{iUNIT}    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.BldgType;
    RoomFloor{iUNIT}   = model.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomFloor;
    RoomName{iUNIT}    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomName;
    RoomType{iUNIT}    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomType;

    Count(iUNIT)       = model.Elevators.Elevator(iUNIT).ATTRIBUTE.Count;
    LoadLimit(iUNIT)   = model.Elevators.Elevator(iUNIT).ATTRIBUTE.LoadLimit;
    Velocity(iUNIT)    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.Velocity;
        
    if strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'EV_CT1')
        kControlT(iUNIT) = 1/50;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐��䂠��M�A���X����@�j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'EV_CT2')
        kControlT(iUNIT) = 1/45;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐��䂠��j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'EV_CT3')
        kControlT(iUNIT) = 1/45;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐���Ȃ��M�A���X����@�j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'EV_CT4')
        kControlT(iUNIT) = 1/40;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐���Ȃ��j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'EV_CT5')
        kControlT(iUNIT) = 1/20;
        kControlT_name{iUNIT} = '�𗬋A�Ґ������';
    end
    
    
end

%% �e���̏Ɩ����Ԃ�T��
timeEV = zeros(1,numofUnit);

for iUNIT = 1:numofUnit
    
    % �W�����g�p������T��
    for iDB = 1:length(perDB_RoomType)
        if strcmp(perDB_RoomType{iDB,2},BldgType{iUNIT}) && ...
                strcmp(perDB_RoomType{iDB,5},RoomType{iUNIT})
            
            % ���~�@�^�]���� [hour] (�󒲎��ԂƂ���)
            timeEV(iUNIT) = str2double(perDB_RoomType(iDB,22));
            
        end
    end
    
end

% �G�l���M�[����ʌv�Z [MJ/�N]
Edesign   = 9760.* LoadLimit.* Velocity.* kControlT.* Count.* timeEV ./860 ./1000;
Estandard = 9760.* LoadLimit.* Velocity.* (1/40).* Count.* timeEV ./860 ./1000;
 
y(1) = sum(Edesign);
y(2) = Estandard;


%% �ȈՏo��
% �o�͂���t�@�C����
if isempty(strfind(inputfilename,'/'))
    eval(['resfilenameS = ''calcRES_EV_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(inputfilename,'/');
    eval(['resfilenameS = ''calcRES_EV_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end
csvwrite(resfilenameS,y);


%% �ڍ׏o��

if OutputOptionVar == 1
    
    % �o�͂���t�@�C����
    if isempty(strfind(inputfilename,'/'))
        eval(['resfilenameD = ''calcRESdetail_EV_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(inputfilename,'/');
        eval(['resfilenameD = ''calcRESdetail_EV_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % ���ʊi�[�p�ϐ�
    rfc = {};
    rfc = mytfunc_oneLinecCell(rfc,Edesign);
    rfc = mytfunc_oneLinecCell(rfc,Estandard);
    
    % �o��
    fid = fopen(resfilenameD,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i});
    end
    fclose(fid);
    
end

