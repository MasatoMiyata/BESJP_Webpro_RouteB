% ECS_routeB_Others_run.m
%                                          by Masato Miyata 2016/04/17
%----------------------------------------------------------------------
% �ȃG�l��F�R���Z���g�d�́i���̑��d�́j�v�Z�v���O����
%----------------------------------------------------------------------
% ����
%  inputfilename : XML�t�@�C������
%  OutputOption  : �o�͐���iON: �ڍ׏o�́AOFF: �ȈՏo�́j
% �o��
%  y(1) : ���̑��d�� [MJ/�N]
%----------------------------------------------------------------------
% function y = ECS_routeB_Others_run(inputfilename,OutputOption)

clear
clc
tic
inputfilename = 'model_routeB_sample04.xml';
OutputOption = 'ON';
addpath('./subfunction/')


switch OutputOption
    case 'ON'
        OutputOptionVar = 1;
    case 'OFF'
        OutputOptionVar = 0;
    otherwise
        error('OutputOption���s���ł��BON �� OFF �Ŏw�肵�ĉ������B')
end

%% �f�[�^�x�[�X�ǂݍ���
mytscript_readDBfiles;


%% �������f���ǂݍ���
model = xml_read(inputfilename);

% �����̐�
numOfRoom = length(model.Rooms.Room);

BldgTypeList = cell(numOfRoom,1);
RoomTypeList = cell(numOfRoom,1);
RoomAreaList = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    BldgType{iROOM,1} = model.Rooms.Room(iROOM).ATTRIBUTE.BuildingType;
    RoomType{iROOM,1} = model.Rooms.Room(iROOM).ATTRIBUTE.RoomType;
    RoomArea(iROOM,1) = model.Rooms.Room(iROOM).ATTRIBUTE.RoomArea;
    
end


%% ���̑��d�͂̌v�Z

Eothers_perArea = zeros(numOfRoom,1);
Eothers_hourly_perArea = zeros(8760,numOfRoom);
Eothers = zeros(numOfRoom,1);
Eothers_hourly = zeros(8760,numOfRoom);

for iROOM = 1:numOfRoom
    
    % ���P�ʂ̒��o MJ/m2
    Eothers_perArea(iROOM,1) = mytfunc_calcOApowerUsage(BldgType{iROOM,1},RoomType{iROOM,1},perDB_RoomType,perDB_calendar);
    
    % �����ʌ��P�ʂ̒��o MWh/m2
    Eothers_hourly_perArea(:,iROOM) = mytfunc_calcOApowerUsage_hourly(BldgType{iROOM,1},RoomType{iROOM,1},perDB_RoomType,perDB_calendar);
    
    % ���̑��d�� [MJ/�N]
    Eothers(iROOM,1) = Eothers_perArea(iROOM,1) * RoomArea(iROOM,1);
    % ���̑��d�� [MWh/�N]
    Eothers_hourly(:,iROOM) = Eothers_hourly_perArea(:,iROOM) .* RoomArea(iROOM,1);
    
end

y = sum(Eothers);


%% ���n��f�[�^�̏o��
if OutputOptionVar == 1
    
    if isempty(strfind(inputfilename,'/'))
        eval(['resfilenameH = ''calcREShourly_Others_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(inputfilename,'/');
        eval(['resfilenameH = ''calcREShourly_Others_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % ���F���F��
    TimeLabel = zeros(8760,3);
    for dd = 1:365
        for hh = 1:24
            % 1��1��0������̎��Ԑ�
            num = 24*(dd-1)+hh;
            t = datenum(2015,1,1) + (dd-1) + (hh-1)/24;
            TimeLabel(num,1) = str2double(datestr(t,'mm'));
            TimeLabel(num,2) = str2double(datestr(t,'dd'));
            TimeLabel(num,3) = str2double(datestr(t,'hh'));
        end
    end
    
    RESALL = [ TimeLabel,sum(Eothers_hourly,2)];
    
    rfc = {};
    rfc = [rfc;'��,��,��,���̑��d�͏����[MWh]'];
    rfc = mytfunc_oneLinecCell(rfc,RESALL);
    
    fid = fopen(resfilenameH,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i});
    end
    fclose(fid);
    
    
end


