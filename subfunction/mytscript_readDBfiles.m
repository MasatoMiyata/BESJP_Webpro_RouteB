% mytfunc_readDBfiles.m
%                                                  2012/08/23 by Masato Miyata
%------------------------------------------------------------------------------
% 省エネ基準ルートB：データベースファイルを読み込む
%------------------------------------------------------------------------------

% データベースファイル
filename_calendar             = './database/CALENDAR.csv';   % カレンダー
filename_ClimateArea          = './database/AREA.csv';       % 地域区分
filename_RoomTypeList         = './database/ROOM_SPEC_H28.csv';  % 室用途リスト
filename_roomOperateCondition = './database/ROOM_COND.csv';  % 標準室使用条件
filename_refList              = './database/REFLIST_H28.csv';    % 熱源機器リスト
filename_performanceCurve     = './database/REFCURVE_H28.csv';   % 熱源特性
filename_flowControl          = './database/FLOWCONTROL.csv'; % 搬送系の効果係数


% データベースファイル読込み（地域）
DB_climateArea = textread(filename_ClimateArea,'%s','delimiter','\n','whitespace','');
% データベースファイル読込み（カレンダー）
DB_calendar = textread(filename_calendar,'%s','delimiter','\n','whitespace','');
% データベースファイル読込み（室用途リスト）
DB_RoomType = textread(filename_RoomTypeList,'%s','delimiter','\n','whitespace','');
% データベースファイル読込み（標準室使用条件）
DB_RoomOpeCondition = textread(filename_roomOperateCondition,'%s','delimiter','\n','whitespace','');
% データベースファイル読込み（熱源機器特性）
DB_refList = textread(filename_refList,'%s','delimiter','\n','whitespace','');
% データベースファイル読込み（熱源機器特性）
DB_refCurve = textread(filename_performanceCurve,'%s','delimiter','\n','whitespace','');
% データベースファイル読込み（搬送系の効果係数）
DB_flowControl = textread(filename_flowControl,'%s','delimiter','\n','whitespace','');


%----------------------------------
% 地域ごとの季節区分の読み込み
for i=1:length(DB_climateArea)
    conma = strfind(DB_climateArea{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_climateArea{i,j} = DB_climateArea{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_climateArea{i,j}   = DB_climateArea{i}(conma(j-1)+1:conma(j)-1);
            perDB_climateArea{i,j+1} = DB_climateArea{i}(conma(j)+1:end);
        else
            perDB_climateArea{i,j} = DB_climateArea{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% カレンダーファイルの読み込み
for i=1:length(DB_calendar)
    conma = strfind(DB_calendar{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_calendar{i,j} = DB_calendar{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_calendar{i,j}   = DB_calendar{i}(conma(j-1)+1:conma(j)-1);
            perDB_calendar{i,j+1} = DB_calendar{i}(conma(j)+1:end);
        else
            perDB_calendar{i,j} = DB_calendar{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% 標準室使用条件の読み込み
for i=1:length(DB_RoomOpeCondition)
    conma = strfind(DB_RoomOpeCondition{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_RoomOpeCondition{i,j} = DB_RoomOpeCondition{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_RoomOpeCondition{i,j}   = DB_RoomOpeCondition{i}(conma(j-1)+1:conma(j)-1);
            perDB_RoomOpeCondition{i,j+1} = DB_RoomOpeCondition{i}(conma(j)+1:end);
        else
            perDB_RoomOpeCondition{i,j} = DB_RoomOpeCondition{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% 室用途リストの読み込み
for i=1:length(DB_RoomType)
    conma = strfind(DB_RoomType{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_RoomType{i,j} = DB_RoomType{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_RoomType{i,j}   = DB_RoomType{i}(conma(j-1)+1:conma(j)-1);
            perDB_RoomType{i,j+1} = DB_RoomType{i}(conma(j)+1:end);
        else
            perDB_RoomType{i,j} = DB_RoomType{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end



%----------------------------------
% 熱源リストの読み込み
for i=1:length(DB_refList)
    conma = strfind(DB_refList{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_refList{i,j} = DB_refList{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_refList{i,j}   = DB_refList{i}(conma(j-1)+1:conma(j)-1);
            perDB_refList{i,j+1} = DB_refList{i}(conma(j)+1:end);
        else
            perDB_refList{i,j} = DB_refList{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% 熱源部分負荷特性の読み込み
for i=1:length(DB_refCurve)
    conma = strfind(DB_refCurve{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_refCurve{i,j} = DB_refCurve{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_refCurve{i,j}   = DB_refCurve{i}(conma(j-1)+1:conma(j)-1);
            perDB_refCurve{i,j+1} = DB_refCurve{i}(conma(j)+1:end);
        else
            perDB_refCurve{i,j} = DB_refCurve{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

%----------------------------------
% 搬送系の効果係数の読み込み
for i=1:length(DB_flowControl)
    conma = strfind(DB_flowControl{i},',');
    for j = 1:length(conma)
        if j == 1
            perDB_flowControl{i,j} = DB_flowControl{i}(1:conma(j)-1);
        elseif j == length(conma)
            perDB_flowControl{i,j}   = DB_flowControl{i}(conma(j-1)+1:conma(j)-1);
            perDB_flowControl{i,j+1} = DB_flowControl{i}(conma(j)+1:end);
        else
            perDB_flowControl{i,j} = DB_flowControl{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

