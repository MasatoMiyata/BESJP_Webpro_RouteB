% mytfunc_csv2xml_AC_RoomList.m
%                                             by Masato Miyata 2012/02/12
%------------------------------------------------------------------------
% 省エネ基準：機器拾い表（csvファイル）を読みこみ、XMLファイルを吐き出す。
% 室の設定ファイルを読み込む。
%------------------------------------------------------------------------
function xmldata = mytfunc_csv2xml_AC_RoomList(xmldata,filename)

% 空調室定義ファイルの読み込み
roomDefDataCell = mytfunc_CSVfile2Cell(filename);

% roomDefData = textread(filename,'%s','delimiter','\n','whitespace','');
% for i=1:length(roomDefData)
%     conma = strfind(roomDefData{i},',');
%     for j = 1:length(conma)
%         if j == 1
%             roomDefDataCell{i,j} = strrep(roomDefData{i}(1:conma(j)-1),'"','');
%         elseif j == length(conma)
%             roomDefDataCell{i,j}   = strrep(roomDefData{i}(conma(j-1)+1:conma(j)-1),'"','');
%             roomDefDataCell{i,j+1} = strrep(roomDefData{i}(conma(j)+1:end),'"','');
%         else
%             roomDefDataCell{i,j} = strrep(roomDefData{i}(conma(j-1)+1:conma(j)-1),'"','');
%         end
%     end
% end

% 室名が空白であれば直前の室名情報をコピーする。
for iROOM = 11:size(roomDefDataCell,1)
    if isempty(roomDefDataCell{iROOM,9}) && isempty(roomDefDataCell{iROOM,2}) == 0
        if iROOM == 11
            error('一つめの室名が空白です。')
        else
            roomDefDataCell(iROOM, 8) = roomDefDataCell(iROOM-1,8);   % 空調ゾーン階
            roomDefDataCell(iROOM, 9) = roomDefDataCell(iROOM-1,9);   % 空調ゾーン名
            roomDefDataCell(iROOM,10) = roomDefDataCell(iROOM-1,10);  % 空調機群名称（室負荷）
            roomDefDataCell(iROOM,11) = roomDefDataCell(iROOM-1,11);  % 空調機群名称（外気負荷）
        end
    end
end


% 空調ゾーンリストの作成
ZoneList_Floor = {};
ZoneList_Name  = {};
ZoneList_AHUR  = {};
ZoneList_AHUO  = {};

for iROOM = 11:size(roomDefDataCell,1)
    
    if isempty(roomDefDataCell{iROOM,9}) && isempty(roomDefDataCell{iROOM,2})
        
%         eval(['disp(''空白行を飛ばします： ',filename,'　の ',int2str(iROOM),'行目'')'])
        
    else
        
        if isempty(ZoneList_Name)
            
            if isempty(roomDefDataCell{iROOM,8}) == 0
                ZoneList_Floor = roomDefDataCell(iROOM,8);
            else
                ZoneList_Floor = 'Null';
            end
            
            ZoneList_Name  = roomDefDataCell(iROOM,9);
            
            if isempty(roomDefDataCell{iROOM,10}) == 0
                ZoneList_AHUR  = roomDefDataCell(iROOM,10);
            else
                ZoneList_AHUR  = 'Null';
            end
            
            if isempty(roomDefDataCell{iROOM,11}) == 0
                ZoneList_AHUO  = roomDefDataCell(iROOM,11);
            else
                ZoneList_AHUO  = 'Null';
            end
            
        else
            
            check = 0;
            
            for iDB = 1:length(ZoneList_Name)
                if strcmp(ZoneList_Floor(iDB),roomDefDataCell(iROOM,8)) && ...
                        strcmp(ZoneList_Name(iDB),roomDefDataCell(iROOM,9))
                    % 重複判定
                    check = 1;
                end
            end
            
            if check == 0
                % ゾーン名追加
                if isempty(roomDefDataCell{iROOM,8}) == 0
                    ZoneList_Floor = [ZoneList_Floor; roomDefDataCell(iROOM,8)];
                else
                    ZoneList_Floor = [ZoneList_Floor; 'Null'];
                end
                
                ZoneList_Name  = [ZoneList_Name; roomDefDataCell(iROOM,9)];
                
                if isempty(roomDefDataCell{iROOM,10}) == 0
                    ZoneList_AHUR  = [ZoneList_AHUR; roomDefDataCell(iROOM,10)];
                else
                    ZoneList_AHUR  = [ZoneList_AHUR; 'Null'];
                end
                
                if isempty(roomDefDataCell{iROOM,11}) == 0
                    ZoneList_AHUO  = [ZoneList_AHUO; roomDefDataCell(iROOM,11)];
                else
                    ZoneList_AHUO  = [ZoneList_AHUO; 'Null'];
                end
            end
        end
        
    end
end


% XMLに格納
for iZONE = 1:length(ZoneList_Name)
    
    eval(['xmldata.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ID = ''Z',int2str(iZONE),''';'])
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ACZoneFloor = ZoneList_Floor(iZONE);
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).ATTRIBUTE.ACZoneName  = ZoneList_Name(iZONE);
    
    % 空調機参照（室内負荷処理用）
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(1).ATTRIBUTE.Load = 'Room';
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(1).ATTRIBUTE.Name = ZoneList_AHUR(iZONE);
    
    % 空調機参照（外気処理用）
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(2).ATTRIBUTE.Load = 'OutsideAir';
    xmldata.AirConditioningSystem.AirConditioningZone(iZONE).AirHandlingUnitRef(2).ATTRIBUTE.Name = ZoneList_AHUO(iZONE);
    
    Rcount = 0;
    for iDB = 11:size(roomDefDataCell,1)
        if  strcmp(roomDefDataCell(iDB,8),ZoneList_Floor(iZONE)) && ...
                strcmp(roomDefDataCell(iDB,9),ZoneList_Name(iZONE))

            % 室を検索
            [RoomID,BldgType,RoomType,RoomArea,FloorHeight,RoomHeight] = ...
                mytfunc_roomIDsearch(xmldata,roomDefDataCell(iDB,1),roomDefDataCell(iDB,2));
            
            Rcount = Rcount + 1;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.ID           = RoomID;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomFloor    = roomDefDataCell(iDB,1);
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomName     = roomDefDataCell(iDB,2);
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.BuildingType = BldgType;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomType     = RoomType;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.FloorHeight  = FloorHeight;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomHeight   = RoomHeight;
            xmldata.AirConditioningSystem.AirConditioningZone(iZONE).RoomRef(Rcount).ATTRIBUTE.RoomArea     = RoomArea;
            
        end
    end
end

