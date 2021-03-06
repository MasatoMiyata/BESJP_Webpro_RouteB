% ECS_routeB_L_run.m
%                                          by Masato Miyata 2011/04/20
%----------------------------------------------------------------------
% 省エネ基準：照明計算プログラム
%----------------------------------------------------------------------
% 入力
%  inputfilename : XMLファイル名称
%  OutputOption  : 出力制御（ON: 詳細出力、OFF: 簡易出力）
% 出力
%  y(1) : 評価値 [MWh/年]
%  y(2) : 評価値 [MWh/m2/年]
%  y(3) : 評価値 [MJ/年]
%  y(4) : 評価値 [MJ/m2/年]
%  y(5) : 基準値 [MWh/年]
%  y(6) : 基準値 [MWh/m2/年]
%  y(7) : 基準値 [MJ/年]
%  y(8) : 基準値 [MJ/m2/年]
%  y(9) : BEI (=評価値/基準値） [-]
%----------------------------------------------------------------------
function y = ECS_routeB_L_run(inputfilename,OutputOption)

% clear
% clc
% inputfilename = './InputFiles/1005_コジェネテスト/model_CGS_case00.xml';
% addpath('./subfunction/')
% OutputOption = 'ON';


%% 設定
model = xml_read(inputfilename);

switch OutputOption
    case 'ON'
        OutputOptionVar = 1;
    case 'OFF'
        OutputOptionVar = 0;
    otherwise
        error('OutputOptionが不正です。ON か OFF で指定して下さい。')
end

% データベース読み込み
mytscript_readDBfiles;


%% 情報抽出

% 照明室数
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
        RoomWidth(iROOM)    = round(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomWidth,1);
    end
    if strcmp(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomDepth,'Null') == 0
        RoomDepth(iROOM)    = round(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomDepth,1);
    end
    if strcmp(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomHeight,'Null') == 0
        RoomHeight(iROOM)   = round(model.LightingSystems.LightingRoom(iROOM).ATTRIBUTE.RoomHeight,1);
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
        
        % 器具名称
        UnitName{iROOM,iUNIT} = model.LightingSystems.LightingRoom(iROOM).LightingUnit(iUNIT).ATTRIBUTE.UnitName;
        
    end
end


%% 各室の照明時間・基準値を探査
timeL = zeros(numOfRoom,1);
Es    = zeros(numOfRoom,1);

opeMode_Lroom = zeros(numOfRoom,365,24);

for iROOM = 1:numOfRoom
    
    % 標準室使用条件を探索
    for iDB = 1:length(perDB_RoomType)
        if strcmp(perDB_RoomType{iDB,2},BldgType{iROOM}) && ...
                strcmp(perDB_RoomType{iDB,5},RoomType{iROOM})
            
            % 照明時間 [hour]
            timeL(iROOM) = str2double(perDB_RoomType(iDB,23));
            
            % 換気スケジュール（時刻別）
            [~,opeMode_Lroom(iROOM,:,:),~] = mytfunc_getRoomCondition(perDB_RoomType,perDB_RoomOpeCondition,perDB_calendar,BldgType{iROOM},RoomType{iROOM});
            
            % 基準設定消費電力 [kW]
            Es(iROOM) = str2double(perDB_RoomType(iDB,25));
            
        end
    end
    
end


%% 室指数補正係数の決定
hosei_RI = ones(numOfRoom,1);

for iROOM = 1:numOfRoom
    
    % 室指数の計算
    if RoomIndex(iROOM) == 0 || isempty(RoomIndex(iROOM))
        if RoomHeight(iROOM)*(RoomWidth(iROOM)+RoomDepth(iROOM)) ~= 0
            RoomIndex(iROOM) = (RoomWidth(iROOM)*RoomDepth(iROOM)) / ...
                ( RoomHeight(iROOM)*(RoomWidth(iROOM)+RoomDepth(iROOM)) );
        else
            RoomIndex(iROOM) = 2.5;  % デフォルト値
        end
    end
    
    % 室指数補正係数 hosei_RI
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
            hosei_RI(iROOM) = 1.00;
        end
        
    end
end


%% 制御補正係数の決定

for iROOM = 1:numOfRoom
    for iUNIT = 1:numofUnit(iROOM)
        
        % 在室検知制御
        if strcmp(ControlFlag_C1(iROOM,iUNIT),'None')
            hosei_C1(iROOM,iUNIT) = 1.0;
            hosei_C1_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'dimmer')
            hosei_C1(iROOM,iUNIT) = 0.80;
            hosei_C1_name{iROOM,iUNIT} = '減光方式';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'onoff')
            hosei_C1(iROOM,iUNIT) = 0.70;
            hosei_C1_name{iROOM,iUNIT} = '点滅方式';
        elseif strcmp(ControlFlag_C1(iROOM,iUNIT),'limitedVariable')
            hosei_C1(iROOM,iUNIT) = 0.95;
            hosei_C1_name{iROOM,iUNIT} = '下限調光方式';
        else
            error('在室検知制御の方式が不正です')
        end
        
        % 明るさ検知制御
        if strcmp(ControlFlag_C2(iROOM,iUNIT),'None')
            hosei_C2(iROOM,iUNIT) = 1.0;
            hosei_C2_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variable')
            hosei_C2(iROOM,iUNIT) = 0.90;
            hosei_C2_name{iROOM,iUNIT} = '調光方式';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variableWithBlind')
            hosei_C2(iROOM,iUNIT) = 0.85;
            hosei_C2_name{iROOM,iUNIT} = '調光方式BL';
            
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variable_W15')
            hosei_C2(iROOM,iUNIT) = 0.85;
            hosei_C2_name{iROOM,iUNIT} = '調光方式W15';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variable_W15_WithBlind')
            hosei_C2(iROOM,iUNIT) = 0.78;
            hosei_C2_name{iROOM,iUNIT} = '調光方式W15BL';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variable_W20')
            hosei_C2(iROOM,iUNIT) = 0.80;
            hosei_C2_name{iROOM,iUNIT} = '調光方式W20';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variable_W20_WithBlind')
            hosei_C2(iROOM,iUNIT) = 0.70;
            hosei_C2_name{iROOM,iUNIT} = '調光方式W20BL';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variable_W25')
            hosei_C2(iROOM,iUNIT) = 0.75;
            hosei_C2_name{iROOM,iUNIT} = '調光方式W25';
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'variable_W25_WithBlind')
            hosei_C2(iROOM,iUNIT) = 0.63;
            hosei_C2_name{iROOM,iUNIT} = '調光方式W25BL';
            
        elseif strcmp(ControlFlag_C2(iROOM,iUNIT),'onoff')
            hosei_C2(iROOM,iUNIT) = 0.80;
            hosei_C2_name{iROOM,iUNIT} = '点滅方式';
        else
            error('昼光利用制御の方式が不正です')
        end
        
        % タイムスケジュール制御
        if strcmp(ControlFlag_C3(iROOM,iUNIT),'None')
            hosei_C3(iROOM,iUNIT) = 1.0;
            hosei_C3_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C3(iROOM,iUNIT),'dimmer')
            hosei_C3(iROOM,iUNIT) = 0.95;
            hosei_C3_name{iROOM,iUNIT} = '減光';
        elseif strcmp(ControlFlag_C3(iROOM,iUNIT),'onoff')
            hosei_C3(iROOM,iUNIT) = 0.90;
            hosei_C3_name{iROOM,iUNIT} = '点滅';
        else
            error('タイムスケジュール制御の方式が不正です')
        end
        
        % 初期照度補正制御
        if strcmp(ControlFlag_C4(iROOM,iUNIT),'False')
            hosei_C4(iROOM,iUNIT) = 1.0;
            hosei_C4_name{iROOM,iUNIT} = ' ';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'timerLED')
            hosei_C4(iROOM,iUNIT) = 0.95;
            hosei_C4_name{iROOM,iUNIT} = 'タイマ方式(LED)';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'timerFLU')
            hosei_C4(iROOM,iUNIT) = 0.85;
            hosei_C4_name{iROOM,iUNIT} = 'タイマ方式(蛍光灯)';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'sensorLED')
            hosei_C4(iROOM,iUNIT) = 0.95;
            hosei_C4_name{iROOM,iUNIT} = 'センサ方式(LED)';
        elseif strcmp(ControlFlag_C4(iROOM,iUNIT),'sensorFLU')
            hosei_C4(iROOM,iUNIT) = 0.85;
            hosei_C4_name{iROOM,iUNIT} = 'センサ方式(蛍光灯)';
        else
            ControlFlag_C4(iROOM,iUNIT)
            error('初期照度補正制御の方式が不正です')
        end
        
        hosei_ALL(iROOM,iUNIT) = hosei_C1(iROOM,iUNIT)*hosei_C2(iROOM,iUNIT)*...
            hosei_C3(iROOM,iUNIT)*hosei_C4(iROOM,iUNIT);
        
    end
