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
function y = ECS_routeB_Others_run(inputfilename,OutputOption)

% clear
% clc
% tic
% inputfilename = './InputFiles/1005_�R�W�F�l�e�X�g/model_CGS_case00.xml';
% OutputOption = 'ON';
% addpath('./subfunction/')


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
RoomCalcAC = zeros(numOfRoom,1);
RoomCalcLT = zeros(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    BldgType{iROOM,1} = model.Rooms.Room(iROOM).ATTRIBUTE.BuildingType;
    RoomType{iROOM,1} = model.Rooms.Room(iROOM).ATTRIBUTE.RoomType;
    RoomArea(iROOM,1) = model.Rooms.Room(iROOM).ATTRIBUTE.RoomArea;
    
    if strcmp(model.Rooms.Room(iROOM).ATTRIBUTE.calcAC,'True')
        RoomCalcAC(iROOM,1) = 1;
    end
    if strcmp(model.Rooms.Room(iROOM).ATTRIBUTE.calcL,'True')
        RoomCalcLT(iROOM,1) = 1;
    end
    
end


%% ���̑��d�͂̌v�Z

Eothers_perArea = zeros(numOfRoom,1);
Eothers_MWh_hourly_perArea  = zeros(8760,numOfRoom);
Eothers_MWh_hourly = zeros(8760,numOfRoom);

Schedule_AC_hour = zeros(8760,numOfRoom);  % �󒲃X�P�W���[��
Schedule_LT_hour = zeros(8760,numOfRoom);  % �Ɩ����M�X�P�W���[��
Schedule_OA_hour = zeros(8760,numOfRoom);  % �@�픭�M�X�P�W���[��

AreaWeightedSchedule = zeros(8760,3);

for iROOM = 1:numOfRoom
    
    % ���ʐς�����̌��P�ʂ̒��o�i�����l�Ɋۂ߂�ꂽ�����ʂ�̒l�j MJ/m2
    [Eothers_perArea(iROOM,1),Eothers_MWh_hourly_perArea(:,iROOM),...
        Schedule_AC_hour(:,iROOM),Schedule_LT_hour(:,iROOM),Schedule_OA_hour(:,iROOM)] = ...
        mytfunc_calcOApowerUsage(BldgType{iROOM,1},RoomType{iROOM,1},perDB_RoomType,perDB_calendar,perDB_RoomOpeCondition);
    
    % �����ʏ���d�͂̒��o�i�R�W�F�l�v�Z�p�j MWh/m2 * m2 = MWh
    Eothers_MWh_hourly(:,iROOM) = Eothers_MWh_hourly_perArea(:,iROOM) .* RoomArea(iROOM,1);
    
    % �ʐϏd�݂Â��̃X�P�W���[��
    if RoomCalcAC(iROOM,1) == 1
        AreaWeightedSchedule(:,1) = AreaWeightedSchedule(:,1) + Schedule_AC_hour(:,iROOM) .*  RoomArea(iROOM,1);
    end
    if RoomCalcLT(iROOM,1) == 1
        AreaWeightedSchedule(:,2) = AreaWeightedSchedule(:,2) + Schedule_LT_hour(:,iROOM) .*  RoomArea(iROOM,1);
    end
    AreaWeightedSchedule(:,3) = AreaWeightedSchedule(:,3) + Schedule_OA_hour(:,iROOM) .*  RoomArea(iROOM,1);
    
end

% AreaWeightedSchedule������Ƃ̔䗦�ɂ���B
ratio_AreaWeightedSchedule = zeros(size(AreaWeightedSchedule));

for dd = 1:365
    
    dailysum(1) = sum(AreaWeightedSchedule(24*(dd-1)+1:24*dd,1));
    dailysum(2) = sum(AreaWeightedSchedule(24*(dd-1)+1:24*dd,2));
    dailysum(3) = sum(AreaWeightedSchedule(24*(dd-1)+1:24*dd,3));
    
    for hh = 1:24
        
        if dailysum(1) ~= 0
            ratio_AreaWeightedSchedule(24*(dd-1)+hh,1) = AreaWeightedSchedule(24*(dd-1)+hh,1) ./ dailysum(1);
        end
        if dailysum(2) ~= 0
            ratio_AreaWeightedSchedule(24*(dd-1)+hh,2) = AreaWeightedSchedule(24*(dd-1)+hh,2) ./ dailysum(2);
        end
        if dailysum(3) ~= 0
            ratio_AreaWeightedSchedule(24*(dd-1)+hh,3) = AreaWeightedSchedule(24*(dd-1)+hh,3) ./ dailysum(3);
        end
        
    end
end



%% ���ʂ̏W�v

% ���̑��ꎟ�G�l���M�[����ʁi���P�ʁj [MJ/�N]
Eothers = Eothers_perArea .* RoomArea;

% �N�ώZ�l�������̒l�ƈ�v����悤�ɕ␳
ratio = zeros(numOfRoom,1);
for iROOM = 1:numOfRoom
    if Eothers(iROOM,1) ~= 0
        ratio(iROOM,1) = Eothers(iROOM,1)/(sum(Eothers_MWh_hourly(:,iROOM))*9760);
        Eothers_MWh_hourly(:,iROOM) = Eothers_MWh_hourly(:,iROOM).*ratio(iROOM,1);
    end
end

% ���̑��d�͂̔N�ώZ�l [MJ/�N]
y = sum(Eothers);


% ���ʂɐώZ����B
Eothers_day = zeros(365,1);
for dd = 1:365
    Eothers_day(dd,1) = sum( sum(Eothers_MWh_hourly(24*(dd-1)+1:24*dd,:)) ); % MWh/day
end


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
    
    RESALL = [TimeLabel,sum(Eothers_MWh_hourly,2)];
    
    rfc = {};
    rfc = [rfc;'��,��,��,���̑��d�͏����[MWh]'];
    rfc = mytfunc_oneLinecCell(rfc,RESALL);
    
    fid = fopen(resfilenameH,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i});
    end
    fclose(fid);
    
end


%% �R�W�F�l�p�̕ϐ�
if exist('CGSmemory.mat','file') == 0
    CGSmemory = [];
else
    load CGSmemory.mat
end

CGSmemory.RESALL(:,18) = Eothers_day;
CGSmemory.ratio_AreaWeightedSchedule = ratio_AreaWeightedSchedule;

save CGSmemory.mat CGSmemory





