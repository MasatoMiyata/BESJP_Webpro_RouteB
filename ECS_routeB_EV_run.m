% ECS_routeB_EV_run_v1.m
%                                          by Masato Miyata 2011/04/05
%----------------------------------------------------------------------
% �ȃG�l��F���~�@�v�Z�v���O����
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
function y = ECS_routeB_EV_run(inputfilename,OutputOption)

% clear
% clc
% tic
% 
% inputfilename = './NSRI_School_IVb_Case0.xml';
% addpath('./subfunction/')
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
TransportCapacityFactor = zeros(1,numofUnit);

for iUNIT = 1:numofUnit
    
    Name{iUNIT}        = model.Elevators.Elevator(iUNIT).ATTRIBUTE.Name;
    BldgType{iUNIT}    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.BldgType;
    RoomFloor{iUNIT}   = model.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomFloor;
    RoomName{iUNIT}    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomName;
    RoomType{iUNIT}    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.RoomType;

    Count(iUNIT)       = model.Elevators.Elevator(iUNIT).ATTRIBUTE.Count;
    LoadLimit(iUNIT)   = model.Elevators.Elevator(iUNIT).ATTRIBUTE.LoadLimit;
    Velocity(iUNIT)    = model.Elevators.Elevator(iUNIT).ATTRIBUTE.Velocity;
    
    % �A���\�͌W��
    if strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.TransportCapacityFactor,'Null')
        TransportCapacityFactor(iUNIT) = 1;
    else
        TransportCapacityFactor(iUNIT) = model.Elevators.Elevator(iUNIT).ATTRIBUTE.TransportCapacityFactor;
    end
    if TransportCapacityFactor(iUNIT) < 0
        TransportCapacityFactor(iUNIT) = 0;
    end
    
    if strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'VVVF_Regene_GearLess')
        kControlT(iUNIT) = 1/50;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐��䂠��M�A���X����@�j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'VVVF_Regene')
        kControlT(iUNIT) = 1/45;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐��䂠��j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'VVVF_GearLess')
        kControlT(iUNIT) = 1/45;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐���Ȃ��M�A���X����@�j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'VVVF')
        kControlT(iUNIT) = 1/40;
        kControlT_name{iUNIT} = '�ϓd���ώ��g����������i�d�͉񐶐���Ȃ��j';
    elseif strcmp(model.Elevators.Elevator(iUNIT).ATTRIBUTE.ControlType,'AC_FeedbackControl')
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
            
            % ���~�@�^�]���� [hour] (�Ɩ����ԂƂ���)
            timeEV(iUNIT) = str2double(perDB_RoomType(iDB,23));
            
        end
    end
    
end

% �G�l���M�[����ʌv�Z [MJ/�N]
Edesign_MWh   = LoadLimit.* Velocity.* kControlT.* Count.* timeEV ./860 ./1000;
Estandard_MWh = LoadLimit.* Velocity.* (1/40).* TransportCapacityFactor .* Count.* timeEV ./860 ./1000;
Edesign_MJ   = 9760.* Edesign_MWh;
Estandard_MJ = 9760.* Estandard_MWh;
 
y(1) = sum(Edesign_MWh);
y(2) = NaN;
y(3) = sum(Edesign_MJ);
y(4) = NaN;
y(5) = sum(Estandard_MWh);
y(6) = NaN;
y(7) = sum(Estandard_MJ);
y(8) = NaN;
y(9) = y(3)/y(7);


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
   
    rfc = {};
    
    for iUNIT = 1:numofUnit
        tmprfc = {};
        tmprfc = strcat(Name(iUNIT),',',...
            num2str(Count(iUNIT)),',',...
            num2str(LoadLimit(iUNIT)),',',...
            num2str(Velocity(iUNIT)),',',...
            kControlT_name{iUNIT},',',...
            num2str(kControlT(iUNIT)),',',...
            RoomFloor(iUNIT),',',...
            RoomName(iUNIT),',',...
            BldgType(iUNIT),',',...
            RoomType(iUNIT),',',...
            num2str(timeEV(iUNIT)),',',...
            num2str(Edesign_MWh(iUNIT)),',',...
            num2str(Edesign_MJ(iUNIT)),',',...
            num2str(Estandard_MWh(iUNIT)),',',...
            num2str(Estandard_MJ(iUNIT)),',',...
            num2str(y(3)/y(7)));
        
        rfc = [rfc; tmprfc];
    end
    
    
    % �o��
    fid = fopen(resfilenameD,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i});
    end
    fclose(fid);
    
end