end

%% エネルギー消費量計算

% 設計値 Edesign [MJ/年]
Edesign_noRI_MWh = repmat(timeL,1,max(numofUnit)).*Power.*Count.*(hosei_C1.*hosei_C2.*hosei_C3.*hosei_C4) ./1000000;
Edesign_noRI_MJ  = 9760.*Edesign_noRI_MWh;
Edesign_MWh      = repmat(timeL,1,max(numofUnit)).*repmat(hosei_RI,1,max(numofUnit))...
    .*Power.*Count.*(hosei_C1.*hosei_C2.*hosei_C3.*hosei_C4) ./1000000;
Edesign_MJ       = 9760.*Edesign_MWh;

% 設計値 Edesign_m2 [MJ/m2年]
Edesign_MWh_m2 = sum(nansum(Edesign_MWh))/sum(RoomArea);
Edesign_MJ_m2  = sum(nansum(Edesign_MJ))/sum(RoomArea);

% 時刻別の値
Edesign_MWh_hour = zeros(8760,1);
for iROOM = 1:numOfRoom
    for iUNIT = 1:numofUnit(iROOM)
        for dd = 1:365
            for hh = 1:24
                num = 24*(dd-1) + hh;
                Edesign_MWh_hour(num,1) = Edesign_MWh_hour(num,1) + ...
                    hosei_RI(iROOM)*Power(iROOM,iUNIT)*Count(iROOM,iUNIT)*hosei_ALL(iROOM,iUNIT)*opeMode_Lroom(iROOM,dd,hh)./1000000;
            end
        end
    end
end

% 基準値 Estandard [MJ/年]（基準値が固まるまでの暫定措置）
Estandard_MWh = Es.*RoomArea.*timeL./1000000;
Estandard_MJ  = 9760.*Estandard_MWh;
Estandard_MWh_m2 = nansum(Estandard_MWh)/sum(RoomArea);
Estandard_MJ_m2  = nansum(Estandard_MJ)/sum(RoomArea);

% 基準値（ROOM_STANDARDVALUE.csv）より値を抜き出す（最終的にはこちらを採用）
Estandard_MJ_CSV = mytfunc_calcStandardValue(BldgType,RoomType,RoomArea,17);


% 出力
y(1) = sum(nansum(Edesign_MWh));
y(2) = Edesign_MWh_m2;
y(3) = sum(nansum(Edesign_MJ));
y(4) = Edesign_MJ_m2;
y(5) = sum(nansum(Estandard_MWh));
y(6) = Estandard_MWh_m2;
y(7) = nansum(Estandard_MJ_CSV);  % 告示の基準値に合わせる（2016/04/08）
y(8) = Estandard_MJ_m2;
y(9) = y(4)/y(8);


%% 簡易出力
% 出力するファイル名
if isempty(strfind(inputfilename,'/'))
    eval(['resfilenameS = ''calcRES_L_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(inputfilename,'/');
    eval(['resfilenameS = ''calcRES_L_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end
dlmwrite(resfilenameS,y,'precision',20);  % 有効数字を指定

%% 詳細出力

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
                    UnitName(iROOM,iUNIT),',',...
                    num2str(Power(iROOM,iUNIT)),',',...
                    num2str(Count(iROOM,iUNIT)),',',...
                    num2str((Power(iROOM,iUNIT)*Count(iROOM,iUNIT))/RoomArea(iROOM)),',',...
                    num2str(Es(iROOM)),',',...
                    hosei_C1_name(iROOM,iUNIT),',',...
                    hosei_C2_name(iROOM,iUNIT),',',...
                    hosei_C3_name(iROOM,iUNIT),',',...
                    hosei_C4_name(iROOM,iUNIT),',',...
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
                    UnitName(iROOM,iUNIT),',',...
                    num2str(Power(iROOM,iUNIT)),',',...
                    num2str(Count(iROOM,iUNIT)),',',...
                    num2str((Power(iROOM,iUNIT)*Count(iROOM,iUNIT))/RoomArea(iROOM)),',',...
                    ',',...
                    hosei_C1_name(iROOM,iUNIT),',',...
                    hosei_C2_name(iROOM,iUNIT),',',...
                    hosei_C3_name(iROOM,iUNIT),',',...
                    hosei_C4_name(iROOM,iUNIT),',',...
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
    
    % 出力するファイル名
    if isempty(strfind(inputfilename,'/'))
        eval(['resfilenameD = ''calcRESdetail_L_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(inputfilename,'/');
        eval(['resfilenameD = ''calcRESdetail_L_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % 出力
    fid = fopen(resfilenameD,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i,:});
    end
    fclose(fid);
    
end


% 日別に積算する。
Edesign_MWh_day = [];
for dd = 1:365
    Edesign_MWh_day(dd,1) = sum( Edesign_MWh_hour(24*(dd-1)+1:24*dd,1));
end


%% 時系列データの出力
if OutputOptionVar == 1
    
    if isempty(strfind(inputfilename,'/'))
        eval(['resfilenameH = ''calcREShourly_L_',inputfilename(1:end-4),'_',datestr(now,30),'.csv'';'])
    else
        tmp = strfind(inputfilename,'/');
        eval(['resfilenameH = ''calcREShourly_L_',inputfilename(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
    end
    
    % 月：日：時
    TimeLabel = zeros(8760,3);
    for dd = 1:365
        for hh = 1:24
            % 1月1日0時からの時間数
            num = 24*(dd-1)+hh;
            t = datenum(2015,1,1) + (dd-1) + (hh-1)/24;
            TimeLabel(num,1) = str2double(datestr(t,'mm'));
            TimeLabel(num,2) = str2double(datestr(t,'dd'));
            TimeLabel(num,3) = str2double(datestr(t,'hh'));
        end
    end
    
    RESALL = [ TimeLabel,Edesign_MWh_hour];
    
    rfc = {};
    rfc = [rfc;'月,日,時,照明電力消費量[MWh]'];
    rfc = mytfunc_oneLinecCell(rfc,RESALL);
    
    fid = fopen(resfilenameH,'w+');
    for i=1:size(rfc,1)
        fprintf(fid,'%s\r\n',rfc{i});
    end
    fclose(fid);
    
end


%% コジェネ用の変数
if exist('CGSmemory.mat','file') == 0
    CGSmemory = [];
else
    load CGSmemory.mat
end

CGSmemory.RESALL(:,12) = Edesign_MWh_day;

save CGSmemory.mat CGSmemory


